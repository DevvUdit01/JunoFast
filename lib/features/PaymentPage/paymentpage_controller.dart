import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

// class PaymentPageController extends GetxController {
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   var payments = <Map<String, dynamic>>[].obs; // Observable list of payments
//   var isLoading = false.obs;

//   // Fetch payment details for the current vendor
//   Future<void> fetchVendorPayments(String vendorId) async {
//     try {
//       isLoading.value = true;

//       // Query the payments collection for the current vendor's payments
//       QuerySnapshot snapshot = await _firestore
//           .collection('payments')
//           .where('vendorId', isEqualTo: vendorId)
//           .get();

//       // Clear the list before adding new data
//       payments.clear();

//       // Map the documents to a list of payment details
//       snapshot.docs.forEach((doc) {
//         payments.add(doc.data() as Map<String, dynamic>);
//       });

//     } catch (e) {
//       print('Error fetching vendor payments: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


class PaymentPageController extends GetxController {
  var isLoading = true.obs;
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

      Get.snackbar('Success', 'Amount received has been updated successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update amount received: $e');
    }
  }
}
