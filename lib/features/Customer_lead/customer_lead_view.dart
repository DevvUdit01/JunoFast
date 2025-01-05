import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customer_lead_controller.dart';

class CustomerLeadView extends GetView<CustomerLeadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Leads'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.customerLeads.isEmpty
                ? const Center(
                    child: Text(
                      'No customer leads found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: controller.customerLeads.length,
                    itemBuilder: (context, index) {
                      final lead = controller.customerLeads[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead['name'] ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Email: ${lead['email'] ?? 'N/A'}'),
                              Text('Contact: ${lead['contact'] ?? 'N/A'}'),
                              Text(
                                  'Pickup: ${lead['pickup'] ?? 'N/A'} - Drop: ${lead['drop'] ?? 'N/A'}'),
                              const SizedBox(height: 8),
                              Text(
                                'Relocation Date: ${lead['tentative_date'] ?? 'N/A'}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
