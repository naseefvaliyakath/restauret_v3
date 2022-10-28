import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/foods_response/food_response.dart';
import '../models/kitchen_order_response/kitchen_order.dart';
import '../models/my_response.dart';
import '../models/settled_order_response/settled_order_response.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class SettledOrderRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getAllSettledOrder() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(ALL_SETTLED_ORDER,{'fdShopId': SHOPE_ID});
      SettledOrderResponse? parsedResponse = SettledOrderResponse.fromJson(response.data);
      return MyResponse(
          statusCode: 1,
          status: 'Success',
          data: parsedResponse,
          message: response.statusMessage.toString());
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));
    }
    catch (e) {
      rethrow;
      return MyResponse(statusCode: 0, status: 'Error', message: 'Error');
    } finally {

    }
  }




}