import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CustomerLeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list to store all leads
  var leads = [].obs;

  @override
void onInit() {
  super.onInit();
  fetchAllLeads();
}


  // Fetch all leads from subcollections
  Future<void> fetchAllLeads() async {
    leads.clear(); // Clear existing data
    try {
      final mainCollectionSnapshot = await _firestore.collection('customer_lead').get();

      for (var customerDoc in mainCollectionSnapshot.docs) {
        if (!customerDoc.exists) continue; // Skip non-existent documents

        // Manually list subcollection names
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

        for (var subcollectionName in subcollectionNames) {
          // Fetch each subcollection for the customer document
          final subcollectionSnapshot = await customerDoc.reference.collection(subcollectionName).get();

          for (var leadDoc in subcollectionSnapshot.docs) {
            leads.add({
              'id': leadDoc.id,
              'data': leadDoc.data(),
              'subcollection': subcollectionName,
            });
          }
        }
      }

      print('Fetched leads: ${leads.length}');
    } catch (e) {
      print('Error fetching leads: $e');
      Get.snackbar('Error', 'Failed to fetch leads: $e');
    }
  }
}