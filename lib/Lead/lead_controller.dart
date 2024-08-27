import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

class LeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String serverKey = 'AIzaSyDnoX5PtjmlCYVhYS5QO9QPJQHLilIPr7E'; // Replace with your FCM server key

  String? typeOfVehicleRequired;

  Future<GeoPoint> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address).timeout(
        Duration(seconds: 10),
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

    // Create a new lead document in Firestore
    DocumentReference leadRef = _firestore.collection('leads').doc();
    await leadRef.set({
      'leadId': leadRef.id,
      'pickup_location': pickupLocation,
      'drop_location': bookingDetails['drop_location'],
      'vehicle_type': bookingDetails['vehicle_type'],
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Find vendors and notify them
    await findAndNotifyVendors(leadRef.id, pickupLocation, bookingDetails['vehicle_type']);
  } catch (e) {
    print("Error creating lead: $e");
  }
}

Future<void> findAndNotifyVendors(String leadId, GeoPoint pickupLocation, String vehicleType) async {
  try {
    // Retrieve all vendors from Firestore
    var vendorsSnapshot = await _firestore.collection('vendors').get();
    var pickupLat = pickupLocation.latitude;
    var pickupLng = pickupLocation.longitude;
    double radius = 80; // Radius in kilometers
    List<String> vendorIds = [];
    List<String> vendorTokens = [];

    for (var vendorDoc in vendorsSnapshot.docs) {
      if (vendorDoc.data().containsKey('location') && vendorDoc.data().containsKey('fcmToken')) {
        var vendorLocation = vendorDoc['location'] as GeoPoint;
        var vendorVehicleType = vendorDoc['vehicle_type'] as String;

        // Calculate distance between pickup location and vendor location
        var distance = Geolocator.distanceBetween(
          pickupLat, pickupLng,
          vendorLocation.latitude, vendorLocation.longitude,
        ) / 1000; // Convert meters to kilometers

        // Check if vendor is within the specified radius and matches vehicle type
        if (distance <= radius && vendorVehicleType == vehicleType) {
          vendorIds.add(vendorDoc.id);
          vendorTokens.add(vendorDoc['fcmToken'] as String);
        }
      }
    }

    if (vendorIds.isNotEmpty) {
      // Send notifications to qualifying vendors
      await sendNotifications(vendorTokens, "New Booking Available", "A new booking has been created that matches your vehicle type.");

      // Update vendor documents with the new booking
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
    final String url = 'https://fcm.googleapis.com/fcm/send';
    final Map<String, dynamic> notification = {
      'title': title,
      'body': body,
    };
    final Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'status': 'done',
    };

    for (int i = 0; i < fcmTokens.length; i += 100) {
      var batchTokens = fcmTokens.sublist(
        i, 
        i + 100 > fcmTokens.length ? fcmTokens.length : i + 100
      );

      final Map<String, dynamic> payload = {
        'notification': notification,
        'data': data,
        'registration_ids': batchTokens,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: json.encode(payload),
        ).timeout(Duration(seconds: 5));

        if (response.statusCode == 200) {
          print('Batch notification sent successfully.');
        } else {
          print('Failed to send batch notification.');
        }
      } catch (e) {
        print('Error sending notification: $e');
      }
    }
  }
}
