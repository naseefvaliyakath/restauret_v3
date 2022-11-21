import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/common_widget/common_text/big_text.dart';
import 'kitchen_kot_view_alert_content.dart';

//? view order list alert(Showing ordered item and its status) in taleMAage screen when clo]ick on chair
void viewKitchenKotAlert({required context, required int kotId}) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: EdgeInsets.symmetric(horizontal: 5.sp),
          titlePadding: EdgeInsets.only(left: 5.sp, right: 5.sp, top: 10.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.sp),
          actionsAlignment: MainAxisAlignment.center,
          title: const Center(child: BigText(text: 'View Orders')),
          content: SingleChildScrollView(
            child: KitchenKotViewAlertContent(
              kotId: kotId,
            ),
          ));
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 900),
  );
}