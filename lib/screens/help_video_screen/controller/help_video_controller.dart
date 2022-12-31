import 'package:get/get.dart';
import 'package:rest_verision_3/models/tutorial_model/tutorial.dart';
import 'package:rest_verision_3/models/tutorial_model/tutorial_response.dart';
import 'package:rest_verision_3/repository/tutorial_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../error_handler/error_handler.dart';
import '../../../models/my_response.dart';
import '../../login_screen/controller/startup_controller.dart';

class HelpVideoController extends GetxController {
  final TutorialRepo _tutorialRepo = Get.find<TutorialRepo>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr = Get.find<StartupController>().showErr;

  //? to store notification
  final List<Tutorial> _allTutorial = [];

  List<Tutorial> get allTutorial => _allTutorial;
  String videoLink = '_eawn-0G_og';
  final Uri url = Uri.parse('https://www.youtube.com/watch?v=-tcuHxWsWNY');
  String name = 'Video';
  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
  );

  @override
  void onInit() async {
    getAllTutorial();
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

  //? to open channel in youtube (not single video)
  Future<void> urlLaunchUrl() async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }


  getAllTutorial() async {
    try {
      MyResponse response = await _tutorialRepo.getAllTutorial();
      if (response.statusCode == 1) {
        TutorialResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allTutorial;
          return;
        } else {
          _allTutorial.clear();
          _allTutorial.addAll(parsedResponse.data?.toList() ?? []);
          return;
        }
      } else {
        return;
      }
    } catch (e) {
      _errHandler.myResponseHandler(
          error: e.toString(), pageName: 'helpVideoController', methodName: 'getAllTutorial()');
      return;
    } finally {
      update();
    }
  }
}
