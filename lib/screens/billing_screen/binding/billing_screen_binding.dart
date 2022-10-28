import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:rest_verision_3/api_data_loader/category_data.dart';
import '../controller/billing_screen_controller.dart';




class BillingScreenBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.put<CategoryData>(CategoryData(), permanent: true);
    Get.lazyPut(() => BillingScreenController());
  }
}
