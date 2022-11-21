import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalDivider extends StatelessWidget {
  final Color color;
  final double height;

  const HorizontalDivider({Key? key, this.color = Colors.blueGrey, this.height = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == 1 ? 1.sp : height,
      color: color
    );
  }
}
