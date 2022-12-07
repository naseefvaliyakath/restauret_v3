import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../screens/login_screen/controller/startup_controller.dart';


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
          image:  DecorationImage(
            image: NetworkImage(
                Get.find<StartupController>().logoImg),
            fit: BoxFit.scaleDown,
          ),
          shape: BoxShape.circle,
        ),
        
    );

  }
}