import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'paymentpage_controller.dart';

class PaymentPageView extends StatelessWidget {
  const PaymentPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the PaymentController
    final PaymentPageController paymentController =
      Get.put(PaymentPageController());

    // Fetch all payments when the view is first built
    paymentController.fetchAllPayments();

    // Define colors based on the theme

    return GestureDetector(
       onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Admin Payment Details'),
        ),
        body: Obx(() {
          // Show a loading indicator while fetching data
          // if (paymentController.isLoading.value) {
          //   return const Center(child: CircularProgressIndicator());
          // }
      
          // Check if there are no payments
          if (paymentController.payments.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      
          // ListView to display payment details
          return ListView.builder(
            itemCount: paymentController.payments.length,
            itemBuilder: (context, index) {
              // Get payment details for the current item
              var payment = paymentController.payments[index];
      
              // Extract payment details
              String bookingId = payment['bookingId'] ?? 'N/A';
              double totalAmount =
                  (payment['totalAmount'] as num).toDouble(); // Ensure double
              double amountReceived =(payment['amountReceived']??00 as num).toDouble(); // Ensure double
              double remainingAmount = totalAmount-amountReceived;
              // TextEditingController for updating the amount received by admin
              TextEditingController amountReceivedController =
                  TextEditingController(
                text: amountReceived.toStringAsFixed(
                    2), // Set the current amountReceived as the initial value
              );
      
              // Check if payment is complete
              bool isPaymentCompleted = amountReceived >= totalAmount;
      
              return Card(
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 1.5), // Thin orange border
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
                          color: Theme.of(context).colorScheme.secondary, // Orange color for Booking ID
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
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: amountReceivedController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter Amount Received',
                                border: OutlineInputBorder(),
                              ),
                              enabled:
                                  !isPaymentCompleted, // Disable the field if payment is completed
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
                            '₹${remainingAmount.toStringAsFixed(2)}', // Using rupee symbol
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
                            '₹${totalAmount.toStringAsFixed(2)}', // Using rupee symbol
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
                                  FocusScope.of(context).unfocus();
                                  showDialog(context: Get.overlayContext!, builder: (context) => const Center(child: CircularProgressIndicator(),),);
                                  double newAmountReceived = double.tryParse(
                                  amountReceivedController.text) ??
                                  amountReceived;
                            
                                  // Logic to check if amountReceived is greater than totalAmount
                                  if (newAmountReceived > totalAmount) {
                                    Get.back();
                                    Get.snackbar(
                                      'Error',
                                      'Amount sent cannot be greater than the total amount.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  } else if (newAmountReceived < amountReceived) {
                                    Get.back();
                                    Get.snackbar(
                                      'Error',
                                      'Amount sent cannot be less than the already received amount.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  } else {
                                    paymentController.updateAmountReceived(
                                        payment['id'], newAmountReceived);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                   backgroundColor:Theme.of(context).colorScheme.secondary // Orange button color
                                ),
                                child: const Text('Update Amount Sent',style: TextStyle(color: Colors.white),),
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