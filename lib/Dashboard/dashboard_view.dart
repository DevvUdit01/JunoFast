import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/dashboard/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController>{
  const DashboardView({super.key});

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assign Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: controller.vehicleController,
              decoration: InputDecoration(labelText: 'Vehicle Type'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String city = controller.cityController.text.trim();
                String vehicleType = controller.vehicleController.text.trim();
                if (city.isNotEmpty && vehicleType.isNotEmpty) {
                  Map<String, dynamic> taskDetails = {
                    'description': 'Sample Task', // Add more details as needed
                  };
                  controller.findAndAssignTask(city, vehicleType, taskDetails);
                }
              },
              child: Text('Assign Task'),
            ),
          ],
        ),
      ),
    );
  }
}