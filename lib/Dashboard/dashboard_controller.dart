import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardController extends GetxController {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var vendors = <Vendor>[].obs; // Observable list of vendors

  final String serverKey = 'AIzaSyBD5KP-Ba5eoSJFoa-mx_PeMZIGLHZH930'; // Replace with your FCM server key

  // Method to find vendors based on city and vehicle type
  Future<void> findAndAssignTask(String city, String vehicleType, Map<String, dynamic> taskDetails) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('vendors')
          .where('city', isEqualTo: city)
          .where('vehicle', isEqualTo: vehicleType)
          .get();

      List<String> vendorIds = querySnapshot.docs.map((doc) => doc.id).toList();
      List<String> vendorTokens = querySnapshot.docs.map((doc) => doc['fcmToken'] as String).toList();

      if (vendorIds.isNotEmpty) {
        await createTask(taskDetails, vendorIds);
        await sendNotifications(vendorTokens, "New Task Available", "A new task has been assigned to you.");
      } else {
        print("No vendors available for the selected city and vehicle type.");
      }
    } catch (e) {
      print("Error finding vendors: $e");
    }
  }

  // Method to create and assign a task
  Future<void> createTask(Map<String, dynamic> taskDetails, List<String> vendorIds) async {
    try {
      DocumentReference taskRef = _firestore.collection('tasks').doc();

      await taskRef.set({
        'taskId': taskRef.id,
        'taskDetails': taskDetails,
        'vendorIds': vendorIds,
        'acceptedBy': null,
        'status': 'pending',
      });

      for (String vendorId in vendorIds) {
        await _firestore.collection('vendors').doc(vendorId).update({
          'tasks': FieldValue.arrayUnion([taskRef.id])
        });
      }

      print("Task assigned to vendors: $vendorIds");
    } catch (e) {
      print("Error creating task: $e");
    }
  }

  // Method to send FCM notifications
  Future<void> sendNotifications(List<String> fcmTokens, String title, String body) async {
    final String url = 'https://fcm.googleapis.com/fcm/send';

    for (String token in fcmTokens) {
      final Map<String, dynamic> notification = {
        'title': title,
        'body': body,
      };

      final Map<String, dynamic> data = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'status': 'done',
      };

      final Map<String, dynamic> payload = {
        'notification': notification,
        'data': data,
        'to': token,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to token: $token');
      } else {
        print('Failed to send notification to token: $token');
      }
    }
  }
}

class Vendor {
  final String id;
  final String name;
  final String vehicle;
  final String city;

  Vendor({required this.id, required this.name, required this.vehicle, required this.city});

  factory Vendor.fromDocument(DocumentSnapshot doc) {
    return Vendor(
      id: doc.id,
      name: doc['name'],
      vehicle: doc['vehicle'],
      city: doc['city'],
    );
  }
}
