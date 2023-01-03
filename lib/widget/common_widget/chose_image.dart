import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';

class ChooseImage extends StatelessWidget {
  const ChooseImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Center(
      child: Container(
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
            ]
        ),
        width: horizontal ? 60.w :170.w,
        height: 220.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 85.sp,
            ),
            Flexible(
              child: Text("Upload",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.sp,
                      overflow: TextOverflow.fade,
                      color: Colors.white)),
            ),
            Flexible(
              child: Text("Picture",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      overflow: TextOverflow.fade,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
