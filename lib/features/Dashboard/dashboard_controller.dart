import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var selectedVendors = <String>{}.obs;
  // Observable properties
  var activeVendors = 0.obs;
  var acceptedLeads = 0.obs;
  var liveLeads = 0.obs;
  var completedLeads = 0.obs;

  // Example data for recent activity
  var recentActivities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void fetchDashboardData() {
  _firestore.collection('vendors').snapshots().listen((snapshot) {
    activeVendors.value = snapshot.size;
  });

  _firestore.collection('bookings')
    .where('status', whereIn: ['processing', 'ongoing'])
    .snapshots()
    .listen((snapshot) {
      acceptedLeads.value = snapshot.size;
    });

  _firestore.collection('bookings')
    .where('status', isEqualTo: 'completed')
    .snapshots()
    .listen((snapshot) {
      completedLeads.value = snapshot.size;
    });

  _firestore.collection('leads').snapshots().listen((snapshot) {
    liveLeads.value = snapshot.size;
  });

  _firestore.collection('activities')
    .orderBy('timestamp', descending: true)
    .limit(5)
    .snapshots()
    .listen((snapshot) {
      recentActivities.value = snapshot.docs
        .map((doc) => doc['description'] as String)
        .toList();
    });
}
}