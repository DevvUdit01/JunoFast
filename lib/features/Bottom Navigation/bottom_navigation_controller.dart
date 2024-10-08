import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/features/BookingPage/booking_view.dart';
import 'package:junofast/features/Dashboard/dashboard_view.dart';
import 'package:junofast/features/PaymentPage/paymentpage_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../settingspage/setting_page_view.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

    List<PersistentBottomNavBarItem> navBarsItems() {
    return [
   
     buildPersistentBottomNavBarItem(Icons.home,"Home"),
     buildPersistentBottomNavBarItem(Icons.book_outlined,"Booking"),
     buildPersistentBottomNavBarItem(Icons.payment,"Payment"),
     buildPersistentBottomNavBarItem(Icons.settings,"Setting"),

    ];
  }

    List<Widget> buildScreens() {
    return [
      const DashboardView(),
      BookingPageView(),
      const PaymentPageView(),
      const SettingPageView(),
    ];
  }
}

buildPersistentBottomNavBarItem(IconData icon1,String title1){
  return PersistentBottomNavBarItem(
      icon:Icon(icon1,size: 30,color: Colors.white,),
      title: title1,
      activeColorSecondary: Colors.white,
       inactiveColorSecondary: const Color(0xFFA7A6A6),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.blue,
      
    );
}
