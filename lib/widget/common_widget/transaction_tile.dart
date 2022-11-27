import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TransactionTile extends StatelessWidget {
  final IconData leading;
  final Color color;
  final Color leadingColor;
  final String titleText;
  final String trailingText;
  final String subTitle;

  const TransactionTile(
      {Key? key,
      required this.leading,
      required this.titleText,
      required this.subTitle,
      required this.color,
      required this.trailingText, required this.leadingColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        dense: true,
        leading: Icon(
          leading,
          color: leadingColor,
          size: 30.sp,
        ),
        title: Text(titleText, style: TextStyle(fontSize: 14.sp)),
        subtitle: Text(subTitle, style: TextStyle(fontSize: 12.sp)),
        trailing: Text(
          trailingText,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: color),
        ));
  }
}
