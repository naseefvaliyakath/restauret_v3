import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/complaints/complaint_response.dart';

import '../constants/api_link/api_link.dart';
import '../services/service.dart';

class FlutterLogRepo extends GetxController {
  final HttpService _httpService = Get.find<HttpService>();
  int SHOP_ID_FOR_HANDLE = -1;

  //?insert log
  insertLog({
    required String error,
    required String pageName,
    required String methodName,
    required String platform,
    required String osVersionNumber,
    required String deviceModel,
    required String appVersion,

  }) async {
    try {
      Map<String, dynamic> logData = {
        'fdShopId': SHOP_ID_FOR_HANDLE,
        'error': error,
        'pageName': pageName,
        'methodName': methodName,
        'platform': platform,
        'osVersionNumber': osVersionNumber,
        'deviceModel': deviceModel,
        'appVersion': appVersion,
      };

      final response = await _httpService.insertWithBody(INSERT_FLUTTER_LOG, logData);

      ComplaintResponse parsedResponse = ComplaintResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        if (kDebugMode) {
          print(parsedResponse.error);
        }
        return;
      } else {
        if (kDebugMode) {
          print(parsedResponse.error);
        }
        return;
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

  //? on application loading from startup controller shop is will assign to SHOP_ID_FOR_HANDLE
  updateShopIdWhenAppIsLoaded(int shopId){
    SHOP_ID_FOR_HANDLE = shopId;
    update();
  }

}
