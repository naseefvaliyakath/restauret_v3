import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_text/big_text.dart';


class CategoryCard
    extends StatelessWidget {
  final Color color;
  final String text;
  final Function onTap;
  final Function onLongTap;
  final int indexForColour;

  const CategoryCard({Key? key, required this.color, required this.text, required this.onTap, required this.onLongTap, this.indexForColour=0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return InkWell(
        borderRadius: BorderRadius.circular(20.r),
      onTap: ()=>onTap(),
      onLongPress: ()async{
          await onLongTap();
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: SizedBox(
          height:horizontal ? 75.h : 60.h,
          width: horizontal ?  0.18.sw : 0.33.sw  ,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        color: Colors.primaries[indexForColour],
                        width: 30.h,
                        height: 30.h,
                        child: Center(
                          child: BigText(
                            text: text[0].toUpperCase(),
                            size: 20.h,
                            color:Colors.white,
                          ),
                        ),
                      )),
                  6.horizontalSpace,
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        text.toUpperCase(),
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.fade,
                      ),
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
