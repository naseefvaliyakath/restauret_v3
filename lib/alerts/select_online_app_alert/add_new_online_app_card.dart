import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/common_widget/common_text/big_text.dart';


class AddNewOnlineAppCard extends StatelessWidget {
  const AddNewOnlineAppCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20.r), boxShadow: [
        BoxShadow(
          offset: const Offset(4, 6),
          blurRadius: 4,
          color: Colors.black.withOpacity(0.3),
        )
      ]),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle,
                size: 30.sp,
                color: Colors.grey,
              ),
              10.verticalSpace,
               BigText(
                text: 'Add New ',
                color: Colors.grey,
                size: 20.sp,
              )
            ],
          ),
        ),
      ),
    );
  }
}
