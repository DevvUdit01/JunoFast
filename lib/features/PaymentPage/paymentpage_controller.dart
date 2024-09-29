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
    fetchAllPayments(); // Fetch payments when the controller is initialized
  }

  // Fetch all payments from Firestore
  void fetchAllPayments() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('payments')
          .get(); 

      payments.value = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; 
        return data;
      }).toList();

      // Clear existing controllers when payments are refreshed
      textControllers.clear();

    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch payments: $e');
    } finally {
      isLoading(false);
    }
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

      int paymentIndex = payments.indexWhere((payment) => payment['id'] == paymentId);
      if (paymentIndex != -1) {
        payments[paymentIndex]['amountReceived'] = newAmountReceived;
        payments.refresh(); // Refresh the UI
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