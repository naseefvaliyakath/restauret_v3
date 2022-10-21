import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common_widget/common_text/mid_text.dart';

class BillingTableHeading extends StatelessWidget {
  const BillingTableHeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      padding:
      EdgeInsets.symmetric(vertical: 3.sp, horizontal: 2.sp),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 1.sw * 0.1,
                child: MidText(text: 'No'),
              ),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 1.sp,
            ),
            SizedBox(
              width: 1.sw * 0.38,
              child: const FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: MidText(
                  text: 'Name',
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 1.sp,
            ),
            SizedBox(
              width: 1.sw * 0.1,
              child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: MidText(text: 'Qnt')),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 1.sp,
            ),
            SizedBox(
              width: 1.sw * 0.1,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: MidText(
                  text: 'Price',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
