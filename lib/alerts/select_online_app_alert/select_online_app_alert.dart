import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/alerts/select_online_app_alert/select_onlie_app_screen.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';

import '../../widget/common_widget/buttons/app_round_mini_btn.dart';
import '../../widget/common_widget/common_text/big_text.dart';

//? to show delivery address entering alert
void selectOnlineAppAlert({
  required BuildContext context,
}) {
  try {
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
            //? if selectedOnlineApp is NO_ONLINE_APP then reset btn not showing
            Get.find<BillingScreenController>().selectedOnlineApp != NO_ONLINE_APP
                ? AppRoundMiniBtn(
                    text: 'Reset',
                    color: Colors.blueAccent,
                    onTap: () {
                      //? to reset the selected online app
                      Get.find<BillingScreenController>().resetSelectedOnlineApp();
                      Navigator.pop(context);
                    })
                : const SizedBox(),
            AppRoundMiniBtn(
                text: 'Close',
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pop(context);
                })
          ],
          title: const Center(child: BigText(text: 'Select app')),
          //? to show addresses input screen
          content: const SingleChildScrollView(child: SelectOnlineAppScreen()),
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
