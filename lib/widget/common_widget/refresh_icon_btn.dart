import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/app_colors/app_colors.dart';

class RefreshIconBtn extends StatelessWidget {
  final Function onTap;
  final Function onLongTap;
  const RefreshIconBtn({Key? key, required this.onTap, required this.onLongTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      splashColor: AppColors.mainColor_2,
      onTap: () async{
        onTap();
      },
      onLongPress: ()async{
        onLongTap();
      },
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), border: Border.all(color: Colors.grey)),
        child: Center(
          child: Icon(
            FontAwesomeIcons.arrowsRotate,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}