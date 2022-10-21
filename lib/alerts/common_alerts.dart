import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import '../widget/billing_screen/delete_biiling_alert_edit_food_dody.dart';
import '../widget/common_widget/buttons/dialog_button.dart';
import '../widget/common_widget/common_text/mid_text.dart';
import 'my_dialog_body.dart';
import 'package:get/get.dart';

//? to close the app
void appCloseConfirm(context) {
  MyDialogBody.myConfirmDialogBody(
    context: context,
    title: 'Hold the items ?',
    desc: 'Do you Want to hold the  item entered ?',
    btnCancelText: 'No',
    btnOkText: 'Yes',
    onTapOK: () async {
      Navigator.pop(context);
      SystemNavigator.pop();
    },
    onTapCancel: () async {
      Get.back();
    },
  );
}

//? common alert for two button
void twoFunctionAlert({
  required BuildContext context,
  required Function onTap,
  required String title,
  required String subTitle,
  required String okBtn,
  required String cancelBtn,
}) {
  MyDialogBody.myConfirmDialogBody(
    context: context,
    title: 'Delete this item?',
    desc: 'Do you want to delete this item ?',
    btnCancelText: 'No',
    btnOkText: 'Yes',
    onTapOK: () async {
      await onTap();
      Navigator.pop(context);
    },
    onTapCancel: () async {
      Navigator.pop(context);
    },
  );
}

//! to confirm save bill in hive before go back to main screen
//! check can replaced this alert with common twoFunctionAlert
void askConfirm(context) {
  MyDialogBody.myConfirmDialogBody(
    context: context,
    title: 'Hold the items ?',
    desc: 'Do you Want to hold the  item entered ?',
    btnCancelText: 'No',
    btnOkText: 'Yes',
    onTapOK: () async {
      await Get.find<BillingScreenController>().saveBillInHive();
      Navigator.pop(context);
      Navigator.pop(context, true);
    },
    onTapCancel: () async {
      await Get.find<BillingScreenController>().clearBillInHive();
      Navigator.pop(context);
      Navigator.pop(context, true);
    },
  );
}


deleteItemFromBillAlert(context, index) async {
  //? ktNote text-field controller
  TextEditingController ktNoteController = TextEditingController();
  //? on first time if kitchen note then update from bill list
  ktNoteController.text = Get.find<BillingScreenController>().billingItems[index]['ktNote'];
  //? set edit options hide first time
  await Get.find<BillingScreenController>().setIsVisibleEditBillItemFalse();
  //? update price from list of bills
  await Get.find<BillingScreenController>().updatePriceFirstTime(Get.find<BillingScreenController>().billingItems[index]['price']);
  //? update qnt from list of bills
  await Get.find<BillingScreenController>().updateQntFirstTime((Get.find<BillingScreenController>().billingItems[index]['qnt']));

  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    body: GetBuilder<BillingScreenController>(builder: (ctrl) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.sp),
            child: const MidText(
              text: '',
            ),
          ),
          10.verticalSpace,
          //? when click update btn in dialog this body will visible
          Visibility(
            visible: ctrl.isVisibleEditBillItem,
            child: DeleteBillingAlertEditBillBody(
              ktTextCtrl: ktNoteController,
              priceDecrement: () {
                ctrl.decrementPrice();
              },
              priceIncrement: () {
                ctrl.incrementPrice();
              },
              qntIncrement: () {
                ctrl.incrementQnt();
              },
              qntDecrement: () {
                ctrl.decrementQnt();
              },
              price: ctrl.price,
              count: ctrl.count,
            ),
          ),
        ],
      );
    }),
    buttonsTextStyle: const TextStyle(color: Colors.black,),
    showCloseIcon: true,
    btnCancel: GetBuilder<BillingScreenController>(builder: (ctrl) {
      return DialogButton(
        icon: Icons.delete,
        onPressed: () async {
          Navigator.pop(context);
          await ctrl.removeFoodFromBill(index);
        },
        text: 'Delete',
        bgColor: Colors.redAccent,
      );
    }),
    btnOk: GetBuilder<BillingScreenController>(builder: (ctrl) {
      return DialogButton(
        icon: ctrl.isVisibleEditBillItem ? Icons.update : Icons.edit,
        onPressed: () {
          if (!ctrl.isVisibleEditBillItem) {
            ctrl.setIsVisibleEditBillItem(true);
          } else {
            ctrl.updateFodToBill(index, ctrl.count, ctrl.price, ktNoteController.text);
            Navigator.pop(context);
          }
        },
        //? when widget is visible then btn text will change to edit to Update
        text: ctrl.isVisibleEditBillItem ? 'Update' : 'Edit',
        bgColor: Colors.green,
      );
    }),
  ).show();
}