import 'package:get/get.dart';
import 'package:junofast/Lead/lead_controller.dart';

class LeadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LeadController());
  }

}