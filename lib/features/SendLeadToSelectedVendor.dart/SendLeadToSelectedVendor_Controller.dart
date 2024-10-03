import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:junofast/core/get_access_token.dart';

class SendLeadToSelectedVendorController extends GetxController {
  var selectedVendors = <String>{}.obs;  // Set of selected vendors

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
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

   Future<void> createLead(Map<String, dynamic> bookingDetails) async {
    isLoading.value=true;
    try {
      DocumentReference leadRef = _firestore.collection('leads').doc();
      await leadRef.set({
        'leadId': leadRef.id,
        'pickupLocation': bookingDetails['pickupLocation'],
        'dropLocation': bookingDetails['dropLocation'],
        'vehicleType': bookingDetails['vehicleType'],
        'laborRequired': bookingDetails['laborRequired'],
        'status': 'pending',
        'amount':bookingDetails['amount'],
        'clientName':bookingDetails['clientName'],
        'clientNumber':bookingDetails['clientNumber'],
        'pickupDate': bookingDetails['pickupDate'],
        'timestamp': FieldValue.serverTimestamp(),
        'notifiedVendors': [],  // Add this field to keep track of notified vendors
      });

      await selectedNotifyVendors(leadRef.id);
      Get.snackbar("Success", "Lead has been created successfully",
      backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.back();
      Get.snackbar("Failed", "${e}No lead create",
      backgroundColor: Colors.red, colorText: Colors.white);
      print("Error creating lead: $e");
    }
  }

  Future<void> selectedNotifyVendors(String leadId) async {
    try {
      isLoading.value = true;
      print('Lead ID: $leadId');
      // Fetch the lead document and retrieve the notifiedVendors list (or initialize if empty)
      var leadDoc = await _firestore.collection('leads').doc(leadId).get();
      List<dynamic> notifiedVendors = leadDoc.data()?['notifiedVendors'] ?? [];

      // Fetch the selected vendors from Firestore
      var vendorsSnapshot = await _firestore.collection('vendors').get();
      List<String> vendorTokens = [];

      // Iterate through all vendor documents and notify selected vendors
      for (var vendorDoc in vendorsSnapshot.docs) {
        if (selectedVendors.contains(vendorDoc.id)) {
          // Check if vendor has a valid FCM token
          if (vendorDoc['fcmToken'] != null) {
            vendorTokens.add(vendorDoc['fcmToken'] as String);  // Add token to send notification
            notifiedVendors.add(vendorDoc.id);  // Add vendor to notified list
          }
        }
      }

      if (vendorTokens.isNotEmpty) {
        // Send notifications to the selected vendors with FCM tokens
        await sendNotifications(vendorTokens, "New Booking Available", "A new booking matches your vehicle type.");

        // Update each selected vendor's document to add the lead ID to their list of bookings
        for (String vendorId in selectedVendors) {
          await _firestore.collection('vendors').doc(vendorId).update({
            'bookings': FieldValue.arrayUnion([leadId]),  // Add the lead ID to the vendor's bookings
          });
        }

        // Update the lead document to include the notified vendors
        await _firestore.collection('leads').doc(leadId).update({
          'notifiedVendors': notifiedVendors,
        });
        print("Notifications sent to selected vendors.");
      } else {
        print("No vendors selected or no valid FCM tokens available.");
      }
    } catch (e) {
      print("Error notifying vendors: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendNotifications(List<String> fcmTokens, String title, String body) async {
    const String url = 'https://fcm.googleapis.com/v1/projects/junofast-e75d7/messages:send';
    final Map<String, dynamic> notification = {
      'title': title,
      'body': body,
    };
    final Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'status': 'done',
    };

    // Send notification to each FCM token
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
