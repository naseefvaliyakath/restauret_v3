import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common_widget/common_text/big_text.dart';


class TotalPriceTxt extends StatelessWidget {
  final double price;
  const TotalPriceTxt({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BigText(
          text: 'Total : ',
          size: 18.sp,
        ),
        20.horizontalSpace,
        BigText(
          text: 'Rs $price',
          size: 18.sp,
          color: Colors.black54,
        )
      ],
    );
  }
}
