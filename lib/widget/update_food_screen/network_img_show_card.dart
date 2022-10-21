import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../constants/app_colors/app_colors.dart';


class NetworkImgShowCard extends StatelessWidget {
  final String img;
  const NetworkImgShowCard({
    Key? key,  required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Container(
          margin: EdgeInsets.all(18.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.mainColor_2,
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFe8e8e8),
                  blurRadius: 5.0,
                  offset: Offset(0, 5),
                ),
                BoxShadow(
                  color: Color(0xFFfafafa),
                  offset: Offset(-5, 0),
                ),
                BoxShadow(
                  color: Color(0xFFfafafa),
                  offset: Offset(5, 0),
                ),
              ]),
          width: 170.w,
          height: 220.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: img == 'no_data' ? 'https://mobizate.com/uploads/sample.jpg' : img ,
              placeholder: (context, url) => Lottie.asset(
                'assets/lottie/img_holder.json',
                width: 50.sp,
                height: 50.sp,
                fit: BoxFit.fill,
              ),
              errorWidget: (context, url, error) => Lottie.asset(
                'assets/lottie/error.json',
                width: 10.sp,
                height: 10.sp,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ]),
    );
  }
}
