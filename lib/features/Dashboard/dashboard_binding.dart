import 'package:get/get.dart';
import 'package:junofast/features/Dashboard/dashboard_controller.dart';


class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
  
}