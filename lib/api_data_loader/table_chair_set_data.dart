import 'package:get/get.dart';
import 'package:rest_verision_3/models/table_chair_response/table_chair_set.dart';
import 'package:rest_verision_3/models/table_chair_response/table_chair_set_response.dart';
import 'package:rest_verision_3/repository/table_chair_set_repository.dart';

import '../models/my_response.dart';

class TableChairSetData extends GetxController {
  final TableChairSetRepo _tableChairSetRepo = Get.find<TableChairSetRepo>();

  //?in this array get all tableChairSet data from api through out the app working
  //? to save all room
  final List<TableChairSet> _allTableChairSet = [];

  List<TableChairSet> get allTableChairSet => _allTableChairSet;

  @override
  Future<void> onInit() async {
    getAllTableChairSet();
    super.onInit();
  }

  getAllTableChairSet() async {
    try {
      MyResponse response = await _tableChairSetRepo.geTableChairSet();

      if (response.statusCode == 1) {
        TableChairSetResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allTableChairSet;
        } else {
          _allTableChairSet.clear();
          _allTableChairSet.addAll(parsedResponse.data?.toList() ?? []);
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