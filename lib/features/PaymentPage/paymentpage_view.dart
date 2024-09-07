import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'paymentpage_controller.dart';

class PaymentPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate the PaymentController
    final PaymentPageController paymentController =
        Get.put(PaymentPageController());

    // Fetch all payments when the view is first built
    paymentController.fetchAllPayments();

    // Define colors based on the theme
    Color primaryColor = Colors.white;
    Color secondaryColor = Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Payment Details'),
        backgroundColor: secondaryColor,
      ),
      body: Obx(() {
        // Show a loading indicator while fetching data
        if (paymentController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Check if there are no payments
        if (paymentController.payments.isEmpty) {
          return Center(
            child: Text('No payment details available.'),
          );
        }

        // ListView to display payment details
        return ListView.builder(
          itemCount: paymentController.payments.length,
          itemBuilder: (context, index) {
            // Get payment details for the current item
            Map<String, dynamic> payment = paymentController.payments[index];

            // Extract payment details
            String bookingId = payment['bookingId'] ?? 'N/A';
            double totalAmount =
                (payment['totalAmount'] as num).toDouble(); // Ensure double
            double amountReceived =(payment['amountReceived']??00 as num).toDouble(); // Ensure double

            // TextEditingController for updating the amount received by admin
            TextEditingController amountReceivedController =
                TextEditingController(
              text: amountReceived.toStringAsFixed(
                  2), // Set the current amountReceived as the initial value
            );

            // Check if payment is complete
            bool isPaymentCompleted = amountReceived >= totalAmount;

            return Card(
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                    color: secondaryColor, width: 1.5), // Thin orange border
              ),
              elevation: 5,
              color: primaryColor, // Set card color to white (primary)
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
                        color: secondaryColor, // Orange color for Booking ID
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
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
                            decoration: InputDecoration(
                              hintText: 'Enter Amount Received',
                              border: OutlineInputBorder(),
                            ),
                            enabled:
                                !isPaymentCompleted, // Disable the field if payment is completed
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        Text(
                          '₹${totalAmount.toStringAsFixed(2)}', // Using rupee symbol
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    isPaymentCompleted
                        ? Text(
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
                                double newAmountReceived = double.tryParse(
                                        amountReceivedController.text) ??
                                    amountReceived;
                          
                                // Logic to check if amountReceived is greater than totalAmount
                                if (newAmountReceived > totalAmount) {
                                  Get.snackbar(
                                    'Error',
                                    'Amount sent cannot be greater than the total amount.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } else if (newAmountReceived < amountReceived) {
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
                                backgroundColor:
                                    secondaryColor, // Orange button color
                              ),
                              child: Text('Update Amount Sent'),
                            ),
                        ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
