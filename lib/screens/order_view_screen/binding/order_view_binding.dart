import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/settled_order_data.dart';
import '../controller/order_view_controller.dart';



class OrderViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SettledOrderData>(SettledOrderData(), permanent: true);
    Get.lazyPut(() => OrderViewController());
  }
}
