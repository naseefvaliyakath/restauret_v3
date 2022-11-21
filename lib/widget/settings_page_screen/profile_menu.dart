import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';



class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,  this.actionWidget = const Icon(Icons.arrow_forward_ios,size: 16),
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function press;
  final Widget actionWidget;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mainColor, padding: EdgeInsets.all(20.sp),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: (){
          press();
        },
        child: Row(
          children: [
            Icon(icon,size: 24.sp,),
            20.horizontalSpace,
            Expanded(child: Text(text,style:TextStyle(fontSize: 16.sp)),),
            actionWidget,
          ],
        ),
      ),
    );
  }
}