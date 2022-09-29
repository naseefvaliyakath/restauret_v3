import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/common_widget/buttons/app_round_mini_btn.dart';
import '../widget/common_widget/common_text/big_text.dart';

class MyDialogBody {
 static void myConfirmDialogBody({
    required BuildContext context,
    required String title,
    required String desc,
    btnCancelText = 'No',
    btnOkText = 'Yes',
    required Function onTapOK,
    required Function onTapCancel,
  }) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: EdgeInsets.all(0.sp),
            titlePadding: EdgeInsets.all(0.sp),
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 3.sp),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.sp),
                    color: Colors.transparent,
                    width: 0.8.sw,
                    height: 250.h,
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Positioned(
                          top: 25.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5.sp),
                            width: 0.7.sw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: Colors.white,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  55.verticalSpace,
                                  FittedBox(
                                      child: BigText(
                                    text: title,
                                    color: Colors.black,
                                  )),
                                  5.verticalSpace,
                                  FittedBox(
                                      child: Text(
                                    desc,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  )),
                                  10.verticalSpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AppRoundMiniBtn(
                                        text: btnOkText,
                                        color: Colors.green,
                                        onTap: () {
                                          onTapOK();
                                        },
                                      ),
                                      AppRoundMiniBtn(
                                          text: btnCancelText,
                                          color: Colors.redAccent,
                                          onTap: () {
                                            onTapCancel();
                                          })
                                    ],
                                  ),
                                  10.verticalSpace,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: CircleAvatar(
                            minRadius: 26.r,
                            maxRadius: 38.r,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.question_mark_sharp,
                              size: 38.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 3,
                          child: CircleAvatar(
                            minRadius: 19.r,
                            maxRadius: 31.r,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.question_mark_sharp,
                              size: 38.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ));
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 900),
    );
  }


 static void myKotOrderManageAlert({
   required BuildContext context,
   required String title,
   required String desc,
   btnCancelText = 'No',
   btnOkText = 'Yes',
   required Function onTapOK,
   required Function onTapCancel,
 }) {
   showAnimatedDialog(
     context: context,
     barrierDismissible: true,
     builder: (BuildContext context) {
       return AlertDialog(
           insetPadding: EdgeInsets.all(0.sp),
           titlePadding: EdgeInsets.all(0.sp),
           actionsAlignment: MainAxisAlignment.center,
           contentPadding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 3.sp),
           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
           backgroundColor: Colors.transparent,
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Center(
                 child: Container(
                   padding: EdgeInsets.symmetric(vertical: 5.sp),
                   color: Colors.transparent,
                   width: 0.8.sw,
                   height: 250.h,
                   child: Stack(
                     alignment: AlignmentDirectional.topCenter,
                     children: [
                       Positioned(
                         top: 25.h,
                         child: Container(
                           padding: EdgeInsets.symmetric(vertical: 5.sp),
                           width: 0.7.sw,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20.r),
                             color: Colors.white,
                           ),
                           child: Container(
                             padding: EdgeInsets.symmetric(horizontal: 10.sp),
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 55.verticalSpace,
                                 FittedBox(
                                     child: BigText(
                                       text: title,
                                       color: Colors.black,
                                     )),
                                 5.verticalSpace,
                                 FittedBox(
                                     child: Text(
                                       desc,
                                       style: const TextStyle(
                                         color: Colors.black54,
                                       ),
                                     )),
                                 10.verticalSpace,
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     AppRoundMiniBtn(
                                       text: btnOkText,
                                       color: Colors.green,
                                       onTap: () {
                                         onTapOK();
                                       },
                                     ),
                                     AppRoundMiniBtn(
                                         text: btnCancelText,
                                         color: Colors.redAccent,
                                         onTap: () {
                                           onTapCancel();
                                         })
                                   ],
                                 ),
                                 10.verticalSpace,
                               ],
                             ),
                           ),
                         ),
                       ),
                       Positioned(
                         top: 0,
                         child: CircleAvatar(
                           minRadius: 26.r,
                           maxRadius: 38.r,
                           backgroundColor: Colors.white,
                           child: Icon(
                             Icons.question_mark_sharp,
                             size: 38.sp,
                             color: Colors.white,
                           ),
                         ),
                       ),
                       Positioned(
                         top: 3,
                         child: CircleAvatar(
                           minRadius: 19.r,
                           maxRadius: 31.r,
                           backgroundColor: Colors.green,
                           child: Icon(
                             Icons.question_mark_sharp,
                             size: 38.sp,
                             color: Colors.white,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),

             ],
           ));
     },
     animationType: DialogTransitionType.scale,
     curve: Curves.fastOutSlowIn,
     duration: const Duration(milliseconds: 900),
   );
 }

}
