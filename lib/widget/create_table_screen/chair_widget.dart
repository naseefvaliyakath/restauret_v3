import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';


class ChairWidget extends StatelessWidget {
  final String text;

  const ChairWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: FittedBox(
        child: Container(
          padding: EdgeInsets.all(5.sp),
          margin: EdgeInsets.all(1.sp),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(width: 1.sp, color: AppColors.mainColor)),
          child: Center(
              child: FittedBox(
                  child: Text(
            text,
            style: TextStyle(color: Colors.black54,fontSize: 8.sp),
          ))),
        ),
      ),
    );
  }
}
