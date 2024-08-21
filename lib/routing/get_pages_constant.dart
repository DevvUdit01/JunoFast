import 'package:get/get.dart';
import 'package:junofast/Bottom%20Navigation/Bottom_navigation_binding.dart';
import 'package:junofast/Bottom%20Navigation/bottom_navigation_view.dart';
import 'package:junofast/Dashboard/dashboard_binding.dart';
import 'package:junofast/Dashboard/dashboard_view.dart';
import 'package:junofast/routing/routes_constant.dart';


List <GetPage> getpage= [
  // GetPage(
  //   name: RoutesConstant.login, 
  //   page:()=>const LoginPageView(),
  //   binding: LoginPageBinding(),
  //   ),
  // GetPage(
  //   name: RoutesConstant.signup, 
  //   page:()=>const SignUpPageView(),
  //   binding: SignUpPageBinding(),
  //   ),
  // GetPage(
  //   name: RoutesConstant.home, 
  //   page:()=>HomePageView(),
  //   binding: HomePageBinding(),
  //   ),
  // GetPage(
  //   name: RoutesConstant.bottomnavigation, 
  //   page:()=>const BottomNavigationBarView(),
  //   binding: BottomNavigationBarBinding(),
  //   ),

  // GetPage(
  //   name: RoutesConstant.settings, 
  //   page:()=>SettingsPageView(),
  //   binding: SettingsPageBinding(),
  //   ),

  // GetPage(
  //   name: RoutesConstant.profile, 
  //   page:()=>const ProfilePageView(),
  //   binding: ProfilePageBinding(),
  //   ),
  //   GetPage(
  //   name: RoutesConstant.signup2, 
  //   page:()=>const SignUp2PageView(),
  //   binding: SignUp2PageBinding(),
  //   ),
  //   GetPage(
  //   name: RoutesConstant.splashscreen, 
  //   page:()=>const SplashScreenView(),
  //   binding: SplashScreenBinding(),
  //   ),
  //   GetPage(
  //   name: RoutesConstant.formadd, 
  //   page:()=>const FormAddView(),
  //   binding: FormAddBinding(),
  //   ),
  //   GetPage(
  //   name: RoutesConstant.imageupload, 
  //   page:()=>const ImageUploadView(),
  //   binding: ImageUploadBinding(),
  //   ),
  //   GetPage(
  //   name: RoutesConstant.otpAuthentication, 
  //   page:()=>const OtpAuthenticationView(),
  //   binding: OtpAuthenticationBinding(),
  //   ),
  GetPage(
      name: RoutesConstant.bottomnavigation,
      page: () => BottomNavigationView(),
      binding: BottomNavigationBinding(),
    ),
  GetPage(
      name: RoutesConstant.Dashboard,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
];