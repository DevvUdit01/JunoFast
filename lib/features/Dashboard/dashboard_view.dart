import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/features/Dashboard/dashboard_controller.dart';
import 'package:junofast/routing/routes_constant.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class DashboardView extends GetView<DashboardController>{
  DashboardView({super.key});
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Dashboard')),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Admin Name"),
              accountEmail: Text("AdminName@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => _controller.jumpToTab(0),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payment'),
              onTap: () => _controller.jumpToTab(1),
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Notes'),
              onTap: () => _controller.jumpToTab(2),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () => _controller.jumpToTab(3),
            ),
          ],
        ),
      ),

      body: Center(
        child: ElevatedButton(
         child: Text("create lead "),
         onPressed: () {
           Get.toNamed(RoutesConstant.Lead);
         },
        ),
      ),
    );
  }
}