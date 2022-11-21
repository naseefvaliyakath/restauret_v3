import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodSortRoundIcon extends StatelessWidget {
  const FoodSortRoundIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0.w),
      child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(50.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black87.withOpacity(0.1),
                spreadRadius: 1.sp,
                blurRadius: 1.r,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
              child: Icon(
                Icons.sort,
                size: 24.sp,
              ))),
    );
  }
}
