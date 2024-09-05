import 'package:get/get.dart';
import 'paymentpage_controller.dart';


class PaymentPageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentPageController());
  }

}