import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/common_widget/common_text/big_text.dart';
import 'change_mode_of_app_alert_body.dart';

//?change mode of app alert
void changeModeOfAppAlert({required BuildContext context}) {
  try {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.r))),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
          actionsAlignment: MainAxisAlignment.center,
          title: const Center(child: BigText(text: 'Select app mode')),
          content: const SingleChildScrollView(child: ChangeModeOfAppAlertBody()),
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