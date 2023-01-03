import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhiteButtonWithIcon extends StatelessWidget {

  final String text;
  final IconData icon;
  final Function onTap;
  const WhiteButtonWithIcon({Key? key, required this.text, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return InkWell(
      onTap: ()=>onTap(),
      child: Center(
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
            height: 0.04.sh,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FittedBox(child: Icon(icon,color: Colors.grey,size: 18.sp,)),
               5.horizontalSpace,
               FittedBox(child: Text(text,style:  const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),))
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
