import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/notice_and_update/notice_and_update.dart';
import 'package:rest_verision_3/models/notice_and_update/notice_and_update_response.dart';
import 'package:rest_verision_3/models/shop_response/shop_response.dart';
import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../models/room_response/room_response.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class StartupRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  //? get shop
  Future<MyResponse> getShopDetails(String subscId) async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_SHOP, {'subcId': subscId});
      ShopResponse? parsedResponse = ShopResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error',  message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }


  //? change password
  Future<MyResponse> changePassword(String subscId,int fdShopId,String password,String newPassword) async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.updateData(CHANGE_PASSWORD, {'subcId': subscId, 'fdShopId':fdShopId,'password':password,'newPassword':newPassword});
      ShopResponse? parsedResponse = ShopResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error',  message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message:  response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }



  //? get notice and update
  Future<MyResponse> getNoticeAndUpdate() async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_NOTICE_AND_UPDATE, {'subcId': '0000'});
      NoticeAndUpdateResponse? parsedResponse = NoticeAndUpdateResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error',  message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }



}
