import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'setting_page_controller.dart';

class SettingPageView extends GetView<SettingPageController> {
  const SettingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.004),
                child: Text("GENERAL", style: TextStyle(fontSize: Get.height * 0.035, fontWeight: FontWeight.w600)),
              ),
              cartButton("Account", Icons.account_circle, Icons.arrow_forward_ios, () {
                //  Get.toNamed(RouteConstant.profile);
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
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.004),
                child: Text("FEEDBACK", style: TextStyle(fontSize: Get.height * 0.035, fontWeight: FontWeight.w600)),
              ),
              cartButton("Report a bugs ", Icons.report_problem_outlined, Icons.arrow_forward_ios, () {}),
              cartButton("Send feedback", Icons.feedback_outlined, Icons.arrow_forward_ios, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget cartButton(String fieldName, IconData leadIcon, IconData trailIcon, VoidCallback voidCallback) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent.withOpacity(0.02),
          borderRadius: BorderRadius.circular(Get.height * 0.01),
        ),
        child: ListTile(
          onTap: voidCallback,
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(Get.height * 0.01), borderSide: BorderSide.none),
          leading: Icon(leadIcon),
          title: Text(fieldName),
          trailing: Icon(trailIcon),
        ),
      ),
    );
  }
}
