import 'package:get/get.dart';
import 'package:rest_verision_3/models/room_response/room.dart';
import 'package:rest_verision_3/models/room_response/room_response.dart';
import 'package:rest_verision_3/repository/room_repository.dart';

import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';


class RoomData extends GetxController {
  final RoomRepo _roomRepo = Get.find<RoomRepo>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

  //?in this array get all room data from api through out the app working
  //? to save all room
  final List<Room> _allRoom = [];
  List<Room> get allRoom => _allRoom;

  @override
  Future<void> onInit() async {
    super.onInit();
  }


  Future<MyResponse> getAllRoom() async {
    try {
      MyResponse response = await _roomRepo.getRoom();

      if (response.statusCode == 1) {
        RoomResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allRoom;
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _allRoom.clear();
          _allRoom.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allRoom, status: 'Success', message:  response.message);
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: response.message);
      }
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'roomData',methodName: 'getAllRoom()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }finally{
      update();
    }

  }



}