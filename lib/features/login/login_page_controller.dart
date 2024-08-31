import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/routing/routes_constant.dart';


class LoginPageController extends GetxController {
  RxBool isSet = true.obs;
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
 
  // void checkValidation() {
  //   if (loginKey.currentState!.validate()) {
  //   Get.offAllNamed(RoutesConstant.homepage);
  //   }
  //   return;
  // }



}
