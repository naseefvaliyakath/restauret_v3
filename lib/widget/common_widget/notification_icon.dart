import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationIcon extends StatelessWidget {
  final Function onTap;
  const NotificationIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       onTap();
      },
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), border: Border.all(color: Colors.grey)),
        child: Center(
          child: Badge(
            badgeColor: Colors.red,
            child: Icon(
              FontAwesomeIcons.bell,
              size: 24.sp,
            ),
          ),
        ),
      ),
    );
  }
}
