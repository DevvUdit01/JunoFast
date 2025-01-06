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
              return ListTile(
                title: Text(lead['data']['field_name'] ??
                    'Unknown'), // Replace with actual field
                subtitle: Text('Subcollection: ${lead['subcollection']}'),
              );
            },
          );
        }));
  }
}
