import 'package:get/get.dart';
import 'package:junofast/features/BookingPage/booking_binding.dart';
import 'package:junofast/features/BookingPage/booking_view.dart';
import 'package:junofast/features/Bottom%20Navigation/Bottom_navigation_binding.dart';
import 'package:junofast/features/Bottom%20Navigation/bottom_navigation_view.dart';
import 'package:junofast/features/Dashboard/dashboard_binding.dart';
import 'package:junofast/features/Dashboard/dashboard_view.dart';
import 'package:junofast/features/Lead/lead_binding.dart';
import 'package:junofast/features/Lead/lead_view.dart';
import 'package:junofast/features/SendLeadToSelectedVendor.dart/SendLeadToSelectedVendor_Binding.dart';
import 'package:junofast/features/SendLeadToSelectedVendor.dart/SendLeadToSelectedVendor_View.dart';
import 'package:junofast/features/ShowAllVendors/showAllVendors_Binding.dart';
import 'package:junofast/features/ShowAllVendors/showAllVendors_View.dart';
import 'package:junofast/features/ShowLiveLead/showLiveLead_Binding.dart';
import 'package:junofast/features/ShowLiveLead/showLiveLead_view.dart';
import 'package:junofast/routing/routes_constant.dart';
import '../features/settingspage/setting_page_binding.dart';
import '../features/settingspage/setting_page_view.dart';


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
    GetPage(
    name: RoutesConstant.setting, 
    page:()=>const SettingPageView(),
    binding: SettingPageBinding(),
    ),
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
  GetPage(
      name: RoutesConstant.Lead,
      page: () => LeadView(),
      binding: LeadBinding(),
    ),

  GetPage(
      name: RoutesConstant.booking,
      page: () => BookingPageView(),
      binding: BookingPageBinding(),
    ),
      GetPage(
      name: RoutesConstant.showLiveLead,
      page: () =>const ShowLiveLeadView(),
      binding: ShowLiveLeadBinding(),
    ),
       GetPage(
      name: RoutesConstant.showAllVendors,
      page: () =>const ShowAllVendorsView(),
      binding: ShowAllVendorsBinding(),
    ),
       GetPage(
      name: RoutesConstant.sendLeadToSelectedVendor,
      page: () =>const SendLeadToSelectedVendorView(),
      binding: SendLeadToSelectedVendorBinding(),
    ),
];
  