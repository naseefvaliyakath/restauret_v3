import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/alerts/table_manage_alert/view_order_in_table_content.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order.dart';
import '../../widget/common_widget/common_text/big_text.dart';

void viewOrderInTableAlert({required context, required KitchenOrder kot}) {
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
            child: ViewOrderInTaleContent(
              kot: kot,
            ),
          ));
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 900),
  );
}