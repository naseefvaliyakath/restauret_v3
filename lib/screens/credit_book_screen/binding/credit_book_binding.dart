import 'package:get/get.dart';
import 'package:rest_verision_3/screens/credit_book_screen/controller/credit_book_ctrl.dart';

class CreditBookBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreditBookCTRL());
  }
}
