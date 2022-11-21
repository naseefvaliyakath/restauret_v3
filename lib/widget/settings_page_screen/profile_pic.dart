import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';


class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 115.sp,
        width: 115.sp,
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.mainColor_2,
            ),
          image: const DecorationImage(
            image: AssetImage(
                'assets/image/logo_hotel.png'),
            fit: BoxFit.fill,
          ),
          shape: BoxShape.circle,
        ),
        
    );

  }
}