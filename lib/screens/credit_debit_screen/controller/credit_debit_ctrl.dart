import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/credit_debit_response/credit_debit.dart';
import 'package:rest_verision_3/models/credit_debit_response/credit_debit_response.dart';
import 'package:rest_verision_3/screens/credit_user_screen/controller/credit_user_ctrl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../check_internet/check_internet.dart';
import '../../../error_handler/error_handler.dart';
import '../../../models/my_response.dart';
import '../../../repository/credit_book_repository.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';



class CreditDebitCtrl extends GetxController {
  final CreditBookRepo _creditBookRepo = Get.find<CreditBookRepo>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  final RoundedLoadingButtonController btnControllerAddCreditDebit = RoundedLoadingButtonController();
  //? for show full screen loading
  bool isLoading = false;
  int userIdGet = -1;
  String userNamGet = 'error';

  //? to store credit user
  final List<CreditDebit> _allCreditDebit = [];
  List<CreditDebit> get allCreditDebit => _allCreditDebit;

  //? credit debit amount td
  late TextEditingController creditDebitTD;
  //? credit debit description
  late TextEditingController creditDebitDescTD;

  @override
  void onInit() async {
    creditDebitTD = TextEditingController();
    creditDebitDescTD = TextEditingController();
    checkInternetConnection();
    receiveGetxArgument();
    super.onInit();
  }

  @override
  void onClose() async {
    creditDebitDescTD.dispose();
    creditDebitTD.dispose();
    super.onInit();
  }


  receiveGetxArgument() async {
    var args = Get.arguments ?? {'userId': -1, 'crUserName': 'error'};
    if(args['userId'] != null && args['userId'] != -1){
      userIdGet =  args['userId'];
      userNamGet = args['crUserName'];
      if (kDebugMode) {
        print('user id ${args['userId']}');
      }
       getAllCreditDebit(showSnack:false,crUserId: userIdGet);
    }
  }


  //? loading all credit debit (not using data loader )
  getAllCreditDebit({bool showLoad = true,bool showSnack = true,required int crUserId}) async {
    try {
      if(showLoad){
        showLoading();
      }
      MyResponse response = await _creditBookRepo.getCreditDebit(crUserId);
      if (response.statusCode == 1) {
        CreditDebitResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allCreditDebit;
        } else {
          _allCreditDebit.clear();
          _allCreditDebit.addAll(parsedResponse.data?.toList() ?? []);
          if(showSnack){
            AppSnackBar.successSnackBar('Success', response.message);
          }

        }
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'credit_debit_ctrl',methodName: 'getAllCreditDebit()');
    }finally{
      hideLoading();
      update();
    }

  }

  //?insert credit debit
  Future insertCreditDebit(int crUserId,String type) async {
    try {
      String creditDebitAmount = '';
      String creditDebitDec = '';
      creditDebitAmount = creditDebitTD.text;
      num creditAmount = type == 'CREDIT' ? num.parse(creditDebitAmount) : 0;
      num debitAmount = type == 'DEBIT' ? num.parse(creditDebitAmount) : 0;
      creditDebitDec = creditDebitDescTD.text;
      if (creditDebitAmount.trim() != '' && creditDebitDec.trim() != '') {
        MyResponse response = await _creditBookRepo.insertCreditDebit(crUserId,creditDebitDec,debitAmount,creditAmount);
        if (response.statusCode == 1) {
          btnControllerAddCreditDebit.success();
          //? registering controller if its not available in memory
          if(!Get.isRegistered<CreditUserCTRL>()){
            Get.lazyPut(() => CreditUserCTRL());
          }
          //? to refresh total amount in user tile
          Get.find<CreditUserCTRL>().refreshCreditUser(showSnack: false);
          getAllCreditDebit(crUserId: crUserId);
        } else {
          btnControllerAddCreditDebit.error();
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      } else {
        btnControllerAddCreditDebit.error();
        AppSnackBar.errorSnackBar('Field is Empty', 'Pleas enter  name');
      }
    }
    on FormatException {
      AppSnackBar.errorSnackBar('Error', 'Pleas enter a number');
    }
    catch (e) {
      btnControllerAddCreditDebit.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'credit_debit_ctrl',methodName: 'insertCreditDebit()');
    }
    finally {
      creditDebitTD.text = '';
      creditDebitDescTD.text = '';
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerAddCreditDebit.reset();
      });
      update();
    }
  }

  //?delete credit debit
  Future deleteCreditDebit(int crUserId, int creditDebitId) async {
    try {
      MyResponse response = await _creditBookRepo.deleteCreditDebit(crUserId, creditDebitId);
      if (response.statusCode == 1) {
        getAllCreditDebit(showLoad: true, crUserId: crUserId);
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'credit_debit_ctrl',methodName: 'deleteCreditDebit()');
    } finally {
      update();
    }
  }

  num calculateTotal(){
    num total = 0;
    total = _allCreditDebit.fold(0, (previous, current) => previous + current.creditAmount!-current.debitAmount!);
    return total;
  }


  showLoading() {
    isLoading = true;
    update();
  }

  hideLoading() {
    isLoading = false;
    update();
  }

}
