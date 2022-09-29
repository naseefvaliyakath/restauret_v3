import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'buttons/round_border_button.dart';


class TwoBtnBottomSheet {
  static void bottomSheet(
      {required String b1Name,
      required String b2Name,
      required Function b1Function,
      required Function b2Function}) {
    Get.bottomSheet(
      Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 50.h,
          ),
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //add  button 1
              RoundBorderButton(
                text: b1Name,
                textColor: Colors.white,
                onTap: b1Function,
              ),
              SizedBox(height: 30.h),
              //add button 2
              RoundBorderButton(
                text: b2Name,
                textColor: Colors.white,
                onTap: b2Function,
              ),


            ],
          )),
      enterBottomSheetDuration: const Duration(milliseconds: 500),
      exitBottomSheetDuration: const Duration(milliseconds: 500),
    );
  }
}
