import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/features/Bottom%20Navigation/bottom_navigation_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


class BottomNavigationView extends GetView<BottomNavigationController> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SizedBox(
        child: PersistentTabView(
          context,
          controller: _controller,
          screens: controller.buildScreens(),
          items: controller.navBarsItems(),
          navBarStyle: NavBarStyle.style7,
          confineToSafeArea: true,
            backgroundColor: Colors.black, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
        ),
      ),
    );
  }
}
