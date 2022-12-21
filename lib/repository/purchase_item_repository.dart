import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item_response.dart';

import '../constants/api_link/api_link.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class PurchaseItemRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr = Get.find<StartupController>().showErr;

  //? get all credit users
  Future<MyResponse> getAllPurchase({DateTime? startDate, DateTime? endDate}) async {
    // TODO: implement getNewsHeadline
    try {
      startDate ??= DateTime.now();
      endDate ??= DateTime.now();
      final response = await _httpService.getRequestWithBody(GET_PURCHASE, {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'startDate': startDate,
        'endDate': endDate,
      });
      PurchaseItemResponse? parsedResponse = PurchaseItemResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'purchaseItemRepo', methodName: 'getAllPurchase()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
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
      _errHandler.myResponseHandler(
          error: e.toString(), pageName: 'purchaseItemRepo', methodName: 'insertPurchaseItem()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
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
      _errHandler.myResponseHandler(
          error: e.toString(), pageName: 'purchaseItemRepo', methodName: 'deletePurchase()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }
}
