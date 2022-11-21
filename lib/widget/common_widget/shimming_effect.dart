import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmingEffect extends StatelessWidget {
  const ShimmingEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext ctx, index) {

              return Container(
                margin:  EdgeInsets.symmetric(horizontal: 8.w),
                width: 120.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey, spreadRadius: 3.r),
                  ],
                ),
              );


          },
        ),
      ),
    );
  }
}
