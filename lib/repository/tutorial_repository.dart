import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/notification_response/notification_response.dart';
import 'package:rest_verision_3/models/tutorial_model/tutorial_response.dart';

import '../constants/api_link/api_link.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class TutorialRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr = Get.find<StartupController>().showErr;

  //? get all notification
  Future<MyResponse> getAllTutorial() async {
    print('object');
    // TODO: implement getNewsHeadline
    try {
      final response =
          await _httpService.getRequestWithBody(GET_TUTORIAL, {'appPlan': Get.find<StartupController>().applicationPlan});
      TutorialResponse? parsedResponse = TutorialResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e): MyDioError.dioError(e);
      return MyResponse(
          statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'tutorialRepo',methodName: 'getAllTutorial()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }
}
