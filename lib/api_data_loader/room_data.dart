import 'package:get/get.dart';
import 'package:rest_verision_3/models/room_response/room.dart';
import 'package:rest_verision_3/models/room_response/room_response.dart';
import 'package:rest_verision_3/repository/room_repository.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';

class RoomData extends GetxController {
  final RoomRepo _roomRepo = Get.find<RoomRepo>();

  //?in this array get all room data from api through out the app working
  //? to save all room
  final List<Room> _allRoom = [];
  List<Room> get allRoom => _allRoom;

  @override
  Future<void> onInit() async {
    //getAllRoom();
    super.onInit();
  }

  getAllRoom() async {
    try {
      MyResponse response = await _roomRepo.getRoom();

      if (response.statusCode == 1) {
        RoomResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allRoom;
        } else {
          _allRoom.addAll(parsedResponse.data?.toList() ?? []);
        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
    update();
  }



}