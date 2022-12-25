import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/api_data_loader/credit_user_data.dart';
import 'package:rest_verision_3/models/credit_user_response/credit_user.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../check_internet/check_internet.dart';
import '../../../error_handler/error_handler.dart';
import '../../../models/my_response.dart';
import '../../../repository/credit_book_repository.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';

class CreditUserCTRL extends GetxController {
  final CreditBookRepo _creditBookRepo = Get.find<CreditBookRepo>();
  final CreditUserData _creditUserData = Get.find<CreditUserData>();
  bool showErr  = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  //? for show full screen loading
  bool isLoading = false;

  //? Search  controller
  late TextEditingController userSearchTD;

  //? usernameTd
  late TextEditingController userNameTD;

  final RoundedLoadingButtonController btnControllerAddUser = RoundedLoadingButtonController();

  //? this will store all CreditUser from the server
  //? not showing in UI or change
  final List<CreditUser> _storedCreditUser = [];

  //? _myCategory to show in UI
  final List<CreditUser> _myCreditUser = [];

  List<CreditUser> get myCreditUser => _myCreditUser;

  @override
  void onInit() async {
    checkInternetConnection();
    userSearchTD = TextEditingController();
    userNameTD = TextEditingController();
    getInitialCreditUser();
    super.onInit();
  }

  @override
  void onClose() async {
    userSearchTD.dispose();
    userNameTD.dispose();
    super.onInit();
  }

  //?insert credit user name
  Future insertCreditUser() async {
    try {
      String userNameString = '';
      userNameString = userNameTD.text;
      if (userNameString.trim() != '') {
        MyResponse response = await _creditBookRepo.insertCreditUser(userNameString);
        if (response.statusCode == 1) {
          btnControllerAddUser.success();
          refreshCreditUser(showLoad: false);
        } else {
          btnControllerAddUser.error();
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      } else {
        btnControllerAddUser.error();
        AppSnackBar.errorSnackBar('Field is Empty', 'Pleas enter  name');
      }
    } catch (e) {
      btnControllerAddUser.error();
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'credit_user_ctrl',methodName: 'insertCreditUser()');
      return;
    } finally {
      userNameTD.text = '';
      Future.delayed(const Duration(seconds: 1), () {
        btnControllerAddUser.reset();
      });
      update();
    }
  }

  //? to load o first screen loading
  getInitialCreditUser() {

    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedCreditUser from CreditUserData controller
      if (_creditUserData.allCreditUser.isEmpty) {
        if (kDebugMode) {
          print(_creditUserData.allCreditUser.length);
          print('data loaded from db');
        }
        refreshCreditUser(showSnack: false);
      } else {
        if (kDebugMode) {
          print('data loaded from creditUser data');
        }
        //? load data from variable in this controller
        _storedCreditUser.clear();
        _storedCreditUser.addAll(_creditUserData.allCreditUser);
        //? to show full credit user in UI
        _myCreditUser.clear();
        _myCreditUser.addAll(_storedCreditUser);
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'credit_user_ctrl',methodName: 'getInitialCreditUser()');
      return;
    }
    finally{
      update();
    }
  }

  //? this function will call getCategory() in CategoryData
  //? ad refresh fresh data from server
  refreshCreditUser({bool showLoad = true, bool showSnack = true}) async {
    try {
      if (showLoad) {
        showLoading();
      }
      MyResponse response = await _creditUserData.getAllCreditUser();
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<CreditUser> creditUser = response.data;
          _storedCreditUser.clear();
          _storedCreditUser.addAll(creditUser);
          //? to show full creditUser in UI
          _myCreditUser.clear();
          _myCreditUser.addAll(_storedCreditUser);
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        if (showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'credit_user_ctrl',methodName: 'refreshCreditUser()');
      return;
    } finally {
      hideLoading();
      update();
    }
  }

  //? searchKey get from onChange event
  searchCreditUser() {
    try {
      final suggestion = _storedCreditUser.where((users) {
        final userName = users.crUserName!.toLowerCase();
        final input = userSearchTD.text.toLowerCase();
        return userName.contains(input);
      });
      _myCreditUser.clear();
      _myCreditUser.addAll(suggestion);
      update();
    } catch (e) {
      return;
    }
  }

  //?delete credit user name
  Future deleteCreditUser(int id, String crUserName) async {
    try {
      MyResponse response = await _creditBookRepo.deleteCreditUser(id, crUserName);
      if (response.statusCode == 1) {
        refreshCreditUser(showLoad: true);
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(),pageName: 'credit_user_ctrl',methodName: 'deleteCreditUser()');
      return;
    } finally {
      update();
    }
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
