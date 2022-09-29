import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RoundBorderButton extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final String text;
  final double borderRadius;
  final double?  width;
  final double?  height;
  final Function onTap;


  const RoundBorderButton(
      {Key? key,
      this.textColor = Colors.black,
      this.backgroundColor = const Color(0xfff25f27),
      required this.text, this.borderRadius = 50, this.width, required this.onTap, this.height })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height:height ?? 60.h,
        width: width ?? 0.8.sw,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
           color: backgroundColor),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: Colors.black.withOpacity(0.5),
            hoverColor: Colors.black.withOpacity(0.5),
            focusColor:Colors.black.withOpacity(0.5),

            onTap: (){
              onTap();
            },
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20.sp,

                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }
}
