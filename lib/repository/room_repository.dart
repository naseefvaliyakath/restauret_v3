import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/api_link/api_link.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../models/room_response/room_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class RoomRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr = Get.find<StartupController>().showErr;

  //? get all room
  Future<MyResponse> getRoom() async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_ALL_ROOMS, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      RoomResponse? parsedResponse = RoomResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error',  message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'roomRepo', methodName: 'getRoom()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
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
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'roomRepo', methodName: 'insertRoom()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
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
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(), pageName: 'roomRepo', methodName: 'deleteRoom()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }

}
