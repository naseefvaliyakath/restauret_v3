import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order_array.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/foods_response/food_response.dart';
import '../models/my_response.dart';
import '../models/settled_order_response/settled_order_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class KotRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getAllKot() async {
    try {
      final response =
          await _httpService.getRequestWithBody(ALL_KOT, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      KitchenOrderArray? parsedResponse = KitchenOrderArray.fromJson(response.data);
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
}
