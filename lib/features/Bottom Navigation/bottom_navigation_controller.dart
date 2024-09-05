import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/features/BookingPage/booking_view.dart';
import 'package:junofast/features/Dashboard/dashboard_view.dart';
import 'package:junofast/features/PaymentPage/paymentpage_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  // Dummy screens for each tab
  // List<Widget> pages = [
  //   Container(child: Center(child: Text('Home Page'))),
  //   Container(child: Center(child: Text('Profile Page'))),
  //   Container(child: Center(child: Text('Payment Page'))),
  //   Container(child: Center(child: Text('Notes Page'))),
  //   Container(child: Center(child: Text('Help Page'))),
  // ];

    List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(icon: Icon(Icons.home), title: "Home"),
      PersistentBottomNavBarItem(icon: Icon(Icons.book_outlined), title: "Bookings"),
      PersistentBottomNavBarItem(icon: Icon(Icons.payment), title: "Payment"),
      PersistentBottomNavBarItem(icon: Icon(Icons.settings), title: "Settings"),
    ];
  }

    List<Widget> buildScreens() {
    return [
      DashboardView(),
      BookingPageView(),
      PaymentPageView(),
      DashboardView(),
      // PaymentView(),
      // NotesView(),
      // HelpView(),
    ];
  }

  // void changePage(int index) {
  //   selectedIndex.value = index;
  // }
}
