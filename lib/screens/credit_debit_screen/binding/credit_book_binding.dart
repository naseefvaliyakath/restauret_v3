import 'package:get/get.dart';
import 'package:rest_verision_3/repository/credit_book_repository.dart';
import 'package:rest_verision_3/screens/credit_debit_screen/controller/credit_debit_ctrl.dart';


class CreditDebitBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreditBookRepo());
    Get.lazyPut(() => CreditDebitCtrl());
  }
}
