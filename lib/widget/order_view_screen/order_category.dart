import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';


class OrderCategory extends StatelessWidget {
  final Color color;
  final String text;
  final String firstLetter;
  final Color? circleColor;
  final Function onTap;

  const OrderCategory(
      {Key? key,
      required this.color,
      required this.text,
         this.circleColor = AppColors.mainColor, required this.onTap, required this.firstLetter })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: ()=>onTap(),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          height:horizontal ? 75.h :  55.h,
          width:horizontal ?  0.18.sw : 0.33.sw  ,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20.0.r),
                      child: Container(
                        height:horizontal ? 50.h :  30.h,
                        width:horizontal ? 50.h : 30.w,
                        color: circleColor,
                        child: Center(
                          child: Text(
                            firstLetter.toUpperCase(),
                            style: TextStyle(color: Colors.white,
                              fontSize: 15.sp,),
                          ),
                        ),
                      )),
                  6.horizontalSpace,
                  Flexible(
                    child: Text(
                      text,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
