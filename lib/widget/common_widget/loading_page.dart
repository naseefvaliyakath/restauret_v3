import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class MyLoading extends StatelessWidget {
  const MyLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Lottie.asset(
          'assets/lottie/loading.json',
          width: 100.sp,
          height: 100.sp,

        ),
      ),
    );
  }
}
