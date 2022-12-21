import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/notice_and_update/notice_and_update_response.dart';
import 'package:rest_verision_3/models/shop_response/shop_response.dart';
import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class StartupRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();


  //? get shop
  Future<MyResponse> getShopDetails(String subscId) async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_SHOP, {'subcId': subscId});
      ShopResponse? parsedResponse = ShopResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = parsedResponse.errorCode ?? 'Something went wrong !!';
        return MyResponse(statusCode: 0, status: 'Error',  message: myMessage);
      } else {
        String myMessage = parsedResponse.errorCode ?? 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  myMessage);
      }
    } on DioError catch (e) {
      String myMessage = MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'startupRepo', methodName: 'getShopDetails()');
      String myMessage = e.toString();
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }


  //? change password
  Future<MyResponse> changePassword(String subscId,int fdShopId,String password,String newPassword) async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.updateData(CHANGE_PASSWORD, {'subcId': subscId, 'fdShopId':fdShopId,'password':password,'newPassword':newPassword});
      ShopResponse? parsedResponse = ShopResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = parsedResponse.errorCode ?? 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error',  message: myMessage);
      } else {
        String myMessage = parsedResponse.errorCode ?? 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', message:  myMessage);
      }
    } on DioError catch (e) {
      String myMessage =  MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'startupRepo', methodName: 'changePassword()');
      String myMessage =  e.toString();
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }



  //? get notice and update
  Future<MyResponse> getNoticeAndUpdate() async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_NOTICE_AND_UPDATE, {'subcId': '0000'});
      NoticeAndUpdateResponse? parsedResponse = NoticeAndUpdateResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = parsedResponse.errorCode ??  'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error',  message: myMessage);
      } else {
        String myMessage =parsedResponse.errorCode ?? 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  myMessage);
      }
    } on DioError catch (e) {
      String myMessage =  MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'startupRepo', methodName: 'getNoticeAndUpdate()');
      String myMessage =  e.toString() ;
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }



}
