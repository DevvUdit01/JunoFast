import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class BookingPageController extends GetxController {
  var ongoingProcessingBookings = [].obs;
  var completedBookings = [].obs;
  var pickupAddress = ''.obs;
  var dropAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  void fetchBookings() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('bookings').get();

      // Clear existing lists
      ongoingProcessingBookings.clear();
      completedBookings.clear();

      // Categorize bookings based on their status
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        var status = data['status'];

        if (status == 'ongoing' || status == 'processing') {
          ongoingProcessingBookings.add(data);
        } else if (status == 'completed') {
          completedBookings.add(data);
        }
      });
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }

  Future<String> getAddressFromLatLng(GeoPoint geoPoint) async {
    if (geoPoint == null) {
      return "Address not available";
    }
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        geoPoint.latitude,
        geoPoint.longitude,
      );
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.subLocality}, (${place.postalCode}), ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return "Address not available";
    }
  }

  Future<void> getPickupAddress(Map<String, dynamic> booking) async {
    GeoPoint pickupLocation = booking['pickupLocation'];
    String address = await getAddressFromLatLng(pickupLocation);
    pickupAddress.value = address;
  }

  Future<void> getDropAddress(Map<String, dynamic> booking) async {
    GeoPoint dropLocation = booking['dropLocation'];
    String address = await getAddressFromLatLng(dropLocation);
    dropAddress.value = address;
  }
}
