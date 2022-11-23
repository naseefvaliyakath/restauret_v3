import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class KotBillItemHeading extends StatelessWidget {
  //? only needed in invoice
  final bool showPrice;
  const KotBillItemHeading({
    Key? key,  this.showPrice = false,
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
              width: showPrice ? 150.w :  200.w,
              child: Text(
                'Name',
                maxLines: 1,
                //softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
            Visibility(
              visible: showPrice ? true : false,
              child: SizedBox(
                width: 50.w,
                child: SizedBox(
                  child: Text(
                    '  Price',
                    maxLines: 1,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
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
