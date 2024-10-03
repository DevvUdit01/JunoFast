import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/routing/routes_constant.dart';
import 'lead_controller.dart';

class LeadView extends StatelessWidget {
  final LeadController controller = Get.put(LeadController());
  final TextEditingController leadlocationController = TextEditingController();
  final TextEditingController pickupAddressController = TextEditingController();
  final TextEditingController dropAddressController = TextEditingController();
  final TextEditingController laborRequiredController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientNumberController = TextEditingController();
  final TextEditingController pickupDateController = TextEditingController();
  LeadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new lead",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isloading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create a New Lead",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 20),
                // Vehicle Dropdown
                DropdownButtonFormField<String>(
                  value: controller.typeOfVehicleRequired,
                  items: const [
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
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                buildTextField(
                    "Enter city to generate lead", leadlocationController),
                const SizedBox(height: 10),
                buildTextField("Pickup Address", pickupAddressController),
                const SizedBox(height: 10),
                buildTextField("Drop Address", dropAddressController),
                const SizedBox(height: 10),
                buildTextField(
                    "Number of Labor Required", laborRequiredController,
                    isNumber: true),
                const SizedBox(height: 10),
                buildTextField("Amount", amountController, isNumber: true),
                const SizedBox(height: 10),
                buildTextField("Client Name", clientNameController),
                const SizedBox(height: 10),
                buildTextField("Client Number", clientNumberController,
                    isPhone: true),
                const SizedBox(height: 10),
                buildDatePickerField(
                    "Pickup Date", pickupDateController, context),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    if (isFormValid()) {
                      try {
                        Map<String, dynamic> taskDetails = {
                          'pickupLocation': pickupAddressController.text,
                          'dropLocation': dropAddressController.text,
                          'vehicleType': controller.typeOfVehicleRequired!,
                          'laborRequired': laborRequiredController.text,
                          'amount': double.parse(amountController.text),
                          'clientName': clientNameController.text,
                          'clientNumber': clientNumberController.text,
                          'pickupDate': pickupDateController.text,
                        };
                        showLoadingDialog(Get.overlayContext!,
                            'Lead Send Options', taskDetails);
                      } catch (e) {
                        Get.snackbar("Error", "Failed to create lead: $e",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    } else {
                      Get.snackbar("Error", "Please fill in all fields",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  child: const Center(
                      child: Text(
                    "Send Lead",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool isFormValid() {
    return controller.typeOfVehicleRequired != null &&
        leadlocationController.text.isNotEmpty &&
        pickupAddressController.text.isNotEmpty &&
        dropAddressController.text.isNotEmpty &&
        laborRequiredController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        clientNameController.text.isNotEmpty &&
        clientNumberController.text.isNotEmpty &&
        pickupDateController.text.isNotEmpty;
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
          borderSide: const BorderSide(color: Colors.orange),
        ),
      ),
    );
  }

  void showLoadingDialog(
      BuildContext context, String title, Map<String, dynamic> taskDetails) {
    AlertDialog loadingDialog = AlertDialog(
      content: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  // call create lead method
                  showDialog(
                    context: Get.overlayContext!,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                  await controller.createLead(
                      leadlocationController.text, taskDetails);
                  controller.isloading.value = false;
                  Get.offAllNamed(RoutesConstant.Dashboard);
                },
                child: const Text("Send Lead to all Vendors",
                    style: TextStyle(color: Colors.white))),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  Get.offAndToNamed(RoutesConstant.sendLeadToSelectedVendor,
                      arguments: {
                        'taskDetails': taskDetails,
                        'address': leadlocationController.text.toString(),
                      });
                },
                child: const Text(
                  "Send Lead to Selected Vendors",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return loadingDialog;
        });
  }

  // Build DatePicker Field
  Widget buildDatePickerField(
      String label, TextEditingController controller, BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.orange),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
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
          controller.text = pickedDate.toLocal().toString().split(' ')[0];
        }
      },
    );
  }
}
