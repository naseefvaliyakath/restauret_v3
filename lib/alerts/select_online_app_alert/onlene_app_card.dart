import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/common_widget/common_text/big_text.dart';


class OnlineAppCard extends StatelessWidget {
  final String text;
   const OnlineAppCard({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20.r), boxShadow: [
        BoxShadow(
          offset: const Offset(4, 6),
          blurRadius: 4,
          color: Colors.black.withOpacity(0.3),
        )
      ]),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 5.h),
                width: 1.sw * 0.3,
                child:  ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset('assets/image/food_delivery.png',fit: BoxFit.scaleDown,),
                ),
              ),
              10.verticalSpace,
              BigText(text: text,color: Colors.grey,size: 20.sp,)
            ],
          ),
        ),
      ),
    );
  }
}
