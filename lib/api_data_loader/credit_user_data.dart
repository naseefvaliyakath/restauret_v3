import 'package:get/get.dart';
import 'package:rest_verision_3/models/credit_user_response/credit_user_response.dart';
import '../error_handler/error_handler.dart';
import '../models/credit_user_response/credit_user.dart';
import '../models/my_response.dart';
import '../repository/credit_book_repository.dart';
import '../screens/login_screen/controller/startup_controller.dart';

class CreditUserData extends GetxController {
  final CreditBookRepo _creditBookRepo = Get.find<CreditBookRepo>();
  //? to store credit user
  final List<CreditUser> _allCreditUser = [];
  List<CreditUser> get allCreditUser => _allCreditUser;
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

  @override
  Future<void> onInit() async {
    super.onInit();
  }


  Future<MyResponse> getAllCreditUser() async {
    try {
      MyResponse response = await _creditBookRepo.getCreditUser();

      if (response.statusCode == 1) {
        CreditUserResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allCreditUser;
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _allCreditUser.clear();
          _allCreditUser.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allCreditUser, status: 'Success', message: response.message);
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: response.message);
      }
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'creditUserData',methodName: 'getAllCreditUser()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }finally{
      update();
    }

  }



}