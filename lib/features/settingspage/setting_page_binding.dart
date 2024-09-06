
import 'package:get/get.dart';
import 'setting_page_controller.dart';

class SettingPageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SettingPageController());
  }

}