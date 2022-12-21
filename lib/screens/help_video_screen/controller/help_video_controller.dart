import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HelpVideoController extends GetxController {
  String videoLink = '_eawn-0G_og';
  String name = 'Video';
  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
  );

  @override
  void onInit() async {
    receiveGetxArgument();
    super.onInit();
  }

  receiveGetxArgument(){
    var arg = Get.arguments ?? {'link':'_eawn-0G_og','name':'Video'};
    videoLink = arg['link'];
    name = arg['name'];
    controller = YoutubePlayerController(
      initialVideoId: videoLink,
    );
    update();
  }

}
