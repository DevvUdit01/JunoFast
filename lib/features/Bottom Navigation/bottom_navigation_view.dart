import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/features/BookingPage/booking_view.dart';
import 'package:junofast/features/Bottom%20Navigation/bottom_navigation_controller.dart';
import 'package:junofast/features/Dashboard/dashboard_view.dart';
import 'package:junofast/routing/routes_constant.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


class BottomNavigationView extends GetView<BottomNavigationController> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      DashboardView(),
      BookingPageView(),
      DashboardView(),
      DashboardView(),
      // PaymentView(),
      // NotesView(),
      // HelpView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(icon: Icon(Icons.home), title: "Home"),
      PersistentBottomNavBarItem(icon: Icon(Icons.book_outlined), title: "Bookings"),
      PersistentBottomNavBarItem(icon: Icon(Icons.payment), title: "Payment"),
      PersistentBottomNavBarItem(icon: Icon(Icons.settings), title: "Settings"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
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
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style3,
      ),
    );
  }
}
