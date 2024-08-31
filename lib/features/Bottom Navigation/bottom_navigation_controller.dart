import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  // Dummy screens for each tab
  List<Widget> pages = [
    Container(child: Center(child: Text('Home Page'))),
    Container(child: Center(child: Text('Profile Page'))),
    Container(child: Center(child: Text('Payment Page'))),
    Container(child: Center(child: Text('Notes Page'))),
    Container(child: Center(child: Text('Help Page'))),
  ];

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
