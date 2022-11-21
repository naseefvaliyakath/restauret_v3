import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../../widget/common_widget/buttons/app_round_mini_btn.dart';
import 'invoice_widget_for_billing_page.dart';

//? this is the frame for invoice page
void invoiceAlertForBillingViewPage({
  required List<dynamic> billingItems,
  required String orderType,
  required String selectedOnlineApp,
  required Map<String,dynamic> deliveryAddress,
  required num grandTotal,
  required num change,
  required num cashReceived,
  required num netAmount,
  required num discountCash,
  required num discountPercent,
  required num charges,
  required context,
}) {
  try {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            AppRoundMiniBtn(
              text: 'Print',
              color: Colors.green,
              onTap: () {},
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
              //? this is the body of billing page
              InvoiceWidgetForBillingPage(
                billingItems:billingItems,
                netAmount: netAmount,
                cashReceived: cashReceived,
                orderType: orderType,
                selectedOnlineApp: selectedOnlineApp,
                deliveryAddress: deliveryAddress,
                discountPercent: discountPercent,
                discountCash: discountCash,
                charges: charges,
                grandTotal: grandTotal,
                change: change,
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
