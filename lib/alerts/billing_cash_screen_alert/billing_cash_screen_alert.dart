import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/alerts/billing_cash_screen_alert/order_settil_screen_in_order_view.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import 'order_settil_screen_in_billing.dart';
import 'order_update_settil_screen.dart';

//? billing cash screen alert main body
//? passing  OrderSettleScreen() & OrderUpdateSettleScreen() as body
void billingCashScreenAlert({required context, required ctrl, required from}) {

  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(5.sp),
        titlePadding: EdgeInsets.all(5.sp),
        contentPadding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
        actionsAlignment: MainAxisAlignment.center,
        title: const Center(child: BigText(text: 'Settle Order')),
        content: SingleChildScrollView(
          //? there is 3 alert in app for billing screen
          //? 1 from billing screen & 2 from orderViewScreen for update settled bill and settle bill from KOT
            child: from == 'billing' ? OrderSettleScreenInBilling(ctrl: ctrl) : from == 'kotAlert' ? OrderSettleScreenInOrderView(ctrl: ctrl) : OrderUpdateSettleScreen(ctrl: ctrl)),
      );
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 900),
  );
}