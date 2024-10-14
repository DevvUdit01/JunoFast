import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentPageController extends GetxController {
  var isLoading = false.obs;
  var payments = <Map<String, dynamic>>[].obs;

  // Store TextEditingControllers for each payment item
  final Map<String, TextEditingController> textControllers = {};

  @override
  void onInit() {
    super.onInit();
    listenToPayments(); // Listen for real-time updates when the controller is initialized
  }

  // Listen to real-time changes in the 'payments' collection
  void listenToPayments() {
    FirebaseFirestore.instance
        .collection('payments')
        .snapshots() // Listen for real-time updates
        .listen((snapshot) {
      isLoading(true); // Show loading indicator

      payments.value = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Store document ID
        return data;
      }).toList();

      // Clear existing controllers when payments are refreshed
      textControllers.clear();

      isLoading(false); // Hide loading indicator
    }, onError: (e) {
      isLoading(false);
      Get.snackbar('Error', 'Failed to fetch payments: $e');
    });
  }

  // Get TextEditingController for each payment based on payment ID
  TextEditingController getTextEditingController(String paymentId, double initialValue) {
    if (!textControllers.containsKey(paymentId)) {
      textControllers[paymentId] = TextEditingController(
        text: initialValue.toStringAsFixed(2),
      );
    }
    return textControllers[paymentId]!;
  }

  // Update the amountReceived field in Firestore
  Future<void> updateAmountReceived(String paymentId, double newAmountReceived) async {
    try {
      var paymentRef = FirebaseFirestore.instance
          .collection('payments')
          .doc(paymentId);

      await paymentRef.update({
        'amountReceived': newAmountReceived,
      });

      // Find the payment in the list and update its value
      int paymentIndex = payments.indexWhere((payment) => payment['id'] == paymentId);
      if (paymentIndex != -1) {
        payments[paymentIndex]['amountReceived'] = newAmountReceived;
        payments.refresh(); // Trigger UI refresh
      }

      Get.back();
      Get.snackbar('Success', 'Amount has been updated successfully.');
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to update amount received: $e');
    }
  }

  // Dispose of TextEditingControllers when no longer needed
  @override
  void onClose() {
    for (var controller in textControllers.values) {
      controller.dispose();
      controller.clear();
    }
    super.onClose();
  }
}
