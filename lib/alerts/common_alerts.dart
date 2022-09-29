import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'my_dialog_body.dart';
import 'package:get/get.dart';

void appCloseConfirm(context) {
  MyDialogBody.myConfirmDialogBody(
    context: context,
    title: 'Hold the items ?',
    desc: 'Do you Want to hold the  item entered ?',
    btnCancelText: 'No',
    btnOkText: 'Yes',
    onTapOK: () async {
      Navigator.pop(context);
      SystemNavigator.pop();
    },
    onTapCancel: () async {
      Get.back();
    },
  );
}