import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lead_controller.dart';

class LeadView extends StatelessWidget {
  final LeadController controller = Get.put(LeadController());
  final TextEditingController leadlocationController= TextEditingController();
  final TextEditingController pickupAddressController = TextEditingController();
  final TextEditingController dropAddressController = TextEditingController();
  final TextEditingController laborRequiredController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientNumberController = TextEditingController();
  final TextEditingController pickupDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a new lead ", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        // Show a loading indicator while fetching data
        if (controller.isloading.value) {
          return const Center(child: CircularProgressIndicator());
        }
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create a New Lead",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 20),
              // Vehicle Dropdown
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
                decoration: InputDecoration(
                  labelText: "Type of Vehicle Required",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 10),
              buildTextField("enter city to generate lead ", leadlocationController),
              SizedBox(height: 10),
              // Pickup Address
              buildTextField("Pickup Address", pickupAddressController),
              SizedBox(height: 10),
              // Drop Address
              buildTextField("Drop Address", dropAddressController),
              SizedBox(height: 10),
              // Labor Required
              buildTextField(
                "Number of Labor Required",
                laborRequiredController,
                isNumber: true,
              ),
              SizedBox(height: 10),
              // Amount
              buildTextField("Amount", amountController, isNumber: true),
              SizedBox(height: 10),
              // Client Name
              buildTextField("Client Name", clientNameController),
              SizedBox(height: 10),
              // Client Number
              buildTextField(
                "Client Number",
                clientNumberController,
                isPhone: true,
              ),
              SizedBox(height: 10),
              // Pickup Date
              TextField(
                controller: pickupDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Pickup Date",
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    pickupDateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  if (controller.typeOfVehicleRequired != null &&
                      leadlocationController.text.isNotEmpty &&
                      pickupAddressController.text.isNotEmpty &&
                      dropAddressController.text.isNotEmpty &&
                      laborRequiredController.text.isNotEmpty &&
                      amountController.text.isNotEmpty &&
                      clientNameController.text.isNotEmpty &&
                      clientNumberController.text.isNotEmpty &&
                      pickupDateController.text.isNotEmpty) {
                    try {
                      // final pickupCoordinates =
                      //     await controller.getCoordinatesFromAddress(
                      //         pickupAddressController.text);
                      // final dropCoordinates =
                      //     await controller.getCoordinatesFromAddress(
                      //         dropAddressController.text);

                      Map<String, dynamic> taskDetails = {
                        'pickupLocation':pickupAddressController.text,
                        'dropLocation': dropAddressController.text,
                        'vehicleType': controller.typeOfVehicleRequired!,
                        'laborRequired':
                        int.parse(laborRequiredController.text),
                        'amount': double.parse(amountController.text),
                        'clientName': clientNameController.text,
                        'clientNumber': clientNumberController.text,
                        'pickupDate': pickupDateController.text,
                      };

                      await controller.createLead(
                          leadlocationController.text, taskDetails);
                        controller.isloading.value = false;
                    } catch (e) {
                      Get.snackbar("Error", "Failed to create lead: $e",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  } else {
                    Get.snackbar("Error", "Please fill in all fields",
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
                child: Center(child: Text("Send Lead")),
              ),
            ],
          ),
        ),
      );
      }
      ),
    );
  }

  // Build TextField helper
  TextField buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, bool isPhone = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? TextInputType.number
          : isPhone
              ? TextInputType.phone
              : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
