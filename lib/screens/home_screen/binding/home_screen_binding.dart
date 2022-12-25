import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/category_data.dart';
import 'package:rest_verision_3/repository/complaint_repository.dart';
import 'package:rest_verision_3/repository/food_repository.dart';
import 'package:rest_verision_3/repository/kot_repository.dart';
import 'package:rest_verision_3/repository/notification_repository.dart';
import 'package:rest_verision_3/repository/online_app_repository.dart';
import 'package:rest_verision_3/repository/room_repository.dart';
import 'package:rest_verision_3/repository/settled_order_repository.dart';
import 'package:rest_verision_3/repository/table_chair_set_repository.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';

import '../../../api_data_loader/food_data.dart';
import '../../../api_data_loader/settled_order_data.dart';
import '../../../repository/category_repository.dart';
import '../../../socket/socket_controller.dart';
import '../../report_screen/controller/report_controller.dart';
import '../../settings_page_screen/controller/settings_controller.dart';


class HomeBinding implements Bindings {
  @override
  void dependencies() {

    Get.put<FoodRepo>(FoodRepo(), permanent: true);
    Get.put<CategoryRepo>(CategoryRepo(), permanent: true);
    Get.put<RoomRepo>(RoomRepo(), permanent: true);
    Get.put<OnlineAppRepo>(OnlineAppRepo(), permanent: true);
    Get.put<SettledOrderRepo>(SettledOrderRepo(), permanent: true);
    Get.put<KotRepo>(KotRepo(), permanent: true);
    Get.put<TableChairSetRepo>(TableChairSetRepo(), permanent: true);
    Get.put<NotificationRepo>(NotificationRepo(), permanent: true);
    Get.put<ComplaintRepo>(ComplaintRepo(), permanent: true);

    //? settings controller (settings page)
    Get.put<SettingsController>(SettingsController(), permanent: true);

    //? socket controllers
    Get.put<SocketController>(SocketController());


    //?api data loader for initial loading data
    Get.put<FoodData>(FoodData(), permanent: true);
    Get.put<CategoryData>(CategoryData(), permanent: true);
    Get.put<SettledOrderData>(SettledOrderData(), permanent: true);


    //?screen binding
    //? today screen should permanent , else when change mode from waiter to cashier it threw error
    Get.put<TodayFoodController>(TodayFoodController(), permanent: true);
    Get.put<ReportController>(ReportController(), permanent: true);


  }
}
