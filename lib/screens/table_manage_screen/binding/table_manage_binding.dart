import 'package:get/get.dart';
import '../../../socket/socket_controller.dart';
import '../controller/table_manage_controller.dart';

class TableManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TableManageController());
  }
}
