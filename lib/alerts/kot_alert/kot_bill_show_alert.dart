import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order.dart';
import 'package:rest_verision_3/printer/controller/print_controller.dart';
import '../../widget/common_widget/buttons/app_round_mini_btn.dart';
import 'kot_bill_widget.dart';


void showKotBillAlert({
  required String type,
  required List<dynamic> billingItems,
  required context,
  //? this kotId only get from order view
  //? from billing page its -1 so kot not send to server in billing page
  int kotId = -1,
  //? this tableName is get from billing screen if its dining , els its ''
  String tableName = '',
  //? full KOT will get only from orderView page so its needed for take delivery address and order type of already sent KOT
  required KitchenOrder fullKot,
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
              onTap: () {
                Get.find<PrintCTRL>().printKot(kotList: billingItems, type: type, fullKot: fullKot);
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
              KotBillWidget(
                tableName: tableName,
                type: type,
                billingItems: billingItems,
                kotId: kotId,
                fullKot: fullKot,
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
