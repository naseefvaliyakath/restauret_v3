import 'package:get/get.dart';
import 'package:rest_verision_3/screens/add_food_screen/add_food_screen.dart';
import 'package:rest_verision_3/screens/add_food_screen/binding/add_food_binding.dart';
import 'package:rest_verision_3/screens/login_screen/binding/login_binding.dart';
import 'package:rest_verision_3/screens/login_screen/login_screen.dart';
import 'package:rest_verision_3/screens/update_food_screen/update_food_screen.dart';
import '../screens/all_food_screen/all_food_screen.dart';
import '../screens/all_food_screen/binding/all_food_binding.dart';
import '../screens/billing_screen/billing_screen.dart';
import '../screens/billing_screen/binding/billing_screen_binding.dart';
import '../screens/general_settings_page/binding/general_settings_binding.dart';
import '../screens/general_settings_page/general_settings_page.dart';
import '../screens/home_screen/binding/home_screen_binding.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/kitchen_mode_screen/kitchen_mode_main/binding/kitchen_mode_main_binding.dart';
import '../screens/kitchen_mode_screen/kitchen_mode_main/kitchen_mode_main_screen.dart';
import '../screens/order_view_screen/binding/order_view_binding.dart';
import '../screens/order_view_screen/order_view _screen.dart';
import '../screens/update_food_screen/binding/update_food_binding.dart';

class RouteHelper {
  static const String initial = '/';
  static const String home = '/home';
  static const String allFoodScreen = '/all-food';
  static const String addFoodScreen = '/add-food';
  static const String updateFoodScreen = '/update-food';
  static const String billingScreen = '/billing-food';
  static const String orderViewScreen = '/order-view-screen';
  static const String kitchenModeMainScreen = '/kitchen-mode-main-screen';
  static const String preferenceScreen = '/preference-Screen';

  static String getInitial() => initial;
  static String getHome() => home;
  static String getAllFoodScreen() => allFoodScreen;
  static String getAddFoodScreen() => addFoodScreen;
  static String getUpdateFoodScreen() => updateFoodScreen;
  static String getBillingScreenScreen() => billingScreen;
  static String getOrderViewScreen() => orderViewScreen;
  static String getKitchenModeMainScreen() => kitchenModeMainScreen;
  static String getPreferenceScreen() => preferenceScreen;

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: allFoodScreen,
      page: () => const AllFoodScreen(),
      binding: AllFoodBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: addFoodScreen,
      page: () => const AddFoodScreen(),
      binding: AddFoodBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: updateFoodScreen,
      page: () => const UpdateFoodScreen(),
      binding: UpdateFoodBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: billingScreen,
      page: () => const BillingScreen(),
      binding: BillingScreenBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
        name: orderViewScreen,
        page: () => OrderViewScreen(),
        binding: OrderViewBinding(),
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: kitchenModeMainScreen,
        page: () => KitchenModeMainScreen(),
        binding: KitchenModeMainBinding(),
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: preferenceScreen,
        page: () => const GeneralSettingsScreen(),
        binding: GeneralSettingsBinding(),
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 400)),
  ];
}
