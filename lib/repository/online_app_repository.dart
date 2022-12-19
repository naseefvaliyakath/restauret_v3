import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../models/online_app_response/online_app_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class OnlineAppRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr = Get.find<StartupController>().showErr;

  Future<MyResponse> getOnlineApp() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(GET_ONLINE_APP, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      OnlineAppResponse parsedResponse = OnlineAppResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', data: null, message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'onlineAppRepo',methodName: 'getOnlineApp()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }

  //? insert room
  Future<MyResponse> insertOnlineApp(onlineAppName) async {
    try {
      Map<String, dynamic> onlineAppData = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'appName': onlineAppName,
      };

      final response = await _httpService.insertWithBody(INSERT_ONLINE_APP, onlineAppData);
      OnlineAppResponse parsedResponse = OnlineAppResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'onlineAppRepo',methodName: 'insertOnlineApp()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error',  message: myMessage);
    }
  }



  //? delete category
  deleteOnlineApp(int id) async {
    try {
      Map<String,dynamic>onlineAppData={
        'onlineApp_id':id,
        'fdShopId':Get.find<StartupController>().SHOPE_ID,
      };
      final response = await _httpService.delete(DELETE_ONLINE_APP,onlineAppData);
      OnlineAppResponse parsedResponse = OnlineAppResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error',  message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'onlineAppRepo',methodName: 'deleteOnlineApp()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }

}
