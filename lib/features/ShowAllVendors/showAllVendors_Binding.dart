
import 'package:get/get.dart';
import 'showAllVendors_Controller.dart';

class ShowAllVendorsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ShowAllVendorsController());
  }

}