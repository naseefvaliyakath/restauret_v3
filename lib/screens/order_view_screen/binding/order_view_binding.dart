import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../../../hive_database/controller/hive_hold_bill_controller.dart';
import '../controller/order_view_controller.dart';



class OrderViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderViewController());
  }
}
