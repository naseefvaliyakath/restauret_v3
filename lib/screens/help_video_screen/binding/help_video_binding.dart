import 'package:get/get.dart';
import '../controller/help_video_controller.dart';
import '../controller/video_play_screen_controller.dart';

class HelpVideoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpVideoController());
    Get.lazyPut(() => VideoPlayScreenCtrl());
  }
}
