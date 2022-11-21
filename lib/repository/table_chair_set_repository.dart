import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../models/table_chair_response/table_chair_set_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class TableChairSetRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> geTableChairSet() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(GET_TABLE_SET, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      TableChairSetResponse? parsedResponse = TableChairSetResponse.fromJson(response.data);
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