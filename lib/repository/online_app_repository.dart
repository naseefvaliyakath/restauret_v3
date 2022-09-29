import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../models/online_app_response/online_app_response.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class OnlineAppRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getOnlineApp() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(GET_ONLINE_APP, {'fdShopId': SHOPE_ID});
      OnlineAppResponse parsedResponse = OnlineAppResponse.fromJson(response.data);
      return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
    } on DioError catch (e) {
      rethrow;
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));
    } catch (e) {
      rethrow;
      return MyResponse(statusCode: 0, status: 'Error', message: 'Error');
    } finally {}
  }
}
