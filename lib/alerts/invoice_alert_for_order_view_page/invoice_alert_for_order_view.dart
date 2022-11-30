import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';

import '../../models/settled_order_response/settled_order.dart';
import '../../printer/controller/print_controller.dart';
import '../../widget/common_widget/buttons/app_round_mini_btn.dart';
import 'invoice_alert_body_order_view.dart';

//? to show invoice when click to settled order to print the invoice not in KOT list
void invoiceAlertForOrderViewPage({
  required SettledOrder singleOrder,
  required List<dynamic> billingItems,
  required context,

}) {
  try {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.r))),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            AppRoundMiniBtn(
              text: 'Print',
              color: Colors.green,
              onTap: () {
                Get.find<PrintCTRL>().printInVoice(
                  billingItems: billingItems,
                  orderType: singleOrder.fdOrderType ?? TAKEAWAY,
                  selectedOnlineApp: singleOrder.fdOnlineApp ?? NO_ONLINE_APP,
                  deliveryAddress: singleOrder.fdDelAddress ?? {'name': '', 'number': 0, 'address': ''},
                  grandTotal: singleOrder.grandTotal ?? 0,
                  change: singleOrder.change ?? 0,
                  cashReceived: singleOrder.cashReceived ?? 0,
                  netAmount: singleOrder.netAmount ?? 0,
                  discountCash: singleOrder.discountCash ?? 0,
                  discountPercent: singleOrder.discountPersent ?? 0,
                  charges: singleOrder.change ?? 0,
                );
              },
            ),
            AppRoundMiniBtn(
                text: 'Close',
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pop(context);
                })
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InvoiceAlertBodyOrderView(
                billingItems: billingItems,
                singleOrder: singleOrder,

              ),
            ],
          ),
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
