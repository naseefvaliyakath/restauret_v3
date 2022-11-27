import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/constants/app_colors/app_colors.dart';
import 'package:rest_verision_3/widget/common_widget/buttons/app_min_button.dart';

import '../widget/common_widget/common_text/big_text.dart';
import '../widget/common_widget/text_field_widget.dart';

addCreditOrDebit(BuildContext context ){
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.r))),
        insetPadding: const EdgeInsets.all(0),
        titlePadding: EdgeInsets.only(top: 10.sp, bottom: 1),
        contentPadding: EdgeInsets.all(10.sp),
        actionsPadding: EdgeInsets.only(bottom: 15.sp),
        actionsAlignment: MainAxisAlignment.center,
        title: const Center(child: BigText(text: 'Add credit')),
        actions: [
          SizedBox(
            width: 250.w,
            child: AppMiniButton(text: 'Add Details', color: AppColors.mainColor, onTap: (){

            }),
          )
        ],
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1.sw * 0.6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFieldWidget(
                hintText: 'Amount',
                textEditingController: TextEditingController(),
                borderRadius: 15,
                onChange: (_) {},
              ),
              10.verticalSpace,
              TextFieldWidget(
                hintText: 'Description',
                maxLIne: 3,
                textEditingController: TextEditingController(),
                borderRadius: 15.r,
                onChange: (_) {},
              ),
            ],
          ),
        ),
      );
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 900),
  );
}