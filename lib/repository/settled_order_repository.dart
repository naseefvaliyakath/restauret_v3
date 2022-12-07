import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/foods_response/food_response.dart';
import '../models/my_response.dart';
import '../models/settled_order_response/settled_order_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class SettledOrderRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getAllSettledOrder({DateTime? startDate, DateTime? endDate}) async {
    try {

      startDate ??= DateTime.now();
      endDate ??= DateTime.now();

      final response = await _httpService.getRequestWithBody(ALL_SETTLED_ORDER, {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'startDate':startDate,
        'endDate':endDate,
      });
      SettledOrderResponse? parsedResponse = SettledOrderResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(
            statusCode: 0,
            status: 'Error',
            message: SHOW_ERR ? parsedResponse.errorCode ?? 'error' : 'Something wrong !!');
      } else {
        return MyResponse(
            statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(
          statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
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
        return MyResponse(statusCode: 0, status: 'Error', message: parsedResponse.errorCode.toString());
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: parsedResponse.errorCode.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));

    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: e.toString());
    }
  }

}
