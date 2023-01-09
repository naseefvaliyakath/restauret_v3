import 'package:get/get.dart';

import '../controller/create_table_controller.dart';

class CreateTableBinding implements Bindings {
  @override
  void dependencies() {

  Get.lazyPut<CreateTableController>(() => CreateTableController());

  }
}

