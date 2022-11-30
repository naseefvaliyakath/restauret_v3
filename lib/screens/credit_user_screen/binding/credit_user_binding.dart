import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/credit_user_data.dart';
import 'package:rest_verision_3/repository/credit_book_repository.dart';
import 'package:rest_verision_3/screens/credit_user_screen/controller/credit_user_ctrl.dart';

class CreditUserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreditBookRepo());
    Get.put<CreditUserData>(CreditUserData(), permanent: true);
    Get.lazyPut(() => CreditUserCTRL());
  }
}
