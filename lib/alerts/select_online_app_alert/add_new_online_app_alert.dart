import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/common_widget/common_text/big_text.dart';
import 'addNewOnlineAppAlertBody.dart';

void addNewOnlineAppAlert({required BuildContext context}) {
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
          title: const Center(child: BigText(text: 'Enter App name')),
          content: const SingleChildScrollView(child: AddNewOnlineAppAlertBody()),
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