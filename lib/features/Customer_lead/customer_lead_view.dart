
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'customer_lead_controller.dart';

class CustomerLeadView extends StatelessWidget {
  final CustomerLeadController controller = Get.put(CustomerLeadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Leads'),
        centerTitle: true,
        actions: [
          Obx(() {
            return DropdownButton<String>(
              value: controller.selectedSubcollection.value.isEmpty
                  ? null
                  : controller.selectedSubcollection.value,
              hint: const Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
              dropdownColor: Colors.blueGrey,
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onChanged: (value) {
                controller.filterBySubcollection(value);
              },
              items: const [
                DropdownMenuItem(value: '', child: Text('All')),
                DropdownMenuItem(value: 'house_relocation', child: Text('House Relocation')),
                DropdownMenuItem(value: 'motorsports_relocation', child: Text('Motorsports Relocation')),
                DropdownMenuItem(value: 'automotive_relocation', child: Text('Automotive Relocation')),
                DropdownMenuItem(value: 'courier_service', child: Text('Courier Service')),
                DropdownMenuItem(value: 'event_and_exhibition', child: Text('Event & Exhibition')),
                DropdownMenuItem(value: 'pet_relocation', child: Text('Pet Relocation')),
                DropdownMenuItem(value: 'pg_relocation', child: Text('PG Relocation')),
                DropdownMenuItem(value: 'office_relocation', child: Text('Office Relocation')),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.updateFilters,
              decoration: InputDecoration(
                labelText: 'Search by Contact Person',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filteredLeads.isEmpty) {
                return const Center(
                  child: Text('No leads found.'),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredLeads.length,
                itemBuilder: (context, index) {
                  final lead = controller.filteredLeads[index];
                  final leadData = lead['data'];

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        leadData['contact_person'] ?? 'Unknown Contact Person',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${leadData['email'] ?? "N/A"}'),
                          Text('Contact No: ${leadData['contact'] ?? "N/A"}'),
                          Text('Drop Pincode: ${leadData['drop'] ?? "N/A"}'),
                          Text('Pickup Pincode: ${leadData['pickup'] ?? "N/A"}'),
                          Text('Relocation Date: ${leadData['relocation_date'] ?? "N/A"}'),
                          Text('User ID: ${leadData['userId'] ?? "N/A"}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
