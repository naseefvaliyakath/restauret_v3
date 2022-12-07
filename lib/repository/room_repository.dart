import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../models/room_response/room_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class RoomRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  //? get all room
  Future<MyResponse> getRoom() async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_ALL_ROOMS, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      RoomResponse? parsedResponse = RoomResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error',  message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

  //?insert room
  Future<MyResponse> insertRoom(String roomName) async {
    try {
      Map<String, dynamic> roomDetails = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'roomName': roomName,
      };

      final response = await _httpService.insertWithBody(INSERT_ROOMS, roomDetails);

      RoomResponse parsedResponse = RoomResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? parsedResponse.errorCode.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }


  //? delete room
  Future<MyResponse> deleteRoom(int id) async {
    try {
      Map<String, dynamic> roomData = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'room_id': id,
      };
      final response = await _httpService.delete(DELETE_ROOMS,roomData);
      RoomResponse parsedResponse = RoomResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        String errorCode = parsedResponse.errorCode == 'cant delete this room' ? parsedResponse.errorCode.toString() : 'Something went wrong';
        return MyResponse(statusCode: 0, status: 'Error', message: errorCode.toString());
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

}
