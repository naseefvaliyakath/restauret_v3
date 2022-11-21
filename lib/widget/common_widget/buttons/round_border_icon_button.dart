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
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(8.sp),
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
                size: 16.sp,
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
