import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors/app_colors.dart';

class ShowPickedImgCard extends StatelessWidget {
  final File? file;
  final Function cancelEvent;
  final Function choseFileEvent;

  const ShowPickedImgCard(
      {Key? key,
      required this.file,
      required this.cancelEvent,
      required this.choseFileEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            choseFileEvent();
          },
          child: Container(
            margin: EdgeInsets.all(18.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.mainColor_2,
                image: DecorationImage(
                  image: FileImage(file!),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFe8e8e8),
                    blurRadius: 5.0,
                    offset: Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Color(0xFFfafafa),
                    offset: Offset(-5, 0),
                  ),
                  BoxShadow(
                    color: Color(0xFFfafafa),
                    offset: Offset(5, 0),
                  ),
                ]),
            width: 170.w,
            height: 220.h,


          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: SizedBox(
            width: 40.w,
            height: 40.h,
            child: IconButton(
              icon: Icon(Icons.cancel_rounded,
                  color: AppColors.mainColor, size: 35.sp),
              onPressed: () {
                cancelEvent();
              },
            ),
          ),
        ),
      ]),
    );
  }
}
