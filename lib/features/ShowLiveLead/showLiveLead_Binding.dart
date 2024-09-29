
import 'package:get/get.dart';
import 'showLiveLead_controller.dart';

class ShowLiveLeadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ShowLiveLeadController());
  }

}