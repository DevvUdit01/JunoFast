
import 'package:get/get.dart';

class SendLeadToSelectedVendorController extends GetxController {
  var selectedVendors = <String>{}.obs;

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // RxBool isloading = false.obs;
  // late String accessToken;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // Future<void> _initializeAccessToken() async {
  //   try {
  //     accessToken = await getAccessToken();
  //     print("Access token: $accessToken");
  //   } catch (e) {
  //     print("Failed to obtain access token: $e");
  //   }
  // }


  //  Future<void> createLead( Map<String, dynamic> bookingDetails) async {
  //   isloading.value=true;
  //   try {
  //     DocumentReference leadRef = _firestore.collection('leads').doc();
  //     await leadRef.set({
  //       'leadId': leadRef.id,
  //       'pickupLocation': bookingDetails['pickupLocation'],
  //       'dropLocation': bookingDetails['dropLocation'],
  //       'vehicleType': bookingDetails['vehicleType'],
  //       'laborRequired': bookingDetails['laborRequired'],
  //       'status': 'pending',
  //       'amount':bookingDetails['amount'],
  //       'clientName':bookingDetails['clientName'],
  //       'clientNumber':bookingDetails['clientNumber'],
  //       'pickupDate': bookingDetails['pickupDate'],
  //       'timestamp': FieldValue.serverTimestamp(),
  //       'notifiedVendors': [],  // Add this field to keep track of notified vendors
  //     });

  //     await selectedNotifyVendors(leadRef.id);
  //     Get.snackbar("Success", "Lead has been created successfully",
  //     backgroundColor: Colors.green, colorText: Colors.white);
  //   } catch (e) {
  //     Get.snackbar("Failed", e.toString()+"No lead create",
  //     backgroundColor: Colors.red, colorText: Colors.white);
  //     print("Error creating lead: $e");
  //   }
  // }



  // Future<void> selectedNotifyVendors(String leadId) async {
  //   try {
  //     print('lead id : $leadId');

  //     // Fetch the lead document and retrieve the notifiedVendors list (or initialize if empty)
  //     var leadDoc = await _firestore.collection('leads').doc(leadId).get();
  //     List<dynamic> notifiedVendors = leadDoc.data()?['notifiedVendors'] ?? [];

  //     var vendorsSnapshot = await _firestore.collection('vendors').get();
  //     List<String> vendorTokens = [];

  //     // Iterate over vendors and find those that are selected
  //     for (var vendorDoc in vendorsSnapshot.docs) {
  //       if (selectedVendors.contains(vendorDoc.id)) {
  //         // Add FCM token if available and vendor to notified list
  //         if (vendorDoc['fcmToken'] != null) {
  //           vendorTokens.add(vendorDoc['fcmToken'] as String);
  //           notifiedVendors.add(vendorDoc.id);  // Add vendor to notified list
  //         }
  //       }
  //     }

  //     if (vendorTokens.isNotEmpty) {
  //       // Send FCM notifications to all matching vendors
  //       await sendNotifications(vendorTokens, "New Booking Available", "A new booking matches your vehicle type.");

  //       // Update each vendor's document to add the lead ID to their list of bookings
  //       for (String vendorId in selectedVendors) {
  //         await _firestore.collection('vendors').doc(vendorId).update({
  //           'bookings': FieldValue.arrayUnion([leadId]),
  //         });
  //       }

  //       // Update the lead document with the list of notified vendors
  //       await _firestore.collection('leads').doc(leadId).update({
  //         'notifiedVendors': notifiedVendors,
  //       });
  //     } else {
  //       print("No vendors found or matching vehicle type.");
  //     }
  //   } catch (e) {
  //     print("Error finding vendors: $e");
  //   }
  // }

  // Future<void> sendNotifications(List<String> fcmTokens, String title, String body) async {
  //   const String url = 'https://fcm.googleapis.com/v1/projects/junofast-e75d7/messages:send';
  //   final Map<String, dynamic> notification = {
  //     'title': title,
  //     'body': body,
  //   };
  //   final Map<String, dynamic> data = {
  //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //     'status': 'done',
  //   };

  //   for (String token in fcmTokens) {
  //     final Map<String, dynamic> payload = {
  //       'message': {
  //         'notification': notification,
  //         'data': data,
  //         'token': token,
  //       },
  //     };

  //     try {
  //       final response = await http.post(
  //         Uri.parse(url),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $accessToken',
  //         },
  //         body: json.encode(payload),
  //       ).timeout(Duration(seconds: 10));

  //       if (response.statusCode == 200) {
  //         print('Notification sent successfully to token: $token');
  //       } else {
  //         print('Failed to send notification to token: $token. Response: ${response.statusCode} ${response.body}');
  //       }
  //     } catch (e) {
  //       print('Error sending notification to token: $token. Error: $e');
  //     }
  //   }
  // }
}
