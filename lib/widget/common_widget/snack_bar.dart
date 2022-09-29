import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void successSnackBar(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: Colors.green,
        titleText: Text(
          title,
          style:  TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        messageText: Text(
          message,
          style:  TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white70),
        )
    );
  }

  static void errorSnackBar(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: Colors.red,
        titleText: Text(
          title,
          style:  TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        messageText: Text(
          message,
          style:  TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white70),
        )
    );
  }

}
