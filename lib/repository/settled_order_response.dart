import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../models/settled_order_response/settled_order_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class SettledOrderRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getAllSettledOrder() async {
    try {
      final response = await _httpService.getRequestWithBody(ALL_SETTLED_ORDER, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      SettledOrderResponse? parsedResponse = SettledOrderResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(
            statusCode: 0,
            status: 'Error',
            message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        print('object');
        print(response.statusMessage.toString());
        return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(
          statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    } finally {}
  }
}
