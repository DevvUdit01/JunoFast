import 'package:get/get.dart';
import 'package:junofast/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
  
}