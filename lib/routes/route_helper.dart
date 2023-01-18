import 'package:get/get.dart';
import 'package:rest_verision_3/screens/add_food_screen/binding/add_food_binding.dart';
import 'package:rest_verision_3/screens/credit_debit_screen/binding/credit_book_binding.dart';
import 'package:rest_verision_3/screens/credit_debit_screen/credit_debit_screen.dart';
import 'package:rest_verision_3/screens/help_video_screen/video_play_screen.dart';
import 'package:rest_verision_3/screens/login_screen/binding/login_binding.dart';
import 'package:rest_verision_3/screens/login_screen/login_screen.dart';
import 'package:rest_verision_3/screens/menu_book_screen/binding/menu_book_binding.dart';
import 'package:rest_verision_3/screens/menu_book_screen/menu_setup_screen.dart';
import 'package:rest_verision_3/screens/notification_screen/binding/notification_binding.dart';
import 'package:rest_verision_3/screens/notification_screen/notification_screen.dart';
import 'package:rest_verision_3/screens/report_screen/binding/report_binding.dart';
import '../screens/add_food_screen/add_food_screen_frame.dart';
import '../screens/all_food_screen/all_food_screen.dart';
import '../screens/all_food_screen/binding/all_food_binding.dart';
import '../screens/billing_screen/billing_screen_frame.dart';
import '../screens/billing_screen/binding/billing_screen_binding.dart';
import '../screens/create_table_screen/binding/create_table_binding.dart';
import '../screens/create_table_screen/create_table_screen.dart';
import '../screens/credit_user_screen/binding/credit_user_binding.dart';
import '../screens/credit_user_screen/credit_book_user_screen.dart';
import '../screens/general_settings_page/binding/general_settings_binding.dart';
import '../screens/general_settings_page/general_settings_page.dart';
import '../screens/help_video_screen/binding/help_video_binding.dart';
import '../screens/help_video_screen/help_video_screen.dart';
import '../screens/home_screen/binding/home_screen_binding.dart';
import '../screens/home_screen/home_screen_frame.dart';
import '../screens/kitchen_mode_screen/kitchen_mode_main/binding/kitchen_mode_main_binding.dart';
import '../screens/kitchen_mode_screen/kitchen_mode_main/kitchen_mode_main_screen.dart';
import '../screens/menu_book_screen/menu_book_screen.dart';
import '../screens/order_view_screen/binding/order_view_binding.dart';
import '../screens/order_view_screen/order_view _screen.dart';
import '../screens/printer_settings_page/binding/printer_settings_binding.dart';
import '../screens/printer_settings_page/printer_settings_page.dart';
import '../screens/profile_page/profile_screen.dart';
import '../screens/purchase_book_screen/binding/purchase_book_binding.dart';
import '../screens/purchase_book_screen/purchase_book_screen.dart';
import '../screens/report_screen/report_screen_frame.dart';
import '../screens/table_manage_screen/binding/table_manage_binding.dart';
import '../screens/table_manage_screen/table_manage_screen.dart';
import '../screens/update_food_screen/binding/update_food_binding.dart';
import '../screens/update_food_screen/update_food_screen_frame.dart';

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
  static const String creditBookUserScreen = '/creditBookUserScreen';
  static const String creditDebitScreen = '/creditDebitScreen';
  static const String purchaseBookScreen = '/PurchaseBookScreen';
  static const String profileScreen = '/profileScreen';
  static const String menuBookScreen = '/menuBookScreen';
  static const String menuSetupScreen = '/menuSetupScreen';
  static const String reportScreen = '/reportScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String videoTutorialScreen = '/videoTutorialScreen';
  static const String videoPlayScreen = '/videoPlayScreen';
  static const String tableManageScreen = '/tableManageScreen';
  static const String createTableScreen = '/createTableScreen';
  static const String printerSettingsScreen = '/printerSettingsScreen';


  static String getInitial() => initial;

  static String getHome() => home;

  static String getAllFoodScreen() => allFoodScreen;

  static String getAddFoodScreen() => addFoodScreen;

  static String getUpdateFoodScreen() => updateFoodScreen;

  static String getBillingScreenScreen() => billingScreen;

  static String getOrderViewScreen() => orderViewScreen;

  static String getKitchenModeMainScreen() => kitchenModeMainScreen;

  static String getPreferenceScreen() => preferenceScreen;

  static String getCreditDebitScreen() => creditDebitScreen;

  static String getCreditBookUserScreen() => creditBookUserScreen;

  static String getPurchaseBookScreen() => purchaseBookScreen;

  static String getProfileScreen() => profileScreen;

  static String getMenuBookScreen() => menuBookScreen;

  static String getMenuSetupScreen() => menuSetupScreen;

  static String getReportScreen() => reportScreen;

  static String getNotificationScreen() => notificationScreen;

  static String getVideoTutorialScreen() => videoTutorialScreen;

  static String getVideoPlayScreen() => videoPlayScreen;

  static String getTableManageScreen() => tableManageScreen;

  static String getCreateTableScreen() => createTableScreen;

  static String getPrinterSettingsScreen() => printerSettingsScreen;





  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: home,
      page: () =>  const HomeScreenFrame(),
      binding: HomeBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: allFoodScreen,
      page: () => const AllFoodScreen(),
      binding: AllFoodBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: addFoodScreen,
      page: () =>const AddFoodScreenFrame() ,
      binding: AddFoodBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: updateFoodScreen,
      page: () => const UpdateFoodScreenFrame(),
      binding: UpdateFoodBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: billingScreen,
      page: () =>  const BillingScreenFrame(),
      binding: BillingScreenBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
        name: orderViewScreen,
        page: () => OrderViewScreen(),
        binding: OrderViewBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: kitchenModeMainScreen,
        page: () => KitchenModeMainScreen(),
        binding: KitchenModeMainBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: preferenceScreen,
        page: () => const GeneralSettingsScreen(),
        binding: GeneralSettingsBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: purchaseBookScreen,
        page: () => const PurchaseBookScreen(),
        binding: PurchaseBookBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: creditBookUserScreen,
        page: () =>  const CreditBookUserScreen(),
         binding: CreditUserBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: creditDebitScreen,
        page: () => const CreditDebitScreen(),
        binding: CreditDebitBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: profileScreen,
        page: () => const ProfilePageScreen(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: menuBookScreen,
        page: () => const MenuBookScreen(),
        binding: MenuBookBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: menuSetupScreen,
        page: () => const MenuSetupScreen(),
        binding: MenuBookBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: reportScreen,
        page: () =>   const ReportScreenFrame(),
        binding: ReportBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: notificationScreen,
        page: () => const NotificationScreen(),
        binding: NotificationBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: videoTutorialScreen,
        page: () => const HelpVideoScreen(),
        binding: HelpVideoBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: videoPlayScreen,
        page: () => const VideoPlayScreen(),
        binding: HelpVideoBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),
    GetPage(
        name: tableManageScreen,
        page: () => const PcTableManageScreen(),
        binding: TableManageBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),

    GetPage(
        name: createTableScreen,
        page: () => const CreateTableScreen(),
        binding: CreateTableBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),

    GetPage(
        name: printerSettingsScreen,
        page: () => const PrinterSettingsScreen(),
        binding: PrinterSettingsBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400)),

  ];
}
