import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/alerts/add_new_user_alert/add_new_user_alert_body.dart';
import 'package:rest_verision_3/alerts/password_prompt_alert/password_prompt_to_cashier_body.dart';
import 'package:rest_verision_3/alerts/show_qr_alert/show_qr_alert_body.dart';
import '../../widget/common_widget/common_text/big_text.dart';


void showQrAlert({required BuildContext context}) {
  try {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.r))),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(10.sp),
          contentPadding: EdgeInsets.all(10.sp),
          actionsAlignment: MainAxisAlignment.center,
          title: const Center(child: BigText(text: 'SCAN FOR MENU')),
          content: const SingleChildScrollView(child: ShowQrAlertBody()),
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 900),
    );
  } catch (e) {
    rethrow;
  }
}