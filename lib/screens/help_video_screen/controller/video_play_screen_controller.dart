import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayScreenCtrl extends GetxController {

  String videoLink = '_eawn-0G_og';
  final Uri url = Uri.parse('https://www.youtube.com/watch?v=-tcuHxWsWNY');
  String name = 'Video';
  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
  );

  @override
  void onInit() async {
    receiveGetxArgument();
    super.onInit();
  }

  receiveGetxArgument() {
    var arg = Get.arguments ?? {'link': '_eawn-0G_og', 'name': 'Video'};
    videoLink = arg['link'];
    name = arg['name'];
    controller = YoutubePlayerController(
      initialVideoId: videoLink,
    );
    update();
  }

  //? to redirect video to youtube
  Future<void> urlLaunchSingleVideo(link) async {
    Uri url = Uri.parse('https://www.youtube.com/watch?v=$link');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}