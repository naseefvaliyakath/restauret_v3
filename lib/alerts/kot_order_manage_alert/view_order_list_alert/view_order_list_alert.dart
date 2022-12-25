import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/alerts/kot_order_manage_alert/view_order_list_alert/view_order_list_content.dart';

import '../../../widget/common_widget/common_text/big_text.dart';

//? to show KOT alert when click ViewOrder btn in KOT order management alert
void viewOrderListAlert({required context, required ctrl, required int kotIndex}) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: EdgeInsets.symmetric(horizontal: 5.sp),
          titlePadding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.sp),
          actionsAlignment: MainAxisAlignment.center,
          title: const Center(child: BigText(text: 'View Orders')),
          content: SingleChildScrollView(
            child: ViewOrderListContent(
              kotInt: kotIndex,
              ctrl: ctrl,
            ),
          ));
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 900),
  );
}