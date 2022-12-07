import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item_response.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class PurchaseItemRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  //? get all credit users
  Future<MyResponse> getAllPurchase({DateTime? startDate, DateTime? endDate}) async {
    // TODO: implement getNewsHeadline
    try {
      startDate ??= DateTime.now();
      endDate ??= DateTime.now();
      final response = await _httpService.getRequestWithBody(GET_PURCHASE, {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'startDate':startDate,
        'endDate':endDate,
      });
      PurchaseItemResponse? parsedResponse = PurchaseItemResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(
            statusCode: 0,
            status: 'Error',
            message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(
            statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(
          statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

  //?insert purchase item
  Future<MyResponse> insertPurchaseItem(num price, String description) async {
    try {
      Map<String, dynamic> purchaseDetails = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'description': description,
        'price': price
      };

      final response = await _httpService.insertWithBody(INSERT_PURCHASE, purchaseDetails);

      PurchaseItemResponse parsedResponse = PurchaseItemResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(
            statusCode: 0,
            status: 'Error',
            message: SHOW_ERR ? parsedResponse.errorCode.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: parsedResponse.errorCode.toString());
      }
    } on DioError catch (e) {
      return MyResponse(
          statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

  //? delete purchase
  deletePurchase(int id) async {
    try {
      Map<String, dynamic> purchaseData = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'purchaseId': id,
      };
      final response = await _httpService.delete(DELETE_PURCHASE, purchaseData);
      PurchaseItemResponse parsedResponse = PurchaseItemResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(
            statusCode: 0,
            status: 'Error',
            message: SHOW_ERR ? parsedResponse.errorCode.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(
          statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }
}
