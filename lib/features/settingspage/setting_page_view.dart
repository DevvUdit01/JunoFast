import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'setting_page_controller.dart';

class SettingPageView extends GetView<SettingPageController> {
  const SettingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader("GENERAL"),
              cartButton("Account", Icons.account_circle, Icons.arrow_forward_ios, () {
                // Get.toNamed(RouteConstant.profile);
              }),
              cartButton("Passenger Master List", Icons.list, Icons.arrow_forward_ios, () {
                // controller.showPassengerMasterList();
              }),
              cartButton("Notification", Icons.notifications_none, Icons.arrow_forward_ios, () {}),
              cartButton("Coupons", Icons.card_giftcard, Icons.arrow_forward_ios, () {}),
              cartButton("Logout", Icons.logout, Icons.arrow_forward_ios, () {
                controller.logOut();
              }),
              cartButton("Delete Account", Icons.delete, Icons.arrow_forward_ios, () {}),
              sectionHeader("FEEDBACK"),
              cartButton("Report a bug", Icons.report_problem_outlined, Icons.arrow_forward_ios, () {}),
              cartButton("Send feedback", Icons.feedback_outlined, Icons.arrow_forward_ios, () {}),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for section headers with orange color
  Widget sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.01),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Get.height * 0.03,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  // Updated cartButton with white and orange theme
  Widget cartButton(String fieldName, IconData leadIcon, IconData trailIcon, VoidCallback voidCallback) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // White background for button
          borderRadius: BorderRadius.circular(Get.height * 0.01),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2), // Soft orange shadow
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          onTap: voidCallback,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Get.height * 0.01),
          ),
          leading: Icon(
            leadIcon,
            color: Colors.orange, // Orange icon color
          ),
          title: Text(
            fieldName,
            style: TextStyle(
              color: Colors.black, // Text color
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            trailIcon,
            color: Colors.orange, // Orange trailing icon
          ),
        ),
      ),
    );
  }
}
