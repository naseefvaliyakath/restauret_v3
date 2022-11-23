import 'package:get/get.dart';
import 'package:rest_verision_3/models/room_response/room.dart';
import 'package:rest_verision_3/models/room_response/room_response.dart';
import 'package:rest_verision_3/repository/room_repository.dart';

import '../models/my_response.dart';
import '../screens/billing_screen/controller/billing_screen_controller.dart';

class RoomData extends GetxController {
  final RoomRepo _roomRepo = Get.find<RoomRepo>();

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
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _allRoom.clear();
          _allRoom.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allRoom, status: 'Success', message:  'Updated successfully');
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
      }
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
    }finally{
      update();
    }

  }



}