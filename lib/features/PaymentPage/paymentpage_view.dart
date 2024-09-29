import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'paymentpage_controller.dart';

class PaymentPageView extends StatelessWidget {
  const PaymentPageView({super.key});
  

  @override
  Widget build(BuildContext context) {
    final PaymentPageController paymentController =
        Get.put(PaymentPageController());

    // Fetch all payments once at the start
    paymentController.fetchAllPayments();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Payment Details'),
        ),
        body: Obx(() {
          // if (paymentController.isLoading.value) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          if (paymentController.payments.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: paymentController.payments.length,
            itemBuilder: (context, index) {
              var payment = paymentController.payments[index];
              String bookingId = payment['bookingId'] ?? 'N/A';
              double totalAmount =
                  (payment['totalAmount'] as num).toDouble();
              double amountReceived =
                  (payment['amountReceived'] ?? 0 as num).toDouble();
              double remainingAmount = totalAmount - amountReceived;
              bool isPaymentCompleted = amountReceived >= totalAmount;

              TextEditingController amountReceivedController =
                  paymentController.getTextEditingController(payment['id'], amountReceived);

              // Only refresh the relevant parts of the UI that depend on reactive state
              return Card(
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 1.5),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking ID: $bookingId',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Amount Sent :',
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: amountReceivedController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter Amount Received',
                                border: OutlineInputBorder(),
                              ),
                              enabled: !isPaymentCompleted, // Disable if completed
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Remaining Amount :',
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          Text(
                            '₹${remainingAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount :',
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      isPaymentCompleted
                          ? const Text(
                              'Payment Completed',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.green,
                              ),
                            )
                          : Center(
                              child: ElevatedButton(
                              onPressed: () {
  FocusScope.of(context).unfocus();  // Close the keyboard

  // Show the progress indicator only when update starts
  showDialog(
    context: Get.overlayContext!,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  // Parse the new amount received from the text field
  double newAmountReceived = double.tryParse(amountReceivedController.text) ?? amountReceived;

  if (newAmountReceived > totalAmount) {
    // Dismiss the loading dialog
    Get.back();

    // Show an error message
    Get.snackbar(
      'Error',
      'Amount sent cannot be greater than the total amount.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (newAmountReceived < amountReceived) {
    // Dismiss the loading dialog
    Get.back();

    // Show an error message
    Get.snackbar(
      'Error',
      'Amount sent cannot be less than the already received amount.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else {
    // Proceed with the update logic in the controller
    paymentController.updateAmountReceived(payment['id'], newAmountReceived);

    // Close the progress indicator once the update is successful
    Get.back();
  }
},

                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                child: const Text(
                                  'Update Amount Sent',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
