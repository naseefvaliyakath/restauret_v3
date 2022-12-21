import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/category_data.dart';
import 'package:rest_verision_3/api_data_loader/online_app_data.dart';
import 'package:rest_verision_3/api_data_loader/room_data.dart';
import 'package:rest_verision_3/hive_database/controller/hive_delivery_address_controller.dart';
import 'package:rest_verision_3/hive_database/controller/hive_frequnt_food_controller.dart';
import '../controller/billing_screen_controller.dart';




class BillingScreenBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.put<CategoryData>(CategoryData(), permanent: true);
    Get.put<OnlineAppData>(OnlineAppData(), permanent: true);
    Get.put<RoomData>(RoomData(), permanent: true);
    Get.lazyPut(() => BillingScreenController());
    //? to handle delivery address in home delivery screen (save addr in hive , retrieve .. etc)
    Get.lazyPut(() => HiveDeliveryAddressController());
    Get.put<HiveFrequentFoodController>(HiveFrequentFoodController(),permanent: true);
  }
}
