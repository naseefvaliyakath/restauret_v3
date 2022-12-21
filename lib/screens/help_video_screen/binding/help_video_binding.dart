import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controller/help_video_controller.dart';

class HelpVideoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpVideoController());
  }
}
