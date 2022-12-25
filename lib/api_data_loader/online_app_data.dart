import 'package:get/get.dart';
import 'package:rest_verision_3/models/online_app_response/online_app.dart';
import 'package:rest_verision_3/models/online_app_response/online_app_response.dart';

import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../repository/online_app_repository.dart';
import '../screens/login_screen/controller/startup_controller.dart';

class OnlineAppData extends GetxController {
  final OnlineAppRepo _onlineAppRepo = Get.find<OnlineAppRepo>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

  //?in this array get all online app data from api through out the app working
  //? to save all online apps
  final List<OnlineApp> _allOnlineApp = [];
  List<OnlineApp> get allOnlineApp => _allOnlineApp;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<MyResponse> getOnlineApp() async {
    try {
      MyResponse response = await _onlineAppRepo.getOnlineApp();

      if (response.statusCode == 1) {
        OnlineAppResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allOnlineApp;
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _allOnlineApp.clear();
          _allOnlineApp.addAll(parsedResponse.data?.toList() ?? []);

          return MyResponse(statusCode: 1,data: _allOnlineApp, status: 'Success', message:  response.message);
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: response.message);
      }

    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'onlineAppData',methodName: 'getOnlineApp()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }finally{
      update();
    }

  }



}