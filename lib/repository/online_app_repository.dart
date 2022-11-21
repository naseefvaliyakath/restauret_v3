import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../models/online_app_response/online_app_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class OnlineAppRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getOnlineApp() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(GET_ONLINE_APP, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      OnlineAppResponse parsedResponse = OnlineAppResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error', data: null, message: response.statusMessage.toString());
      } else {
        return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    } finally {}
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
        return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error',  message: SHOW_ERR ? e.toString() : 'Something wrong !!');
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
        return MyResponse(statusCode: 0, status: 'Error',  message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

}
