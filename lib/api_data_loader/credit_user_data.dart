import 'package:get/get.dart';
import 'package:rest_verision_3/models/credit_user_response/credit_user_response.dart';
import '../models/credit_user_response/credit_user.dart';
import '../models/my_response.dart';
import '../repository/credit_book_repository.dart';

class CreditUserData extends GetxController {
  final CreditBookRepo _creditBookRepo = Get.find<CreditBookRepo>();
  //? to store credit user
  final List<CreditUser> _allCreditUser = [];
  List<CreditUser> get allCreditUser => _allCreditUser;

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
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _allCreditUser.clear();
          _allCreditUser.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allCreditUser, status: 'Success', message:  'Updated successfully');
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
      }
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
    }finally{
      update();
    }

  }



}