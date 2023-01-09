import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';


class TableRectangle extends StatelessWidget {
  final double width;
  final double height;
  final String text;

  final Function onTap;
  final Function onLongTap;


  const TableRectangle(
      {Key? key, required this.width, required this.height, required this.text, required this.onTap, required this.onLongTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {await onTap();},
      onLongPress: () async {await onLongTap();},
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: const Color(0xffe75f10),
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(width: 1.sp, color: AppColors.mainColor)),
        child: Center(
            child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  text,
                  style: TextStyle(color: Colors.white),
                ))),
      ),
    );
  }
}
