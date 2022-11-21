import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class KotBillItemHeading extends StatelessWidget {
  const KotBillItemHeading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(bottom: 1.sp),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'S/N',
              maxLines: 1,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      'Name',
                      maxLines: 1,
                      //softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Text(
                'Qnt',
                maxLines: 1,
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
