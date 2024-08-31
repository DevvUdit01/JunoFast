import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPageController extends GetxController {
  var bookings = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  void fetchBookings() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('bookings').get();
      bookings.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }
}
