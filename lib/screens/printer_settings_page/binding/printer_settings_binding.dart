import 'package:get/get.dart';

import '../controller/printer_settings_controller.dart';

class PrinterSettingsBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => PrinterSettingsController());

  }
}