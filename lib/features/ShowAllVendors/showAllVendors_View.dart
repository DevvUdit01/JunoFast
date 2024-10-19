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
                      // Wrapping vendor info in a Card with elevation
                      return Card(                        
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        elevation: 4, // Adding elevation for shadow effect
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Spacing around each card
                        child: ListTile(
                          title: Text("Name :- "+vendor['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Adress :- "+vendor['address']),
                               Text("Mobile Number :- "+vendor['mobileNumber']),
                              Text("type of lead accepting :- "+vendor['leadPermission']),
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
}
