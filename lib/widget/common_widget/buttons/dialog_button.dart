import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';

import '../../../constants/app_colors/app_colors.dart';


class DialogButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color bgColor;
  final Function onPressed;

  const DialogButton(
      {Key? key, required this.text, required this.icon, this.bgColor = AppColors.mainColor, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.w,
      height: 50.h,
      child: FittedBox(
        child: GFButton(
          onPressed: () {
            onPressed();
          },
          text: text,
          textStyle: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
          icon: Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
          shape: GFButtonShape.pills,
          color: bgColor,
        ),
      ),
    );
  }
}
