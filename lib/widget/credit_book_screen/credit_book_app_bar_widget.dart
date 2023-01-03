import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/credit_user_screen/controller/credit_user_ctrl.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../routes/route_helper.dart';
import '../common_widget/common_text/heading_rich_text.dart';
import '../common_widget/notification_icon.dart';

class CreditBookAppBar extends StatelessWidget {
  final Function onChanged;
  final String title;

  const CreditBookAppBar({Key? key, required this.onChanged, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: horizontal ? 20.h : 0,
          ),
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
                onTap: () {
                  Get.toNamed(RouteHelper.getNotificationScreen());
                },
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: horizontal ? 100.w :  5.w),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              child: SizedBox(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: horizontal ? 18.h :  8.h),
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
                          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: horizontal ? 24.sp : 16.sp),
                          isDense: true,
                          // Added this
                          contentPadding: EdgeInsets.all(3.sp), // Added this
                        ),
                        controller: Get.find<CreditUserCTRL>().userSearchTD),
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
