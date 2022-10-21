import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../../../hive_database/controller/hive_hold_bill_controller.dart';
import '../controller/billing_screen_controller.dart';




class BillingScreenBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut(() => BillingScreenController());

  }
}
