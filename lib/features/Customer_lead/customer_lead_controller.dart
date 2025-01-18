import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CustomerLeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list to store all leads
  var leads = [].obs;
   final subcollections = [
          'house_relocation',
          'motorsports_relocation',
          'automotive_relocation',
          'courier_service',
          'event_and_exhibition',
          'pet_relocation',
          'pg_relocation',
          'office_relocation',
        ];

  @override
void onInit() {
  super.onInit();
  fetchAllLeads();
}


  // Fetch all leads from subcollections
  // Future<void> fetchAllLeads() async {
  //   leads.clear(); // Clear existing data
  //   try {
  //     final mainCollectionSnapshot = await _firestore.collection('customer_lead').get();

  //     for (var customerDoc in mainCollectionSnapshot.docs) {
  //       if (!customerDoc.exists) continue; // Skip non-existent documents

  //       // Manually list subcollection names
        final subcollectionNames = [
          'house_relocation',
          'motorsports_relocation',
          'automotive_relocation',
          'courier_service',
          'event_and_exhibition',
          'pet_relocation',
          'pg_relocation',
          'office_relocation',
        ];

  //       for (var subcollectionName in subcollectionNames) {
  //         // Fetch each subcollection for the customer document
  //         final subcollectionSnapshot = await customerDoc.reference.collection(subcollectionName).get();

  //         for (var leadDoc in subcollectionSnapshot.docs) {
  //           leads.add({
  //             'id': leadDoc.id,
  //             'data': leadDoc.data(),
  //             'subcollection': subcollectionName,
  //           });
  //         }
  //       }
  //     }
  //
  //     print('Fetched leads: ${leads.length}');
  //   } catch (e) {
  //     print('Error fetching leads: $e');
  //     Get.snackbar('Error', 'Failed to fetch leads: $e');
  //   }
  // }


  // Fetch relocation documents
  Future<void> fetchAllLeads() async {
    try {
      leads.clear(); // Clear existing data
      for (var subcollection in subcollections) {
        // Fetch documents from each sub-collection
        final QuerySnapshot snapshot = await _firestore
            .collection('customer_lead') // Parent collection
            .doc('customer_lead') // Document ID
            .collection(subcollection) // Sub-collection name
            .get();

        for (var doc in snapshot.docs) {
          leads.add({
            'id': doc.id,
            'data': doc.data(),
            'subcollection': subcollection, // Include the sub-collection name
          });
        }
      }
      print('Fetched ${leads.length} leads from sub-collections.');
    } catch (e) {
      print('Error fetching leads: $e');
      Get.snackbar('Error', 'Failed to fetch leads: $e');
    }
  }
}