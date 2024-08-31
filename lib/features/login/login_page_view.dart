import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/routing/routes_constant.dart';
import 'login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenSize = MediaQuery.of(context).size;

    // Responsive padding and button size
    double horizontalPadding = screenSize.width * 0.05;
    double buttonPadding = screenSize.width * 0.15;

    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenSize.width * 0.5,
                child: Image.asset('assets/jf_logo.png'),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                  hintText: "Gmail Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  // Gmail-specific email validation
                  if (!GetUtils.isEmail(value) ||
                      !value.endsWith('@gmail.com')) {
                    Get.snackbar(
                      "Invalid Gmail",
                      "Please enter a valid Gmail address",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.8),
                      colorText: Colors.white,
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
                onChanged: (value) {
                  // Password validation can be done here
                  if (value.length < 6) {
                    Get.snackbar(
                      "Weak Password",
                      "Password must be at least 6 characters long",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.8),
                      colorText: Colors.white,
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {}, child: const Text('Forgot password')),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
            //      Get.toNamed(RoutesConstant.dashpage);
                  // Perform login action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                      horizontal: buttonPadding, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child:
                    const Text("Login", style: TextStyle(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 25, right: 25, bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: 75,
                        height: 45,
                        child: InkWell(
                            onTap: () {
                              //  controller.loginWithFacebook();
                            },
                            child: const Center(
                                child: Icon(
                              Icons.facebook,
                              size: 40,
                            )))),
                    SizedBox(
                        width: 75,
                        height: 45,
                        child: InkWell(
                            onTap: () {
                            //  Get.toNamed(RoutesConstant.phoneAuth);
                              // controller.loginWithPhone();
                            },
                            child: const Center(
                                child: Icon(
                              Icons.phone,
                              size: 32,
                            )))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                    //  Get.toNamed(RoutesConstant.signuppage);
                      // Navigate to sign up page
                    },
                    child: const Text("New Account",
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
