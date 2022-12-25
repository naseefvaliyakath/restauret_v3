import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/screens/credit_debit_screen/controller/credit_debit_ctrl.dart';

import '../widget/common_widget/buttons/progress_button.dart';
import '../widget/common_widget/common_text/big_text.dart';
import '../widget/common_widget/text_field_widget.dart';

addCreditOrDebit(BuildContext context, String type) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return GetBuilder<CreditDebitCtrl>(builder: (ctrl) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.r))),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: EdgeInsets.only(top: 10.sp, bottom: 1),
          contentPadding: EdgeInsets.all(10.sp),
          actionsPadding: EdgeInsets.only(bottom: 15.sp),
          actionsAlignment: MainAxisAlignment.center,
          title: Center(
              child: BigText(
            text: 'ADD $type',
            color: type == 'CREDIT' ? Colors.green : Colors.redAccent,
          )),
          actions: [
            SizedBox(
              width: 250.w,
              height: 40.sp,
              child: ProgressButton(
                btnCtrlName: 'addCreditDebit',
                text: 'Submit',
                ctrl: ctrl,
                color: type == 'CREDIT' ? Colors.green : Colors.redAccent,
                onTap: () async {
                  if (FocusScope.of(context).isFirstFocus) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                  ctrl.insertCreditDebit(
                    ctrl.userIdGet,
                    type
                  );
                  Navigator.pop(context);
                },
              ),
            )
          ],
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1.sw * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidget(
                  hintText: 'Amount',
                  textEditingController: ctrl.creditDebitTD,
                  isNumberOnly: true,
                  borderRadius: 15,
                  onChange: (_) {},
                ),
                10.verticalSpace,
                TextFieldWidget(
                  hintText: 'Description',
                  maxLIne: 3,
                  textEditingController: ctrl.creditDebitDescTD,
                  txtLength: 30,
                  borderRadius: 15.r,
                  onChange: (_) {},
                ),
              ],
            ),
          ),
        );
      });
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 900),
  );
}
