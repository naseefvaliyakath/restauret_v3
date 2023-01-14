import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../api_data_loader/table_chair_data.dart';
import '../../../constants/api_link/api_link.dart';
import '../../../models/table_chair_response/table_chair_set_response.dart';
import '../../../services/dio_error.dart';
import '../../../services/service.dart';
import '../../../widget/common_widget/snack_bar.dart';

class CreateTableController extends GetxController {
  final HttpService _httpService = Get.find<HttpService>();

  final TextEditingController tableNumberController = TextEditingController();

  int tableShape = 1;
  int roomId = -1;
  String roomName = MAIN_ROOM;

  final RoundedLoadingButtonController btnControllerCreateTable = RoundedLoadingButtonController();

  @override
  void onInit() async {
    await getRoomIdFromArgs();
    super.onInit();
  }

  updateTableShape(int shapeId) {
    tableShape = shapeId;
    update();
  }
  //insert table chair set
  Future insertTable() async {
    try {
      Map<String, dynamic> tableChairSet = {
        'fdShopId': Get
            .find<StartupController>()
            .SHOPE_ID,
        'tableShape': tableShape,
        'room_id': roomId,
        'roomName': roomName,
        'tableNumber': tableNumberController.text,
        'leftChairCount': 0,
        'rightChairCount': 0,
        'topChairCount': 0,
        'bottomChairCount': 0,
      };

      final response = await _httpService.insertWithBody(INSERT_TABLE, tableChairSet);

      TableChairSetResponse parsedResponse = TableChairSetResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        btnControllerCreateTable.error();
      } else {
        btnControllerCreateTable.success();
        Get.find<TableChairSetData>().getAllTableChairSet();
        update();
      }


    } on DioError catch (e) {
      btnControllerCreateTable.error();
      AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
    } catch (e) {
      btnControllerCreateTable.error();
      AppSnackBar.errorSnackBar('Error','Something Wrong !!');
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerCreateTable.reset();
      });
      update();
    }
  }

  //to get roomId argument from tale manage screen
  getRoomIdFromArgs() {
    int roomIdGet = -1;
    String roomNameGet = MAIN_ROOM;
    var args = Get.arguments ?? {'roomId':-1 , 'roomName':MAIN_ROOM};
    roomIdGet  = args['roomId'] ?? -1;
    roomNameGet  = args['roomName'] ?? MAIN_ROOM;
    roomId = roomIdGet;
    roomName = roomNameGet;
  }




}