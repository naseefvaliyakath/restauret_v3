import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';
import '../billing_screen/clear_all_bill_widget.dart';

class ShowPickedImgCard extends StatelessWidget {
  final File? file;
  final Function cancelEvent;
  final Function choseFileEvent;

  const ShowPickedImgCard({Key? key, required this.file, required this.cancelEvent, required this.choseFileEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Center(
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            choseFileEvent();
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(8.sp),
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
                width: horizontal ? 60.w : 170.w,
                height: 220.h,
              ),
              Visibility(
                visible: horizontal ? true : false,
                child: SizedBox(
                    width: 40.w,
                    child: ClearAllBill(onTap: () {
                      cancelEvent();
                    })),
              )
            ],
          ),
        ),
        Visibility(
          visible: horizontal ? false : true,
          child: Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              width: 40.w,
              height: 40.h,
              child: IconButton(
                icon: Icon(Icons.cancel_rounded, color: AppColors.mainColor, size: 35.sp),
                onPressed: () {
                  cancelEvent();
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
