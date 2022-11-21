import 'package:get/get.dart';

import '../../../../hive_database/controller/hive_hold_bill_controller.dart';
import '../../../../socket/socket_controller.dart';
import '../../../order_view_screen/controller/order_view_controller.dart';
import '../controller/kitchen_mode_main_controller.dart';



class KitchenModeMainBinding implements Bindings {
  @override
  void dependencies() {
    //? socket controllers
    Get.put<SocketController>(SocketController());

    Get.put<HiveHoldBillController>(HiveHoldBillController());
    Get.put<KitchenModeMainController>(KitchenModeMainController());

    Get.lazyPut(() => OrderViewController());
  }
}
