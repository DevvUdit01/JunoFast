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
  RxBool isLoading = false.obs;
  late String accessToken;
  var selectedVendors = <String>{}.obs;
  var selectedUser = false.obs;
  String? typeOfVehicleRequired;

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

  Future<GeoPoint> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Geocoding request timed out'),
      );
      if (locations.isNotEmpty) {
        return GeoPoint(locations[0].latitude, locations[0].longitude);
      }
      throw Exception("No coordinates found for the address");
    } catch (e) {
      Get.snackbar('Failed', "$e Error getting coordinates");
      rethrow;
    }
  }

  Future<void> createLead(String leadLoc, Map<String, dynamic> bookingDetails) async {
    isLoading.value = true;
    try {
      GeoPoint? leadLocation = selectedUser.isFalse ? await getCoordinatesFromAddress(leadLoc) : null;
      DocumentReference leadRef = await _firestore.collection('leads').add({
        ...bookingDetails,
        'leadId': '',
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'notifiedVendors': [],
      });

      await leadRef.update({'leadId': leadRef.id});
      if (selectedUser.isFalse) {
        await findAndNotifyVendors(leadRef.id, leadLocation!, bookingDetails['vehicleType']);
      } else {
        await notifySelectedVendors(leadRef.id);
      }

      Get.snackbar("Success", "Lead has been created successfully", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Failed", "$e No lead created", backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading.value = false;
  }

  Future<void> notifySelectedVendors(String leadId) async {
    await _notifyVendors(leadId, selectedVendors);
  }

  Future<void> findAndNotifyVendors(String leadId, GeoPoint pickupLocation, String vehicleType) async {
    List<String> vendorIds = [];
    List<String> vendorTokens = [];
    double radius = 80; // 80 km radius

    var vendorsSnapshot = await _firestore.collection('vendors').get();
    for (var vendorDoc in vendorsSnapshot.docs) {
      var vendorLocation = vendorDoc['location'];
      var vendorVehicleType = vendorDoc['vehicleType'];

      if (_isWithinRadius(vendorLocation, pickupLocation, radius) && _isVehicleTypeMatching(vendorVehicleType, vehicleType)) {
        vendorIds.add(vendorDoc.id);
        vendorTokens.add(vendorDoc['fcmToken']);
      }
    }

    if (vendorIds.isNotEmpty) {
      await _sendNotifications(vendorTokens, "New Booking Available", "A new booking matches your vehicle type.");
      await _updateVendorBookings(vendorIds, leadId);
    } else {
      print("No vendors within 80 km radius with matching vehicle type.");
    }
  }

  bool _isWithinRadius(Map<String, dynamic> vendorLocation, GeoPoint pickupLocation, double radius) {
    // ignore: unnecessary_null_comparison
    if (vendorLocation != null) {
      double distance = Geolocator.distanceBetween(
        pickupLocation.latitude,
        pickupLocation.longitude,
        vendorLocation['latitude'],
        vendorLocation['longitude'],
      ) / 1000; // Convert to kilometers
      return distance <= radius;
    }
    return false;
  }

  bool _isVehicleTypeMatching(String vendorVehicleType, String bookingVehicleType) {
    return vendorVehicleType.toLowerCase() == bookingVehicleType.toLowerCase();
  }

  Future<void> _notifyVendors(String leadId, Set<String> vendors) async {
    List<String> vendorTokens = [];
    List<String> notifiedVendors = [];

    var vendorsSnapshot = await _firestore.collection('vendors').get();
    for (var vendorDoc in vendorsSnapshot.docs) {
      if (vendors.contains(vendorDoc.id) && vendorDoc['fcmToken'] != null) {
        vendorTokens.add(vendorDoc['fcmToken']);
        notifiedVendors.add(vendorDoc.id);
      }
    }

    if (vendorTokens.isNotEmpty) {
      await _sendNotifications(vendorTokens, "New Booking Available", "A new booking matches your vehicle type.");
      await _updateVendorBookings(notifiedVendors, leadId);
      await _firestore.collection('leads').doc(leadId).update({
        'notifiedVendors': notifiedVendors,
      });
    }
  }

  Future<void> _updateVendorBookings(List<String> vendorIds, String leadId) async {
    for (String vendorId in vendorIds) {
      await _firestore.collection('vendors').doc(vendorId).update({
        'bookings': FieldValue.arrayUnion([leadId]),
      });
    }
  }

  Future<void> _sendNotifications(List<String> fcmTokens, String title, String body) async {
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
