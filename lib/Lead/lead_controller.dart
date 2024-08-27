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

  // Late initialization of accessToken
  late String accessToken;

  @override
  void onInit() {
    super.onInit();
    _initializeAccessToken();
  }

  // Asynchronously initialize the accessToken
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
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Geocoding request timed out');
        },
      );

      if (locations.isNotEmpty) {
        return GeoPoint(locations[0].latitude, locations[0].longitude);
      } else {
        throw Exception("No coordinates found for the address");
      }
    } catch (e) {
      print("Error getting coordinates: $e");
      rethrow;
    }
  }

  Future<void> createLead(String pickupAddress, Map<String, dynamic> bookingDetails) async {
    try {
      // Convert pickup address to coordinates
      GeoPoint pickupLocation = await getCoordinatesFromAddress(pickupAddress);

      // Ensure `bookingDetails` contains the `drop_location` as a `GeoPoint` and `vehicleType` as a `String`
      if (bookingDetails['drop_location'] is! GeoPoint) {
        throw Exception('Drop location must be of type GeoPoint');
      }
      if (bookingDetails['vehicleType'] is! String) {
        throw Exception('Vehicle type must be of type String');
      }

      // Create a new lead document in Firestore
      DocumentReference leadRef = _firestore.collection('leads').doc();
      await leadRef.set({
        'leadId': leadRef.id,
        'pickup_location': pickupLocation,
        'drop_location': bookingDetails['drop_location'],
        'vehicleType': bookingDetails['vehicleType'],
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Find vendors and notify them
      await findAndNotifyVendors(leadRef.id, pickupLocation, bookingDetails['vehicleType']);
    } catch (e) {
      print("Error creating lead: $e");
    }
  }

  Future<void> findAndNotifyVendors(String leadId, GeoPoint pickupLocation, String vehicleType) async {
    try {
      var vendorsSnapshot = await _firestore.collection('vendors').get();
      var pickupLat = pickupLocation.latitude;
      var pickupLng = pickupLocation.longitude;
      double radius = 80; // Radius in kilometers
      List<String> vendorIds = [];
      List<String> vendorTokens = [];

      for (var vendorDoc in vendorsSnapshot.docs) {
        if (vendorDoc.data().containsKey('location') && vendorDoc.data().containsKey('fcmToken')) {
          var vendorLocation = vendorDoc['location'] as GeoPoint;
          var vendorVehicleType = (vendorDoc['vehicleType'] as String).toLowerCase(); // Convert to lowercase
          var bookingVehicleType = vehicleType.toLowerCase(); // Convert to lowercase

          var distance = Geolocator.distanceBetween(
            pickupLat, pickupLng,
            vendorLocation.latitude, vendorLocation.longitude,
          ) / 1000; // Convert meters to kilometers

          // Debug output
          print('Vendor ID: ${vendorDoc.id}');
          print('Vendor Location: ${vendorLocation.latitude}, ${vendorLocation.longitude}');
          print('Distance: $distance km');
          print('Vendor Vehicle Type: $vendorVehicleType');
          print('Booking Vehicle Type: $bookingVehicleType');

          if (distance <= radius && vendorVehicleType == bookingVehicleType) {
            vendorIds.add(vendorDoc.id);
            vendorTokens.add(vendorDoc['fcmToken'] as String);
          }
        }
      }

      if (vendorIds.isNotEmpty) {
        await sendNotifications(vendorTokens, "New Booking Available", "A new booking has been created that matches your vehicle type.");
        for (String vendorId in vendorIds) {
          await _firestore.collection('vendors').doc(vendorId).update({
            'bookings': FieldValue.arrayUnion([leadId])
          });
        }
      } else {
        print("No vendors are currently within 80 km radius.");
      }
    } catch (e) {
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
        'token': token, // Single token per message
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
      ).timeout(Duration(seconds: 10));

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
