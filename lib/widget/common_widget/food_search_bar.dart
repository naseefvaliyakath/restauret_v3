import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../screens/all_food_screen/controller/all_food_controller.dart';
import '../../screens/credit_book_screen/controller/credit_book_ctrl.dart';
import '../../screens/today_food_screen/controller/today_food_controller.dart';

class FoodSearchBar extends StatelessWidget {
  final Function onChanged;
  final String screen;

  const FoodSearchBar({Key? key, required this.onChanged, required this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: SizedBox(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
              child: TextField(
                onChanged: (vale) {
                  onChanged(vale);
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    size: 24.sp,
                    color: AppColors.textGrey,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search here ...',
                  hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 16.sp),
                  isDense: true,
                  // Added this
                  contentPadding: EdgeInsets.all(3.sp), // Added this
                ),
                //? this widget is used in todayFood and allFood
                //? if screen SCREEN_TODAY then take controller TodayFoodController else take it AllFoodController
                controller: screen == SCREEN_TODAY
                    ? Get.find<TodayFoodController>().searchTD
                    : screen == CREDIT_BOOK_SCREEN
                        ? Get.find<CreditBookCTRL>().searchTD
                        : Get.find<AllFoodController>().searchTD,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
