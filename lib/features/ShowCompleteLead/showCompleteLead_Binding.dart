
import 'package:get/get.dart';
import 'package:junofast/features/ShowCompleteLead/showCompleteLead_Controller.dart';

class ShowCompleteLeadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ShowCompleteLeadController());
  }

}