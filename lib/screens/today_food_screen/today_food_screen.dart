import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/buttons/round_border_icon_button.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/common_widget/food_card.dart';
import '../../widget/common_widget/food_search_bar.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/refresh_icon_btn.dart';
import '../../widget/common_widget/two_button-bottom_sheet.dart';
import '../../widget/today_food_screen/category_drop_down_today.dart';
import 'controller/today_food_controller.dart';

class TodayFoodScreen extends StatelessWidget {
  const TodayFoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodayFoodController>(
      builder: (ctrl) {
        bool horizontal = 1.sh < 1.sw ? true : false;
        return RefreshIndicator(
          onRefresh: () async {
            //? to vibrate
            HapticFeedback.mediumImpact();
            ctrl.refreshTodayFood();
          },
          child: ctrl.isLoading
              ? const MyLoading()
              : SafeArea(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    primary: false,
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //heading
                            const HeadingRichText(name: 'Today Food'),
                            //add food and all food icon icon
                            Row(
                              children: [
                                //add food screen btn
                                //? check user is cashier
                                ctrl.isCashier
                                    ? RoundBorderIconButton(
                                        name: 'Add food',
                                        icon: FontAwesomeIcons.utensils,
                                        onTap: () {
                                          Get.toNamed(RouteHelper.getAddFoodScreen());
                                        },
                                      )
                                    : const SizedBox(),
                                10.horizontalSpace,

                                //all food screen btn
                                RoundBorderIconButton(
                                  name: 'All food',
                                  icon: FontAwesomeIcons.borderAll,
                                  onTap: () {
                                    Get.toNamed(RouteHelper.getAllFoodScreen());
                                  },
                                ),
                               Platform.isWindows ?  10.horizontalSpace : 0.horizontalSpace,
                                Visibility(
                                  visible: Platform.isWindows ? true : false,
                                  child: RefreshIconBtn(
                                    onTap: () {
                                      ctrl.refreshTodayFood(showSnack: true);
                                    },
                                    onLongTap: () {
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(horizontal ? 90.h : 60.h),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                            //? search bar and food sort icon in row
                            child: Row(
                              children: [
                                FoodSearchBar(
                                  screen: SCREEN_TODAY,
                                  onChanged: (value) {
                                    //? search value taken from TextCtrl
                                    ctrl.searchTodayFood();
                                  },
                                ),
                                const CategoryDropDownToday(),
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: const Color(0xfffafafa),
                      ),
                      //? food grid view
                      SliverPadding(
                        padding: EdgeInsets.all(20.sp),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0.sp,
                            mainAxisSpacing: 18.sp,
                            crossAxisSpacing: 18.sp,
                            childAspectRatio: 2 / 2.8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  if (ctrl.isCashier) {
                                    TwoBtnBottomSheet.bottomSheet(
                                        b1Name: 'Remove From Today Food',
                                        b2Name: (ctrl.myTodayFoods[index].fdIsQuick ?? 'no') == 'no' ? 'Add to quick bill' : 'Remove from quick bill',
                                        b1Function: () async {
                                          Navigator.pop(context);
                                          ctrl.removeFromToday(ctrl.myTodayFoods[index].fdId ?? -1, 'no');
                                        },
                                        b2Function: () {
                                          Navigator.pop(context);
                                          if (ctrl.myTodayFoods[index].fdIsQuick == 'no') {
                                            ctrl.updateToQuickBill(ctrl.myTodayFoods[index].fdId ?? -1, 'yes');
                                          } else {
                                            ctrl.updateToQuickBill(ctrl.myTodayFoods[index].fdId ?? -1, 'no');
                                          }
                                        });
                                  }
                                },
                                child: FoodCard(
                                  img: ctrl.myTodayFoods[index].fdImg ?? IMG_LINK,
                                  name: ctrl.myTodayFoods[index].fdName ?? '',
                                  price: ctrl.myTodayFoods[index].fdFullPrice ?? 0,
                                  priceThreeByTwo: ctrl.myTodayFoods[index].fdThreeBiTwoPrsPrice ?? 0,
                                  priceHalf: ctrl.myTodayFoods[index].fdHalfPrice ?? 0,
                                  priceQuarter: ctrl.myTodayFoods[index].fdQtrPrice ?? 0,
                                  today: ctrl.myTodayFoods[index].fdIsToday ?? 'no',
                                  quick: ctrl.myTodayFoods[index].fdIsQuick ?? 'no',
                                  fdIsLoos: ctrl.myTodayFoods[index].fdIsLoos ?? 'no',
                                ),
                              );
                            },
                            childCount: ctrl.myTodayFoods.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
