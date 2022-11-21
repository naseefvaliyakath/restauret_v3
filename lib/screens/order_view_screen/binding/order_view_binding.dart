import 'package:get/get.dart';
import '../controller/order_view_controller.dart';



class OrderViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderViewController());
  }
}
