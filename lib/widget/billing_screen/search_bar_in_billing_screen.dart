import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';

import '../../constants/app_colors/app_colors.dart';


class SearchBarInBillingScreen extends StatelessWidget {

  final Function onChanged;
  const SearchBarInBillingScreen({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Flexible(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: SizedBox(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical:horizontal ? 20.h : 8.h),
              child: TextField(
                onChanged: (vale){
                  onChanged(vale);
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  icon:  Icon(Icons.search,size: horizontal ? 28.sp : 24.sp,color: AppColors.textGrey,),
                  border: InputBorder.none,
                  hintText: 'Search here ...',
                  hintStyle: TextStyle(color: AppColors.textGrey,fontSize:horizontal ? 26.sp : 16.sp),
                  isDense: true,
                  contentPadding: EdgeInsets.all(3.sp),
                ),
                controller: Get.find<BillingScreenController>().searchTD,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
