import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProgressBtnForKotTile extends StatelessWidget {
  final RoundedLoadingButtonController btnCtrl;
  final Function onTap;
  final Color bgColor;
  final String text;

  const ProgressBtnForKotTile(
      {Key? key,
      required this.btnCtrl,
      required this.onTap,
      required this.bgColor,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
        successIcon: Icons.linear_scale,
        failedIcon: Icons.linear_scale,
        loaderSize: 10.sp,
        color: bgColor,
        successColor: Colors.green,
        completionDuration: const Duration(milliseconds: 0),
        duration: const Duration(milliseconds: 100),
        controller: btnCtrl,
        onPressed: () async {
          await onTap();
        },
        child: Text(
          text,
          softWrap: false,
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ));
  }
}
