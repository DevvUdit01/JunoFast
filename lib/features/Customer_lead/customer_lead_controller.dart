import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CustomerLeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list for customer leads
  var customerLeads = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllLeads();
  }

  // Fetch all subcollection documents dynamically
  Future<void> fetchAllLeads() async {
    try {
      isLoading.value = true;
      List<Map<String, dynamic>> allLeads = [];

      // Fetch all subcollections using `collectionGroup`
      final subcollectionsSnapshot = await _firestore.collectionGroup('leads').get();

      for (var doc in subcollectionsSnapshot.docs) {
        allLeads.add(doc.data());
      }

      customerLeads.value = allLeads;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch customer leads: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
