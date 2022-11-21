import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';

import '../../widget/common_widget/buttons/app_round_mini_btn.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import 'address_text_input_screen.dart';

//? to show delivery address entering alert
void deliveryAddressAlert({
  required BuildContext context,
  required BillingScreenController ctrl,
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
            AppRoundMiniBtn(
              text: 'Submit',
              color: Colors.green,
              onTap: () {
                //? to add address in hive
                ctrl.addDeliveryAddressItem(context: context);
              },
            ),
            AppRoundMiniBtn(
              //? if address already selected (submit btn clicked one time) then need to show rest else show close if no address is submitted
                text: Get.find<BillingScreenController>().selectDeliveryAddrTxt =='Enter address' ? 'Close' : 'Reset',
                color: Colors.redAccent,
                onTap: () {
                  if(Get.find<BillingScreenController>().selectDeliveryAddrTxt == 'Enter address')
                    {
                      Navigator.pop(context);
                    }
                  else{
                    //? in this case btn showing reset
                    Get.find<BillingScreenController>().clearDeliveryAddress();
                    Navigator.pop(context);
                  }

                })
          ],
          title: const Center(child: BigText(text: 'Enter Address')),
          //? to show addresses input screen
          content: SingleChildScrollView(child: AddressTextInputScreen(ctrl: ctrl)),
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

