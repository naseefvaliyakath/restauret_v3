import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/mid_text.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/small_text.dart';

import '../../constants/app_colors/app_colors.dart';

class ToggleBtnInCard extends StatelessWidget {
  final String text;
  final Color color;
  final bool value;
  final Function onToggle;
  const ToggleBtnInCard({Key? key, required this.text, required this.color, required this.value, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: InkWell(
            onTap: () {},
            child: FittedBox(
              child: SizedBox(
                  width: 150.w,
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 5.sp,right: 5.sp, top: 5.sp),
                    child: Column(
                      children: [
                        FlutterSwitch(
                          width: 50.sp,
                          height: 30.sp,
                          activeColor: color,
                          value: value,
                          onToggle: (bool value) {

                          },
                        ),
                        MidText(text: text)
                      ],
                    ),
                  ))),
            ),
          )),
    );
  }
}
