import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_verision_3/alerts/table_select_alert/table_select_body.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';

import '../../widget/common_widget/buttons/app_round_mini_btn.dart';
import '../../widget/common_widget/common_text/big_text.dart';

//? to show table select  alert
void tableSelectAlert({
  required BuildContext context,
}) {
  try {
    BillingScreenController ctrl = Get.find<BillingScreenController>();
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(10.sp),
          contentPadding: EdgeInsets.all(10.sp),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            AppRoundMiniBtn(
              text: 'Submit',
              color: Colors.green,
              onTap: () {
                ctrl.updateTableChairSet(room: ctrl.selectedRoom, table: ctrl.selectedTable, chair: ctrl.selectedChair);
                Navigator.pop(context);
              },
            ),
            AppRoundMiniBtn(
                text: 'Reset',
                color: Colors.redAccent,
                onTap: () {
                  ctrl.resetTableChairSetValues();
                  Navigator.pop(context);
                })
          ],
          title: const Center(child: BigText(text: 'Select table')),
          //? to show addresses input screen
          content: const SingleChildScrollView(child: TableSelectBody()),
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