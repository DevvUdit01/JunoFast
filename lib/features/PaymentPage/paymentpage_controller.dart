import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PaymentPageController extends GetxController {
  var isLoading = false.obs;
  var payments = [].obs;

    // Fetch all payments from Firestore
    void fetchAllPayments() async {
      try {
        isLoading(true);
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('payments')
            .get(); // Assuming all payments are in the 'payments' collection

        // Map data to local list
        payments.value = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Store the document ID to update later
          return data;
        }).toList();
      } catch (e) {
        Get.snackbar('Error', 'Failed to fetch payments: $e');
      } finally {
        isLoading(false);
      }
    }

  // Update the amountReceived field in Firestore
  Future<void> updateAmountReceived(String paymentId, double newAmountReceived) async {
    try {
      // Reference to the payment document in Firestore
      var paymentRef = FirebaseFirestore.instance
          .collection('payments')
          .doc(paymentId);

      // Update the amountReceived field in Firestore
      await paymentRef.update({
        'amountReceived': newAmountReceived,
      });

      // If successful, update the local payment data
      int paymentIndex = payments.indexWhere((payment) => payment['id'] == paymentId);
      if (paymentIndex != -1) {
        payments[paymentIndex]['amountReceived'] = newAmountReceived;
        payments.refresh(); // Refresh the UI
      }

      Get.snackbar('Success', 'Amount has been updated successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update amount received: $e');
    }
  }
}