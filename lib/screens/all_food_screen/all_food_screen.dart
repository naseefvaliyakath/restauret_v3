import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../alerts/common_alerts.dart';
import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../widget/all_food_screen/category_drop_down_all.dart';
import '../../widget/common_widget/food_card.dart';
import '../../widget/common_widget/food_search_bar.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/two_button-bottom_sheet.dart';
import 'controller/all_food_controller.dart';

class AllFoodScreen extends StatelessWidget {
  const AllFoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AllFoodController>(builder: (ctrl) {
        return RefreshIndicator(
          onRefresh: () async {
            //? to vibrate
            HapticFeedback.mediumImpact();
            await ctrl.refreshAllFood();
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
                        pinned: true,
                        snap: true,
                        title: const Text(
                          'All Foods ',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        titleTextStyle: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w600),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Get.toNamed(RouteHelper.getNotificationScreen());
                              },
                              icon: Icon(
                                FontAwesomeIcons.bell,
                                size: 24.sp,
                              )),
                        ],
                        leading: BackButton(
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        //? search bar and sort icon
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(60.h),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                            child: Row(
                              children: [
                                FoodSearchBar(
                                  screen: SCREEN_ALLFOOD,
                                  onChanged: (value) {
                                    //? search value taken from TextCtrl
                                    ctrl.searchAllFood();
                                  },
                                ),
                                const CategoryDropDownAll()
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: const Color(0xfffafafa),
                      ),
                      //? body section
                      SliverPadding(
                        padding:  EdgeInsets.all(20.sp),
                        sliver:SliverGrid(
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
                                  if(ctrl.isCashier) {
                                    TwoBtnBottomSheet.bottomSheet(
                                        b1Name: 'Add To Today Food',
                                        b2Name: 'Edit Food',
                                        b1Function: () {
                                          Navigator.pop(context);
                                          ctrl.addToToday(ctrl.myAllFoods[index].fdId ?? -1, 'yes');
                                        },
                                        b2Function: () {
                                          Navigator.pop(context);
                                          Get.offAndToNamed(
                                            RouteHelper.updateFoodScreen,
                                            arguments: {
                                              'fdName': ctrl.myAllFoods[index].fdName ?? '',
                                              'fdCategory': ctrl.myAllFoods[index].fdCategory ?? COMMON_CATEGORY,
                                              'fdFullPrice': ctrl.myAllFoods[index].fdFullPrice ?? 0,
                                              'fdThreeBiTwoPrsPrice': ctrl.myAllFoods[index].fdThreeBiTwoPrsPrice ??
                                                  0,
                                              'fdHalfPrice': ctrl.myAllFoods[index].fdHalfPrice ?? 0,
                                              'fdQtrPrice': ctrl.myAllFoods[index].fdQtrPrice ?? 0,
                                              'fdIsLoos': ctrl.myAllFoods[index].fdIsLoos ?? 'no',
                                              'cookTime': ctrl.myAllFoods[index].cookTime ?? 0,
                                              'fdImg': ctrl.myAllFoods[index].fdImg ?? IMG_LINK,
                                              'fdIsToday': ctrl.myAllFoods[index].fdIsToday ?? 'no',
                                              'id': ctrl.myAllFoods[index].fdId ?? 0,
                                            },
                                          );
                                        });
                                  }
                                },
                                onLongPress: () {
                                  twoFunctionAlert(
                                    title: 'Delete this item ?',
                                    subTitle: 'Do you want to delete this food ?',
                                    okBtn: 'Delete',
                                    cancelBtn: 'Cancel',
                                    context: context,
                                    onCancelTap: (){},
                                    onTap: () {
                                      ctrl.deleteFood(ctrl.myAllFoods[index].fdId ?? -1);
                                    },
                                  );
                                },
                                child: FoodCard(
                                  img: ctrl.myAllFoods[index].fdImg ?? IMG_LINK,
                                  name: ctrl.myAllFoods[index].fdName ?? '',
                                  price: ctrl.myAllFoods[index].fdFullPrice ?? 0,
                                  priceThreeByTwo: ctrl.myAllFoods[index].fdThreeBiTwoPrsPrice ?? 0,
                                   priceHalf: ctrl.myAllFoods[index].fdHalfPrice ?? 0,
                                  priceQuarter: ctrl.myAllFoods[index].fdQtrPrice ?? 0,
                                  today: ctrl.myAllFoods[index].fdIsToday ?? 'no',
                                  quick: ctrl.myAllFoods[index].fdIsQuick ?? 'no',
                                  fdIsLoos: ctrl.myAllFoods[index].fdIsLoos ?? 'no',
                                ),
                              );
                            },
                            childCount: ctrl.myAllFoods.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
