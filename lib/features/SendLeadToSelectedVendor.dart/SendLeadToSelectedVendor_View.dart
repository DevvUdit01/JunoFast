import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:junofast/routing/routes_constant.dart';
import 'SendLeadToSelectedVendor_Controller.dart';

// ignore: must_be_immutable
class SendLeadToSelectedVendorView extends GetView<SendLeadToSelectedVendorController> {
  Map<String, dynamic> taskDetails = {};
  String vehicleType = '';
  String address = '';
  List<String> vendorsList = [];

  // Constructor to initialize task details and lead ID from Get.arguments
  SendLeadToSelectedVendorView({super.key}) {
    var arguments = Get.arguments;

    if (arguments != null && arguments is Map<String, dynamic>) {
      taskDetails = Map<String, dynamic>.from(arguments['taskDetails'] as Map);
      address = arguments['address'] as String;
      vehicleType = taskDetails['vehicleType'];
    } else {
      print("Error: Null received in Get.arguments");
    }
  }

  // Function to fetch coordinates from address and notify vendors
  Future<void> getCoordinatesAndNotifyVendors() async {
    try {
      List<Location> locations = await locationFromAddress(address).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Geocoding request timed out'),
      );

      if (locations.isNotEmpty) {
        GeoPoint leadLocation = GeoPoint(locations[0].latitude, locations[0].longitude);
        await findAndNotifyVendors(leadLocation, vehicleType);
      } else {
        throw Exception("No coordinates found for the address");
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Failed', "Error: $e");
      print("Error getting coordinates: $e");
    }
  }

  // Function to find vendors and notify them
  Future<void> findAndNotifyVendors(GeoPoint pickupLocation, String vehicleType) async {
    try {
      var vendorsSnapshot = await FirebaseFirestore.instance.collection('vendors').get();
      double radius = 80.0; // 80 km radius
      var pickupLat = pickupLocation.latitude;
      var pickupLng = pickupLocation.longitude;

      vendorsList = vendorsSnapshot.docs
          .where((vendorDoc) {
            var vendorLocation = vendorDoc['location'];
            var vendorVehicleType = (vendorDoc['vehicleType'] as String).toLowerCase();
            if (vendorLocation is Map<String, dynamic> &&
                vendorLocation.containsKey('latitude') &&
                vendorLocation.containsKey('longitude')) {
              var vendorLat = vendorLocation['latitude'] as double;
              var vendorLng = vendorLocation['longitude'] as double;
              var distance = Geolocator.distanceBetween(pickupLat, pickupLng, vendorLat, vendorLng) / 1000;

              return distance <= radius && vendorVehicleType == vehicleType.toLowerCase();
            }
            return false;
          })
          .map((vendorDoc) => vendorDoc.id)
          .toList();

      if (vendorsList.isNotEmpty) {
        print("Vendors found: $vendorsList");
      } else {
        print("No vendors found");
      }
    } catch (e) {
      Get.back();
      print("Error finding vendors: $e");
    }
  }

  // Fetch vendors based on vendor IDs
  Future<List<QueryDocumentSnapshot>> fetchVendorsByIds(List<String> vendorIds) async {
    if (vendorIds.isEmpty) return [];
    try {
      var vendorsSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .where(FieldPath.documentId, whereIn: vendorIds)
          .get();
      return vendorsSnapshot.docs;
    } catch (e) {
      print('Error fetching vendors: $e');
      return [];
    }
  }

  // Execute both tasks sequentially
  Future<List<QueryDocumentSnapshot>> executeVendorSearchAndFetch() async {
    await getCoordinatesAndNotifyVendors();
    if (vendorsList.isNotEmpty) {
      return await fetchVendorsByIds(vendorsList);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Vendors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (controller.selectedVendors.isEmpty) {
                Get.snackbar("No Vendor Selected", "Please select at least one vendor");
              } else {
                print("Selected Vendors: ${controller.selectedVendors}");
                Get.snackbar("Selected Vendors", controller.selectedVendors.toString());
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
              future: executeVendorSearchAndFetch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No vendors available.'));
                }

                var vendors = snapshot.data!;

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    var vendor = vendors[index];
                    var vendorId = vendor.id;

                    return Obx(() {
                      bool isSelected = controller.selectedVendors.contains(vendorId);
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          title: Text(vendor['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vendor['address']),
                              Text(vendor['vehicleType']),
                            ],
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              if (value == true) {
                                controller.selectedVendors.add(vendorId);
                              } else {
                                controller.selectedVendors.remove(vendorId);
                              }
                            },
                          ),
                        ),
                      );
                    });
                  },
                );
              },
            ),
          ),
          Obx(() {
            return controller.selectedVendors.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                       controller.isLoading.value = true; 
                        controller.createLead(taskDetails);
                        controller.isLoading.value = false;
                   Get.offAllNamed(RoutesConstant.Dashboard);
                      },
                      child: const Text('Create Lead'),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
