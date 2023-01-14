import 'package:get/get.dart';
import 'package:rest_verision_3/models/room_response/room.dart';
import 'package:rest_verision_3/models/room_response/room_response.dart';
import 'package:rest_verision_3/models/table_chair_response/table_chair_set_response.dart';
import 'package:rest_verision_3/repository/room_repository.dart';

import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../models/table_chair_response/table_chair_set.dart';
import '../repository/table_chair_set_repository.dart';
import '../screens/login_screen/controller/startup_controller.dart';


class TableChairSetData extends GetxController {
  final TableChairSetRepo _tableChairSetRepo = Get.find<TableChairSetRepo>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

  //?in this array get all room data from api through out the app working
  //? to save all allTableChairSet
  final List<TableChairSet> _allTableChairSet = [];
  List<TableChairSet> get allTableChairSet => _allTableChairSet;

  @override
  Future<void> onInit() async {
    super.onInit();
  }


  Future<MyResponse> getAllTableChairSet() async {
    try {
      MyResponse response = await _tableChairSetRepo.geTableChairSet();

      if (response.statusCode == 1) {
        TableChairSetResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allTableChairSet;
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _allTableChairSet.clear();
          _allTableChairSet.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allTableChairSet, status: 'Success', message:  response.message);
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: response.message);
      }
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'table_chair_setData',methodName: 'getAllTableChairSet()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }finally{
      update();
    }

  }



}