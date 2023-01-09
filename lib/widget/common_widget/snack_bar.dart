import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';



class AppSnackBar {
  static void successSnackBar(String title, String message) {
    Get.snackbar(title, message,
        maxWidth: 1.sh < 1.sw  ? 100.w : null,
        icon:  Icon(Icons.check_circle_outline,color: Colors.green,size: 35.sp,),
        backgroundColor: Colors.black54,
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
        maxWidth:  1.sh < 1.sw  ? 100.w : null,
        icon:  Icon(Icons.error_outline_rounded,color: Colors.redAccent,size: 35.sp,),
        backgroundColor: Colors.black54,
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

  static void myFlutterToast({ required String message,required Color bgColor,ToastGravity gravity = ToastGravity.BOTTOM}) {
    if(Platform.isWindows){
      Get.snackbar('Message', message,
          maxWidth:  1.sh < 1.sw  ? 100.w : null,
          icon:  Icon(Icons.info,color: bgColor,size: 35.sp,),
          backgroundColor: Colors.black54,
          titleText: Text(
            message,
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
    }else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: gravity,
          timeInSecForIosWeb: 1,
          backgroundColor: bgColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }

}
