import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';



class CreditBookCTRL extends GetxController {
  final showSearchBar = true.obs;
  //? Search  controller
  late TextEditingController searchTD;
  //? usernameTd
  late TextEditingController userNameTD;



  final RoundedLoadingButtonController btnControllerAddUser = RoundedLoadingButtonController();


  @override
  void onInit() async {
    searchTD = TextEditingController();
    userNameTD = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() async {
    searchTD.dispose();
    userNameTD.dispose();
    super.onInit();
  }

}
