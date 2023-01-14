import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/alerts/table_manage_alert/view_order_in_table_content.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order.dart';
import 'package:rest_verision_3/screens/table_manage_screen/controller/table_manage_controller.dart';
import '../../routes/route_helper.dart';
import '../../screens/table_manage_screen/table_manage_screen.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/create_table_screen/table_widget.dart';
import 'table_shift_select_content.dart';

void selectTableAlert({required context}) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return GetBuilder<TableManageController>(builder: (ctrl) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            insetPadding: EdgeInsets.symmetric(horizontal: 5.sp),
            titlePadding: EdgeInsets.only(left: 5.sp, right: 5.sp, top: 10.sp),
            contentPadding: EdgeInsets.symmetric(horizontal: 5.sp),
            actionsAlignment: MainAxisAlignment.center,
            title: const Center(child: BigText(text: 'Select Table')),
            content: SizedBox(width: 0.9.sw,height: 0.7.sh,child: TableShiftSelectContent()));
      });
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 900),
  );
}
