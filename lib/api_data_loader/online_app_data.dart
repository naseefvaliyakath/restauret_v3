import 'package:get/get.dart';
import 'package:rest_verision_3/models/online_app_response/online_app.dart';
import 'package:rest_verision_3/models/online_app_response/online_app_response.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';

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
    super.onInit();
  }

  Future<MyResponse> getOnlineApp() async {
    try {
      MyResponse response = await _onlineAppRepo.getOnlineApp();

      if (response.statusCode == 1) {
        OnlineAppResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allOnlineApp;
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _allOnlineApp.clear();
          _allOnlineApp.addAll(parsedResponse.data?.toList() ?? []);

          return MyResponse(statusCode: 1,data: _allOnlineApp, status: 'Success', message:  'Updated successfully');
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
      }

    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
    }finally{
      update();
    }

  }



}