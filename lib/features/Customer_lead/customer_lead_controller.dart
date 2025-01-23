        import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CustomerLeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable lists for leads and filtered leads
  var leads = [].obs; // Original leads
  var filteredLeads = [].obs; // Leads after filtering
  final RxBool isLoading = true.obs;
  final RxString selectedSubcollection = ''.obs; // Current filter as an observable

  String searchQuery = ''; // Search filter query

  @override
  void onInit() {
    super.onInit();
    fetchAllLeads();
  }

  // Fetch all leads from the `customer_lead` collection
  Future<void> fetchAllLeads() async {
    try {
      isLoading.value = true;
      leads.clear();

      final QuerySnapshot snapshot = await _firestore.collection('customer_lead').get();

      for (var doc in snapshot.docs) {
        leads.add({
          'id': doc.id, // Document ID
          'data': doc.data(),
          'subCollectionName': doc['subCollectionName'], // Ensure this field exists in Firestore
        });
      }

      // Set filteredLeads to all leads initially
      filteredLeads.assignAll(leads);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error fetching leads: $e');
      Get.snackbar('Error', 'Failed to fetch leads: $e');
    }
  }

  // Update the search query and reapply filters
  void updateFilters(String query) {
    searchQuery = query.toLowerCase();
    applyFilters();
  }

  // Apply search and subcollection filters
  void applyFilters() {
    List<dynamic> tempFilteredLeads = leads;

    // Filter by subcollection
    if (selectedSubcollection.value.isNotEmpty) {
      tempFilteredLeads = tempFilteredLeads
          .where((lead) => lead['subCollectionName'] == selectedSubcollection.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      tempFilteredLeads = tempFilteredLeads
          .where((lead) {
            final contactPerson =
                lead['data']['contact_person']?.toString().toLowerCase();
            return contactPerson?.contains(searchQuery) ?? false;
          })
          .toList();
    }

    filteredLeads.assignAll(tempFilteredLeads);
  }

  // Update subcollection filter and reapply filters
  void filterBySubcollection(String? subcollection) {
    selectedSubcollection.value = subcollection ?? '';
    applyFilters();
  }
}

