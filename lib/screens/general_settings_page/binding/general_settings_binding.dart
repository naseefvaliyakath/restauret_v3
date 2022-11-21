import 'package:get/get.dart';
import '../controller/general_settings_controller.dart';

class GeneralSettingsBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => GeneralSettingsController());

  }
}