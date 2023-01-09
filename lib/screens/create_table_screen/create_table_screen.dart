import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../routes/route_helper.dart';
import '../../widget/billing_screen/white_button_with_icon.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/common_widget/horizontal_divider.dart';
import '../../widget/common_widget/notification_icon.dart';
import '../../widget/create_table_screen/table_chair_widget/circle_table_chair_widget.dart';
import '../../widget/create_table_screen/table_chair_widget/ovel_table_chair_widget.dart';
import '../../widget/create_table_screen/table_chair_widget/rectangle_table_chair_widget.dart';
import '../../widget/create_table_screen/table_chair_widget/squre_table_chair_widget.dart';
import '../../widget/create_table_screen/table_shape_drop_down.dart';
import 'controller/create_table_controller.dart';


class CreateTableScreen extends StatelessWidget {
  const CreateTableScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        Get.offNamed(RouteHelper.getProfileScreen());
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: GetBuilder<CreateTableController>(builder: (ctrl) {
            return SafeArea(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // heading
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //back arrow
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 24.sp,
                              ),
                              onPressed: () {
                               Get.offNamed(RouteHelper.getProfileScreen());
                              },
                              splashRadius: 24.sp,
                            ),
                            // heading my restaurant
                            const HeadingRichText(name: 'Create your table'),
                            //notification
                             NotificationIcon(onTap: (){},),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      SizedBox(
                        child: ctrl.tableShape == '1'
                            ? const RectangleTableChairWidget()
                            : ctrl.tableShape == '2'
                                ? const SquareTableChairWidget()
                                : ctrl.tableShape == '3'
                                    ? const CircleTableChairWidget()
                                    : ctrl.tableShape == '4'
                                        ? const OvalTableChairWidget()
                                        : const RectangleTableChairWidget(),
                      ),
                      SizedBox(
                        height: 1.sh * 0.03,
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WhiteButtonWithIcon(text: 'Enter Table Name', icon: Icons.edit, onTap: () {}),
                          const TableShapeDropDown(),
                        ],
                      ),
                      5.verticalSpace,
                      const HorizontalDivider(),
                      //left chair
                      5.verticalSpace,
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        height: 55.h,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: BigText(
                                  text: 'Left Chair :',
                                  size: 15.sp,
                                ),
                              ),
                              10.horizontalSpace,
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                color: Colors.black54,
                                iconSize: 35.sp,
                                onPressed: () {
                                  ctrl.removeLeftChair();
                                },
                              ),
                              5.horizontalSpace,
                              BigText(
                                text: '${ctrl.leftChairCount}',
                                size: 20.w,
                                color: AppColors.titleColor,
                              ),
                              5.horizontalSpace,
                              IconButton(
                                icon:  Icon(Icons.add_circle,size: 24.sp),
                                color: Colors.black54,
                                iconSize: 35.sp,
                                onPressed: () {
                                  ctrl.addLeftChair();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      //right chair
                      5.verticalSpace,
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        height: 55.h,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: BigText(
                                  text: 'Right Chair :',
                                  size: 15.sp,
                                ),
                              ),
                              10.horizontalSpace,
                              IconButton(
                                icon:  Icon(Icons.remove_circle,size: 24.sp),
                                color: Colors.black54,
                                iconSize: 35.sp,
                                onPressed: () {
                                  ctrl.removeRightChair();
                                },
                              ),
                              5.horizontalSpace,
                              BigText(
                                text: '${ctrl.rightChairCount}',
                                size: 20.w,
                                color: AppColors.titleColor,
                              ),
                              5.horizontalSpace,
                              IconButton(
                                icon: Icon(Icons.add_circle,size: 24.sp),
                                color: Colors.black54,
                                iconSize: 35.sp,
                                onPressed: () {
                                  ctrl.addRightChair();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      //top chair
                      5.verticalSpace,
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        height: 55.h,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: BigText(
                                  text: 'Top Chair :',
                                  size: 15.sp,
                                ),
                              ),
                              10.horizontalSpace,
                              IconButton(
                                icon: Icon(Icons.remove_circle,size: 24.sp),
                                color: Colors.black54,
                                iconSize: 35.sp,
                                onPressed: () {
                                  ctrl.removeTopChair();
                                },
                              ),
                              5.horizontalSpace,
                              BigText(
                                text: ctrl.topChairCount.toString(),
                                size: 20.w,
                                color: AppColors.titleColor,
                              ),
                              5.horizontalSpace,
                              IconButton(
                                icon: Icon(Icons.add_circle,size: 24.sp),
                                color: Colors.black54,
                                iconSize: 35.sp,
                                onPressed: () {
                                  ctrl.addTopChair();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      //bottom-chair
                      5.verticalSpace,
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        height: 55.h,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: BigText(
                                  text: 'Bottom Chair :',
                                  size: 15.sp,
                                ),
                              ),
                              10.horizontalSpace,
                              IconButton(
                                icon: Icon(Icons.remove_circle,size: 24.sp),
                                color: Colors.black54,
                                iconSize: 35.sp,
                                onPressed: () {
                                  ctrl.removeBottomChair();
                                },
                              ),
                              5.horizontalSpace,
                              BigText(
                                text: ctrl.bottomChairCount.toString(),
                                size: 20.w,
                                color: AppColors.titleColor,
                              ),
                              5.horizontalSpace,
                              IconButton(
                                icon: Icon(Icons.add_circle,size: 24.sp),
                                color: Colors.black54,
                                iconSize: 35.sp,
                                onPressed: () {
                                  ctrl.addBottomChair();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      SizedBox(
                        width: 1.sw * 0.4,
                        child: Row(
                          children: [
                           /* Expanded(
                                child: AppMIniButton(
                              text: 'Add Table',
                              bgColor: AppColors.mainColor,
                              onTap: () {
                                ctrl.insertTable();
                              },
                            )),*/
                            Expanded(
                                child: ProgressButton(
                                  btnCtrlName: 'createTable',
                                  text: 'Create Table',
                                  ctrl: ctrl,
                                  color: const Color(0xfff25f27),
                                  onTap: () async {
                                    await ctrl.insertTable();
                                  },
                                ),),
                          ],
                        ),
                      )
                    ],
                  )

              ),
            );
          }),
        ),
      ),
    );
  }
}
