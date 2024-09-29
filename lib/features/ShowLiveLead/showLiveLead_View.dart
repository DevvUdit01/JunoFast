
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'showLiveLead_controller.dart';

class ShowLiveLeadView extends GetView<ShowLiveLeadController>{
  const ShowLiveLeadView({super.key});
 // final ShowLiveLeadController controller = Get.put(ShowLiveLeadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Leads'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('leads').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No leads available.'));
          }

          var leads = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leads.length,
            itemBuilder: (context, index) {
              var lead = leads[index];

              return Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                elevation: 4, // Adding elevation for shadow effect
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Spacing around each card
                child: ListTile(
                  title: Text("Clinet Name :- "+lead['clientName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pickup Location :- "+lead['pickupLocation']),
                      Text("Drop Location :- "+lead['dropLocation']),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}