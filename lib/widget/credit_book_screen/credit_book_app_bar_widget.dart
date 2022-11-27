import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../screens/all_food_screen/controller/all_food_controller.dart';
import '../../screens/credit_book_screen/controller/credit_book_ctrl.dart';
import '../../screens/today_food_screen/controller/today_food_controller.dart';
import '../common_widget/common_text/heading_rich_text.dart';
import '../common_widget/notification_icon.dart';

class CreditBookAppBar extends StatelessWidget {
  final Function onChanged;
  final String title;


  const CreditBookAppBar({Key? key, required this.onChanged, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(
                onPressed: () {
                  Get.back();
                },
              ),
              HeadingRichText(name: title),
              NotificationIcon(
                onTap: () {},
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              child: SizedBox(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
                        hintText: 'Search user ...',
                        hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 16.sp),
                        isDense: true,
                        // Added this
                        contentPadding: EdgeInsets.all(3.sp), // Added this
                      ),
                      //? this widget is used in todayFood and allFood
                      //? if screen SCREEN_TODAY then take controller TodayFoodController else take it AllFoodController
                      controller: Get.find<CreditBookCTRL>().searchTD
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
