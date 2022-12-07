import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_widget/common_text/mid_text.dart';

class IconBtnWithText extends StatelessWidget {
  final String text;
  final IconData icons;
  final Function onTap;

  const IconBtnWithText({Key? key, required this.text, required this.icons, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: InkWell(
            onTap: (){
              onTap();
            },
            
            child: FittedBox(
              child: SizedBox(
                height: 45.sp,
                  child: Center(
                      child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Row(
                  children: [
                    MidText(text: text),
                    20.horizontalSpace,
                    Icon(
                      icons,
                      size: 24.sp,
                    ),
                  ],
                ),
              ))),
            ),
          )),
    );
  }
}
