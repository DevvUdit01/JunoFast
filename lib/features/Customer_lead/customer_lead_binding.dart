import 'package:get/get.dart';

import 'customer_lead_controller.dart';

class CustomerLeadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerLeadController>(() => CustomerLeadController());
  }
}
