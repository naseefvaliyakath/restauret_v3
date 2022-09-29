import 'package:get/get.dart';
import 'package:rest_verision_3/models/online_app_response/online_app.dart';
import 'package:rest_verision_3/models/online_app_response/online_app_response.dart';

import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../repository/online_app_repository.dart';

class OnlineAppData extends GetxController {
  final OnlineAppRepo _onlineAppRepo = Get.find<OnlineAppRepo>();

  //?in this array get all online app data from api through out the app working
  //? to save all online apps
  final List<OnlineApp> _allOnlineApp = [];
  List<OnlineApp> get allOnlineApp => _allOnlineApp;

  @override
  Future<void> onInit() async {
   // getOnlineApp();
    super.onInit();
  }

  getOnlineApp() async {
    try {
      MyResponse response = await _onlineAppRepo.getOnlineApp();

      if (response.statusCode == 1) {
        OnlineAppResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allOnlineApp;
        } else {
          _allOnlineApp.addAll(parsedResponse.data?.toList() ?? []);
        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
    update();
  }



}