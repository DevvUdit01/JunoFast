
import 'package:get/get.dart';
import 'package:junofast/features/ShowAccepteLead%20copy/ShowAccepteLead_Controller.dart';

class ShowAccepteLeadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ShowAccepteLeadController());
  }

}