import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/dashboard/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController>{
  const DashboardView({super.key});

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("dashboard"),
      ),
    );
  }
}