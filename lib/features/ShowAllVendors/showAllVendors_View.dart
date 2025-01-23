import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'showAllVendors_Controller.dart';

class ShowAllVendorsView extends GetView<ShowAllVendorsController> {
  const ShowAllVendorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Vendors'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No vendors available.'));
                }

                var vendors = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    var vendor = vendors[index];
                    return Card(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text("Name: ${vendor['name']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Address: ${vendor['address']}"),
                            Text("Mobile Number: ${vendor['mobileNumber']}"),
                            // Properly handle the 'leadPermission' field if it's a list
                            Text(
                              "Type of lead accepting: ${_formatListToString(vendor['leadPermission'])}",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format List<dynamic> as a String
  String _formatListToString(dynamic list) {
    if (list is List) {
      return list.join(', '); // Convert the list to a comma-separated string
    }
    return list.toString(); // Return as a string if it's not a list
  }
}
