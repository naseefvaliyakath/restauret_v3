import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BillingAlertFood extends StatelessWidget {
  final String img;

  const BillingAlertFood(
      {Key? key, required this.img,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.sp,
      height: 250.sp,
      margin: EdgeInsets.all(5.sp),


child: ClipRRect(
  borderRadius: BorderRadius.circular(100.r),
  child:   CachedNetworkImage(
    imageUrl: img,
    placeholder: (context, url) => Lottie.asset(
      'assets/lottie/img_holder.json',
      width: 50.sp,
      height: 50.sp,
      fit: BoxFit.fill,
    ),
    errorWidget: (context, url, error) => Lottie.asset(
      'assets/lottie/img_holder.json',
      width: 10.sp,
      height: 10.sp,
      fit: BoxFit.fill,

    ),
    fit: BoxFit.cover,
  ),
),
    );
  }
}
