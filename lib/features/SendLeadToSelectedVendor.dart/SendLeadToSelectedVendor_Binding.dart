
import 'package:get/get.dart';
import 'SendLeadToSelectedVendor_Controller.dart';

class SendLeadToSelectedVendorBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>SendLeadToSelectedVendorController());
  }

}