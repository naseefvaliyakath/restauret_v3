import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../models/room_response/room_response.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class RoomRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getRoom() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(GET_ALL_ROOMS, {'fdShopId': SHOPE_ID});
      RoomResponse? parsedResponse = RoomResponse.fromJson(response.data);
      return MyResponse(
          statusCode: 1,
          status: 'Success',
          data: parsedResponse,
          message: response.statusMessage.toString());
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));
    }
    catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: 'Error');
    } finally {

    }
  }
}