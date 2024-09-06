import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/features/BookingPage/booking_view.dart';
import 'package:junofast/features/Dashboard/dashboard_view.dart';
import 'package:junofast/features/PaymentPage/paymentpage_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../settingspage/setting_page_view.dart';

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
       PersistentBottomNavBarItem(
      icon:const Icon(Icons.home,size: 30,color: Colors.white,),
      title: ("Home"),
      activeColorSecondary: Colors.white,
       inactiveColorSecondary: const Color(0xFFA7A6A6),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: const Color(0xFFA7A6A6),
    ),
      PersistentBottomNavBarItem(
      icon:const Icon(Icons.book_outlined,size: 30,color: Colors.white,),
      title: ("Booking"),
      activeColorSecondary: Colors.white,
       inactiveColorSecondary: const Color(0xFFA7A6A6),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: const Color(0xFFA7A6A6),
    ),
       PersistentBottomNavBarItem(
      icon:const Icon(Icons.payment,size: 30,color: Colors.white,),
      title: ("Payment"),
      activeColorSecondary: Colors.white,
       inactiveColorSecondary: const Color(0xFFA7A6A6),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: const Color(0xFFA7A6A6),
    ),
       PersistentBottomNavBarItem(
      icon:const Icon(Icons.settings,size: 30,color: Colors.white,),
      title: ("Setting"),
      activeColorSecondary: Colors.white,
       inactiveColorSecondary: const Color(0xFFA7A6A6),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: const Color(0xFFA7A6A6),
    ),
    ];
  }

    List<Widget> buildScreens() {
    return [
      DashboardView(),
      BookingPageView(),
      PaymentPageView(),
      SettingPageView(),
      // PaymentView(),
      // NotesView(),
      // HelpView(),
    ];
  }

  // void changePage(int index) {
  //   selectedIndex.value = index;
  // }
}
