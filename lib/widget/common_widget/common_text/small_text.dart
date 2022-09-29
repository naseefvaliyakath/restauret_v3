import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../constants/app_colors/app_colors.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final TextOverflow overflow;

 const SmallText({
    Key? key,
    this.color = AppColors.subTitleColor,
    required this.text,
    this.size = 0,
    this.overflow = TextOverflow.fade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      softWrap: false,
      style: GoogleFonts.openSans(
          textStyle: TextStyle(
              color: color,
              fontSize: size == 0 ? 10.sp : size,
              fontWeight: FontWeight.bold)),
    );
  }
}
