import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import '../common_widget/common_text/big_text.dart';



class TotalPriceTxt extends StatelessWidget {
  final double price;
  const TotalPriceTxt({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BigText(
          text: 'Total : ',
          size:horizontal ? 23.sp : 18.sp,
        ),
        20.horizontalSpace,
        AnimatedFlipCounter(
          duration: const Duration(milliseconds: 500),
          value: price,
          fractionDigits: 2,
          textStyle: TextStyle(fontSize:horizontal ? 23.sp :  18.sp, color: Colors.black54, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
