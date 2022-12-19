import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/api_link/api_link.dart';
import '../error_handler/error_handler.dart';
import '../models/foods_response/food_response.dart';
import '../models/my_response.dart';
import '../models/settled_order_response/settled_order_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class SettledOrderRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr = Get.find<StartupController>().showErr;

  Future<MyResponse> getAllSettledOrder({DateTime? startDate, DateTime? endDate}) async {
    try {
      startDate ??= DateTime.now();
      endDate ??= DateTime.now();

      final response = await _httpService.getRequestWithBody(ALL_SETTLED_ORDER, {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'startDate': startDate,
        'endDate': endDate,
      });
      SettledOrderResponse? parsedResponse = SettledOrderResponse.fromJson(response.data);

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
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'settledRepo', methodName: 'getAllSettledOrder()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } finally {}
  }

  //? to delete/cancel settled order
  Future<MyResponse> deleteSettledOrder(int? settledId) async {
    try {
      Map<String, dynamic> data = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'settled_id': settledId ?? -1,
      };
      final response = await _httpService.delete(DELETE_SETTLED_ORDER, data);
      FoodResponse parsedResponse = FoodResponse.fromJson(response.data);

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
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'settledRepo', methodName: 'deleteSettledOrder()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }
}
