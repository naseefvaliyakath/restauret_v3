import 'package:get/get.dart';
import '../../../hive_database/controller/hive_hold_bill_controller.dart';
import '../../../local_storage/local_storage_controller.dart';
import '../../../repository/startup_repository.dart';
import '../../../services/service.dart';
import '../controller/startup_controller.dart';


class LoginBinding implements Bindings {
  @override
  void dependencies() {

    //? local db controller
    Get.put<HiveHoldBillController>(HiveHoldBillController(),permanent: true);
    Get.put<MyLocalStorage>(MyLocalStorage(),permanent: true);

    //? services
    Get.put<HttpService>(HttpService(), permanent: true);

    //? application startup controller
    Get.put<StartupRepo>(StartupRepo(), permanent: true);
    Get.put<StartupController>(StartupController(), permanent: true);



  }
}
