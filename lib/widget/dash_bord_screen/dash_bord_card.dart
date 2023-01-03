import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_widget/common_text/mid_text.dart';
import '../common_widget/common_text/small_text.dart';




class DashBordCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final Color bgColor;
  final Function onTap;

  const DashBordCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.bgColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        decoration: BoxDecoration(
            color: bgColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10.r),
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
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 58.sp,
            ),
            FittedBox(
              child: MidText(
                text: title,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SmallText(
              text: subTitle,
              color: Colors.white70,
              size: 12.sp,
            ),
          ],
        ),
      ),
    );
  }
}