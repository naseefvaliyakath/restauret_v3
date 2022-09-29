import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/category_data.dart';
import 'package:rest_verision_3/repository/food_repository.dart';
import 'package:rest_verision_3/repository/online_app_repository.dart';
import 'package:rest_verision_3/repository/room_repository.dart';
import 'package:rest_verision_3/repository/settled_order_response.dart';
import 'package:rest_verision_3/repository/table_chair_set_repository.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';

import '../../../api_data_loader/food_data.dart';
import '../../../api_data_loader/online_app_data.dart';
import '../../../api_data_loader/room_data.dart';
import '../../../api_data_loader/settled_order_data.dart';
import '../../../api_data_loader/table_chair_set_data.dart';
import '../../../repository/category_repository.dart';
import '../../../services/service.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    //? services
    Get.put<HttpService>(HttpService(), permanent: true);
    Get.put<FoodRepo>(FoodRepo(), permanent: true);
    Get.put<CategoryRepo>(CategoryRepo(), permanent: true);
    Get.put<RoomRepo>(RoomRepo(), permanent: true);
    Get.put<OnlineAppRepo>(OnlineAppRepo(), permanent: true);
    Get.put<SettledOrderRepo>(SettledOrderRepo(), permanent: true);
    Get.put<TableChairSetRepo>(TableChairSetRepo(), permanent: true);





    //?api data loader for initial loading data
    Get.put<FoodData>(FoodData(), permanent: true);
    Get.put<CategoryData>(CategoryData(), permanent: true);
    Get.put<OnlineAppData>(OnlineAppData(), permanent: true);
    Get.put<RoomData>(RoomData(), permanent: true);
    Get.put<SettledOrderData>(SettledOrderData(), permanent: true);
    Get.put<TableChairSetData>(TableChairSetData(), permanent: true);

    //?screen binding
    Get.lazyPut(() => TodayFoodController());
  }
}
