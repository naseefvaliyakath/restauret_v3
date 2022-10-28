import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrScannerIconBtn extends StatelessWidget {
  const QrScannerIconBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0.w),
      child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black87.withOpacity(0.1),
                spreadRadius: 1.sp,
                blurRadius: 1.r,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
              child: Icon(
                Icons.qr_code_scanner,
                size: 24.sp,
                color: Colors.grey,
              ))),
    );
  }
}
