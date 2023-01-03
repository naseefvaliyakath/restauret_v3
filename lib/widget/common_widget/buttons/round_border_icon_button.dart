import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_colors/app_colors.dart';


class RoundBorderIconButton extends StatelessWidget {

  final Function onTap;
  final String name;
  final IconData icon;

  const RoundBorderIconButton({Key? key, required this.onTap, required this.name, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(horizontal ? 15.sp : 8.sp ),
        decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Colors.white)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: horizontal ? 24.sp : 16.sp,
                color: Colors.white,
              ),
              3.verticalSpace,
              Flexible(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 8.sp, color: Colors.white, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
