import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../screens/billing_screen/controller/billing_screen_controller.dart';
import 'billing_food_rount_img.dart';
import 'food_billing_alert_body.dart';
//? to bill the food in billing page
foodBillingAlert(
    context, {
      //? to pass to updateMultiplePrice() to set _price variable as per quarter, half .. etc
      required index,
      required img,
      required fdId,
      required name,
      required fdIsLoos,
      required price,
    }) async {
  //? ktNote textField controller
  TextEditingController ktNoteController = TextEditingController();

  //? set price to controller variable
  await Get.find<BillingScreenController>().updatePriceFirstTime(price);

  //? set quantity one
  await Get.find<BillingScreenController>().setQntToOne();
  //? set multi qnt food toggle to initial (full price)
  Get.find<BillingScreenController>().updateSelectedMultiplePrice(1,index);


  AwesomeDialog(
    customHeader: BillingFoodRoundImg(
      img: img,
    ),
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    body: GetBuilder<BillingScreenController>(builder: (ctrl) {
      //? all value and function pass to body widget
      return FoodBillingAlertBody(
        name: name,
        index: index,
        fdIsLoos: fdIsLoos ?? 'no',
        count: ctrl.count,
        addFoodToBill: () {
          ctrl.addFoodToBill(
            fdIsLoos ?? 'no',
            fdId ?? 0,
            fdIsLoos == 'no' ?  (name ?? '') : ctrl.multiSelectedFoodName ?? '',
            ctrl.count ,
            ctrl.price ,
            ktNoteController.text,
          );
          Navigator.pop(context);
        },
        ktTextCtrl: ktNoteController,
        qntIncrement: () {
          ctrl.incrementQnt();
        },
        qntDecrement: () {
          ctrl.decrementQnt();
        },
        priceIncrement: () {
          ctrl.incrementPrice();
        },
        priceDecrement: () {
          ctrl.decrementPrice();
        },
        price: ctrl.price,

      );
    }),
  ).show();


}