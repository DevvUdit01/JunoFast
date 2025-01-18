import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customer_lead_controller.dart';

class CustomerLeadView extends StatelessWidget {
  final CustomerLeadController controller = Get.put(CustomerLeadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Leads'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.leads.isEmpty) {
          return Center(
            child: Text('No leads available.'),
          );
        }

        return ListView.builder(
          itemCount: controller.leads.length,
          itemBuilder: (context, index) {
            final lead = controller.leads[index];
            final leadData = lead['data'];
            final subcollection = lead['subcollection'];

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  leadData['company_name'] ?? 'Unknown Company',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Subcollection: $subcollection'),
              ),
            );
          },
        );
      }),
    );
  }
}
