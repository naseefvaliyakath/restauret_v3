import 'package:get/get.dart';

import '../controller/menu_book_controller.dart';


class MenuBookBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuBookController());
  }
}
