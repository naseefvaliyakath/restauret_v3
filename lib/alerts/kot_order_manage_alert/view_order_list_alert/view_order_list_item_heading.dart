import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ViewOrderListItemHeading extends StatelessWidget {


  const ViewOrderListItemHeading(
      {Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xff95e0ec),
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(5.r)),
      height: 25.h,
      width: 1.sw * 0.6,
      padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 2.sp),
      margin: EdgeInsets.only(bottom: 2.sp),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 1.sw * 0.05,
              padding: EdgeInsets.only(left: 5.sp),
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  'No',
                  maxLines: 1,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 1.sp,
            ),
            SizedBox(
              width: 1.sw * 0.275,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child:  Text(
                  'Name',
                  maxLines: 1,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 1.sp,
            ),
            SizedBox(
              width: 1.sw * 0.06,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Qnt',
                  maxLines: 1,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 1.sp,
            ),
            SizedBox(
              width: 1.sw * 0.08,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Price',
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 1.sp,
            ),
            SizedBox(
              width: 1.sw * 0.08,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Status',
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
