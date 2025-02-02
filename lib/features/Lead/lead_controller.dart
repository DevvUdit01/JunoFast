import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:junofast/core/get_access_token.dart';

class LeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isloading = false.obs;
  late String accessToken;

  @override
  void onInit() {
    super.onInit();
    _initializeAccessToken();
  }

  Future<void> _initializeAccessToken() async {
    try {
      accessToken = await getAccessToken();
      print("Access token: $accessToken");
    } catch (e) {
      print("Failed to obtain access token: $e");
    }
  }
  String? typeOfVehicleRequired;

  Future<GeoPoint> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Geocoding request timed out');
        },
      );
      if (locations.isNotEmpty) {
        return GeoPoint(locations[0].latitude, locations[0].longitude);
      } else {
        Get.back();
        throw Exception("No coordinates found for the address");
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Failed',e.toString()+" Error getting coordinates");
      print("Error getting coordinates: $e");
      rethrow;
    }
  }

  Future<void> createLead(String leadloc, Map<String, dynamic> bookingDetails) async {
    isloading.value=true;
    try {
      GeoPoint leadLocation = await getCoordinatesFromAddress(leadloc);
      // if (bookingDetails['drop_location'] is! GeoPoint) {
      //   throw Exception('Drop location must be of type GeoPoint');
      // }
      // if (bookingDetails['vehicleType'] is! String) {
      //   throw Exception('Vehicle type must be of type String');
      // }
      DocumentReference leadRef = _firestore.collection('leads').doc();
      await leadRef.set({
        'leadId': leadRef.id,
        'pickupLocation': bookingDetails['pickupLocation'],
        'dropLocation': bookingDetails['dropLocation'],
        'leadPermission': bookingDetails['leadPermission'],
        'laborRequired': bookingDetails['laborRequired'],
        'status': 'pending',
        'amount':bookingDetails['amount'],
        'clientName':bookingDetails['clientName'],
        'clientNumber':bookingDetails['clientNumber'],
        'pickupDate': bookingDetails['pickupDate'],
        'timestamp': FieldValue.serverTimestamp(),
        'notifiedVendors': [],  // Add this field to keep track of notified vendors
      });

      await findAndNotifyVendors(leadRef.id, leadLocation, bookingDetails['leadPermission']);
      Get.snackbar("Success", "Lead has been created successfully",
      backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.back();
      Get.snackbar("Failed", e.toString()+"No lead create",
      backgroundColor: Colors.red, colorText: Colors.white);
      print("Error creating lead: $e");
    }
  }

Future<void> findAndNotifyVendors(String leadId, GeoPoint pickupLocation, String leadPermission) async {
  try {
    print('lead id: $leadId');
    
    // Fetch the lead document and retrieve the notifiedVendors list (or initialize if empty)
    var leadDoc = await _firestore.collection('leads').doc(leadId).get();
    List<dynamic> notifiedVendors = leadDoc.data()?['notifiedVendors'] ?? [];

    var vendorsSnapshot = await _firestore.collection('vendors').get();
    var pickupLat = pickupLocation.latitude;
    var pickupLng = pickupLocation.longitude;
    double radius = 80; // 80 km radius
    List<String> vendorIds = [];
    List<String> vendorTokens = [];

    for (var vendorDoc in vendorsSnapshot.docs) {
      if (vendorDoc.data().containsKey('location') && vendorDoc.data().containsKey('fcmToken')) {
        var vendorLocation = vendorDoc['location'];

        // Ensure vendorLocation is a map with latitude and longitude
        if (vendorLocation is Map<String, dynamic> && 
            vendorLocation.containsKey('latitude') && 
            vendorLocation.containsKey('longitude')) {

          var vendorLat = vendorLocation['latitude'] as double;
          var vendorLng = vendorLocation['longitude'] as double;

          // Check if the vendor has the booking vehicle type in the leadPermission array
          var vendorLeadPermissions = vendorDoc['leadPermission'] as List<dynamic>;
          var bookingVehicleType = leadPermission.toLowerCase();
          var distance = Geolocator.distanceBetween(
            pickupLat, pickupLng, vendorLat, vendorLng
          ) / 1000;  // Convert to kilometers

          // Check if vendor is within 80 km radius and vehicle types match
        if (distance <= radius) {
    if(vendorLeadPermissions.map((e) => e.toString().toLowerCase()).contains(bookingVehicleType) ){
    if(!notifiedVendors.contains(vendorDoc.id)) {
     vendorIds.add(vendorDoc.id);
     vendorTokens.add(vendorDoc['fcmToken'] as String);
     notifiedVendors.add(vendorDoc.id);  // Add vendor to notified list
}
    }
        
        }
        }
      }
    }

    if (vendorIds.isNotEmpty) {
      // Send FCM notifications in batch to all matching vendors
      await sendNotifications(vendorTokens, "New Booking Available", "A new booking matches your vehicle type.");
      for(String notifiedVendor in notifiedVendors){ print("notifiedVendor :$notifiedVendor");}
      // Update each vendor's document to add the lead ID to their list of bookings
      for (String vendorId in vendorIds) {
        await _firestore.collection('vendors').doc(vendorId).update({
          'bookings': FieldValue.arrayUnion([leadId]),
        });
      }

      // Update the lead document with the list of notified vendors
      await _firestore.collection('leads').doc(leadId).update({
        'notifiedVendors': notifiedVendors,
      });
    } else {
      Get.back();
      print("No vendors are within 80 km radius with matching vehicle type.");
    }
  } catch (e) {
    Get.back();
    print("Error finding vendors: $e");
  }
}



  Future<void> sendNotifications(List<String> fcmTokens, String title, String body) async {
    final String url = 'https://fcm.googleapis.com/v1/projects/junofast-e75d7/messages:send';
    final Map<String, dynamic> notification = {
      'title': title,
      'body': body,
    };
    final Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'status': 'done',
    };

    for (String token in fcmTokens) {
      final Map<String, dynamic> payload = {
        'message': {
          'notification': notification,
          'data': data,
          'token': token,
        },
        
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: json.encode(payload),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          print('Notification sent successfully to token: $token');
        } else {
          print('Failed to send notification to token: $token. Response: ${response.statusCode} ${response.body}');
        }
      } catch (e) {
        print('Error sending notification to token: $token. Error: $e');
      }
    }
  }
}