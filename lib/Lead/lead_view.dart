import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lead_controller.dart';

class LeadView extends StatelessWidget {
  final LeadController controller = Get.put(LeadController());
  final TextEditingController pickupAddressController = TextEditingController();
  final TextEditingController dropAddressController = TextEditingController();
  final TextEditingController laborRequiredController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lead Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: controller.typeOfVehicleRequired,
                items: [
                  DropdownMenuItem(value: "Truck", child: Text("Truck")),
                  DropdownMenuItem(value: "Van", child: Text("Van")),
                  DropdownMenuItem(value: "Car", child: Text("Car")),
                ],
                onChanged: (value) {
                  controller.typeOfVehicleRequired = value;
                },
                decoration: InputDecoration(labelText: "Type of Vehicle Required"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: pickupAddressController,
                decoration: InputDecoration(labelText: "Pickup Address"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: dropAddressController,
                decoration: InputDecoration(labelText: "Drop Address"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: laborRequiredController,
                decoration: InputDecoration(labelText: "Number of Labor Required"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Validate inputs
                  if (controller.typeOfVehicleRequired != null &&
                      pickupAddressController.text.isNotEmpty &&
                      dropAddressController.text.isNotEmpty &&
                      laborRequiredController.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {

                    try {
                      // Convert addresses to coordinates
                      final pickupCoordinates = await controller.getCoordinatesFromAddress(pickupAddressController.text);
                      final dropCoordinates = await controller.getCoordinatesFromAddress(dropAddressController.text);

                      // Create task details
                      Map<String, dynamic> taskDetails = {
                        'pickup_location': pickupCoordinates,
                        'drop_location': dropCoordinates,
                        'vehicle_type': controller.typeOfVehicleRequired!,
                        'laborRequired': int.parse(laborRequiredController.text),
                        'amount': double.parse(amountController.text),
                      };

                      // Create the lead
                      await controller.createLead(pickupAddressController.text, taskDetails);
                      Get.snackbar("Success", "Lead has been created successfully");
                    } catch (e) {
                      Get.snackbar("Error", "Failed to create lead: $e");
                    }
                  } else {
                    Get.snackbar("Error", "Please fill in all fields");
                  }
                },
                child: Text("Send Lead"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
