import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../screens/billing_screen/controller/billing_screen_controller.dart';
import 'billing_alert_food.dart';
import 'food_billing_alert_body.dart';
//? to bill the food in billing page
foodBillingAlert(
    context, {
      required img,
      required fdId,
      required name,
      required price,
    }) async {
  //? ktNote textField controller
  TextEditingController ktNoteController = TextEditingController();

  //? set price to controller variable
  await Get.find<BillingScreenController>().updatePriceFirstTime(price);

  //? set quantity one
  await Get.find<BillingScreenController>().setQntToOne();

  AwesomeDialog(
    customHeader: BillingAlertFood(
      img: img,
    ),
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    body: GetBuilder<BillingScreenController>(builder: (ctrl) {
      //? all value and function pass to body widget
      return FoodBillingAlertBody(
        name: name,
        count: ctrl.count,
        addFoodToBill: () {
          ctrl.addFoodToBill(
            fdId ?? 0,
            name ?? '',
            ctrl.count ,
            ctrl.price ,
            ktNoteController.text ?? '',
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