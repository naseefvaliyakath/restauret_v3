import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';

class AppMiniButton extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final Function onTap;

  const AppMiniButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onTap,
    this.textSize = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFButton(
      onPressed: () {
        onTap();
      },
       blockButton: true,
      textStyle: TextStyle(fontSize: 14.sp),
      shape: GFButtonShape.pills,
      color: color,
      elevation: 4.sp,
      child: FittedBox(
        child: Text(
          text,
          softWrap: false,
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: textSize == -1 ? 16.sp : textSize),
        ),

      ),
    );

  }
}
