import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';
import '../common_widget/common_text/big_text.dart';


class ClearAllBill extends StatelessWidget {
  final Function onTap;
  const ClearAllBill({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.sp),
          margin: EdgeInsets.symmetric(vertical: 1.sp),
          child: Row(
            children: [
              Icon(Icons.clear_all,size: 12.sp,),
              BigText(
                text: ' Clear All',
                size: 12.sp,
                color: AppColors.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
