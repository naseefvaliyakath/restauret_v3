import 'package:get/get.dart';
import '../../../api_data_loader/room_data.dart';
import '../../../api_data_loader/table_chair_data.dart';
import '../../../socket/socket_controller.dart';
import '../controller/table_manage_controller.dart';

class TableManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TableManageController());
     Get.put<TableChairSetData>(TableChairSetData(), permanent: true);
  }
}
