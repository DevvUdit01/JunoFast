import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/routing/routes_constant.dart';
import 'SendLeadToSelectedVendor_Controller.dart';

class SendLeadToSelectedVendorView extends GetView<SendLeadToSelectedVendorController> {
  const SendLeadToSelectedVendorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Vendors'),
        actions: [
          // Button to print or use the selected vendor list
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (controller.selectedVendors.isEmpty) {
                Get.snackbar("No Vendor Selected", "Please select at least one vendor");
              } else {
                // Do something with the selected vendors' IDs
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No vendors available.'));
                }

                var vendors = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    var vendor = vendors[index];
                    var vendorId = vendor.id; // Get the document ID for each vendor

                    return Obx(() {
                      bool isSelected = controller.selectedVendors.contains(vendorId);

                      // Wrapping vendor info in a Card with elevation
                      return Card(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        elevation: 4, // Adding elevation for shadow effect
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Spacing around each card
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
                              // Add or remove the vendor ID based on selection
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
          // Send Notification Button (Visible only if more than 1 vendor is selected)
          Obx(() {
            return controller.selectedVendors.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        
                        // Call the notification function with leadId, pickupLocation, and vehicleType
                        Get.toNamed(RoutesConstant.Lead,arguments: controller.selectedVendors);
                      },
                      child: const Text('Select Vendors'),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
