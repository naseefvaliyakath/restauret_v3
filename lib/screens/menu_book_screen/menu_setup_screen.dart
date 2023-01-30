import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../alerts/common_alerts.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/two_button-bottom_sheet.dart';
import '../../widget/menu_book_screen/menu_food_card.dart';
import '../../widget/menu_book_screen/toggle_btn_in_card.dart';
import 'controller/menu_book_controller.dart';

class MenuSetupScreen extends StatelessWidget {
  const MenuSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MenuBookController>(builder: (ctrl) {
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
                          'Setup Menu  ',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        titleTextStyle: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w600),
                        actions: [
                          Badge(
                            backgroundColor: Colors.red,
                            child: Container(
                                margin: EdgeInsets.only(right: 10.w),
                                child: Icon(
                                  FontAwesomeIcons.bell,
                                  size: 24.sp,
                                )),
                          ),
                        ],
                        leading: BackButton(
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        //? search bar and sort icon
                        backgroundColor: const Color(0xfffafafa),
                      ),
                      //? body section
                      SliverPadding(
                        padding: EdgeInsets.all(20.sp),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0.sp,
                            mainAxisSpacing: 18.sp,
                            crossAxisSpacing: 18.sp,
                            childAspectRatio: 0.8 / 0.8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  if (ctrl.isCashier) {
                                    TwoBtnBottomSheet.bottomSheet(
                                        b1Name: (ctrl.myAllFoods[index].fdIsAvailable ?? 'no') == 'no'
                                            ? 'Add To Available Food'
                                            : 'Remove To Available Food',
                                        b2Name: (ctrl.myAllFoods[index].fdIsSpecial ?? 'no') == 'no'
                                            ? 'Add To special Food'
                                            : 'Remove To special Food',
                                        b1Function: () {
                                          if ((ctrl.myAllFoods[index].fdIsAvailable ?? 'no') == 'yes') {
                                            ctrl.updateAvailableFood(ctrl.myAllFoods[index].fdId ?? -1, 'no');
                                          } else {
                                            ctrl.updateAvailableFood(ctrl.myAllFoods[index].fdId ?? -1, 'yes');
                                          }
                                          Navigator.pop(context);
                                        },
                                        b2Function: () {
                                          if ((ctrl.myAllFoods[index].fdIsSpecial ?? 'no') == 'yes') {
                                            ctrl.updateSpecialFood(ctrl.myAllFoods[index].fdId ?? -1, 'no');
                                          } else {
                                            ctrl.updateSpecialFood(ctrl.myAllFoods[index].fdId ?? -1, 'yes');
                                          }
                                          Navigator.pop(context);
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
                                    onCancelTap: () {},
                                    onTap: () {},
                                  );
                                },
                                child: MenuFoodCard(
                                  img: ctrl.myAllFoods[index].fdImg ?? IMG_LINK,
                                  name: ctrl.myAllFoods[index].fdName ?? '',
                                  price: ctrl.myAllFoods[index].fdFullPrice ?? 0,
                                  priceThreeByTwo: ctrl.myAllFoods[index].fdThreeBiTwoPrsPrice ?? 0,
                                  priceHalf: ctrl.myAllFoods[index].fdHalfPrice ?? 0,
                                  priceQuarter: ctrl.myAllFoods[index].fdQtrPrice ?? 0,
                                  available: ctrl.myAllFoods[index].fdIsAvailable ?? 'no',
                                  special: ctrl.myAllFoods[index].fdIsSpecial ?? 'no',
                                  showSpecial: true,
                                  showPrice: true,
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
