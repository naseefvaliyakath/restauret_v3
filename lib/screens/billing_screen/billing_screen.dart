import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../alerts/common_alerts.dart';
import '../../alerts/food_billing_alert/food_billing_alert.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../routes/route_helper.dart';
import '../../widget/billing_screen/billing_food_card.dart';
import '../../widget/billing_screen/billing_food_err_card.dart';
import '../../widget/billing_screen/billing_item_tile.dart';
import '../../widget/billing_screen/billing_table_heading.dart';
import '../../widget/billing_screen/category_drop_down.dart';
import '../../widget/billing_screen/clear_all_bill_widget.dart';
import '../../widget/billing_screen/search_bar_in_billing_screen.dart';
import '../../widget/billing_screen/totel_price_txt.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/common_text/heading_rich_text.dart';
import '../../widget/common_widget/notification_icon.dart';
import '../../widget/common_widget/snack_bar.dart';
import 'controller/billing_screen_controller.dart';


class BillingScreen extends StatelessWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //? if navigated from kot update  tab on back press not ask save in hive
        if (Get
            .find<BillingScreenController>()
            .isNavigateFromKotUpdate == true) {
          return true;
        } else {
          //? checking if any bill added in the list
          if (Get
              .find<BillingScreenController>()
              .billingItems
              .isNotEmpty) {
            askConfirm(context);
            return false;
          } else {
            return true;
          }
        }
      },
      child: Scaffold(
        body: GetBuilder<BillingScreenController>(builder: (ctrl) {
          return GestureDetector(
            onTap: () {
              //? to close key bord on outside touch
              //? so normally key bord not close touch list view
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.verticalSpace,
                        //? back arrow and heading and notification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //? back arrow and heading
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 24.sp,
                                    ),
                                    onPressed: () {
                                      //? if navigated from kot update  tab on back press not ask save in hive
                                      if (ctrl.isNavigateFromKotUpdate == true) {
                                        Get.back();
                                      } else {
                                        if (ctrl.billingItems.isNotEmpty) {
                                          askConfirm(context);
                                        } else {
                                          Get.back();
                                        }
                                      }
                                    },
                                    splashRadius: 24.sp,
                                  ),
                                  15.horizontalSpace,
                                  const HeadingRichText(name: 'Take away billing'),
                                ],
                              ),
                            ),

                            //? notification icon
                            NotificationIcon(onTap: () {}),
                          ],
                        ),
                        //?  search and category
                        Row(
                          children: [
                            //? search bar
                            SearchBarInBillingScreen(onChanged: (value) {
                              //? search value taken from TextCtrl
                              ctrl.searchTodayFood();
                            }),
                            //? category dropdown
                            const CategoryDropDown()
                          ],
                        ),
                        //?  show foods to billing
                        Container(
                            width: double.maxFinite,
                            height: 0.18.sh,
                            padding: EdgeInsets.all(5.sp),
                            //height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return ctrl.isLoading
                                    ? const BillingFoodErrCard()
                                    : BillingFoodCard(

                                  onTap: () {
                                    // ? if settled button clicked cant add new item
                                    if (ctrl.isClickedSettle.value) {
                                      AppSnackBar.errorSnackBar('This bill is already settled', 'Click new order !');
                                    } else {
                                      //? billing alert popup
                                      foodBillingAlert(
                                        context,
                                        price: ctrl.myTodayFoods[index].fdFullPrice ?? 0,
                                        img: ctrl.myTodayFoods[index].fdImg ?? 'https://mobizate.com/uploads/sample.jpg',
                                        name: ctrl.myTodayFoods[index].fdName ?? '',
                                        fdId: ctrl.myTodayFoods[index].fdId ?? -1,
                                      );
                                    }
                                    //? to close key bord on outside touch
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  },
                                  img: ctrl.myTodayFoods[index].fdImg ?? 'https://mobizate.com/uploads/sample.jpg',
                                  name: ctrl.myTodayFoods[index].fdName ?? '',
                                  price: ctrl.myTodayFoods[index].fdFullPrice ?? 0,
                                );
                              },
                              //? in loading to show 8 loading card
                              itemCount: ctrl.isLoading ? 8 : ctrl.myTodayFoods.length ?? 0,
                            )),
                        //? Items Ordered title
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          //? Items Ordered text
                          BigText(
                            text: 'Items Ordered ',
                            size: 15.sp,
                          ),
                          //? clear bill btn
                          ClearAllBill(onTap: () {
                            ctrl.clearAllBillItems();
                          }),
                        ]),
                        //? billing table
                        Container(
                          decoration:
                          BoxDecoration(border: Border.all(color: AppColors.mainColor), borderRadius: BorderRadius.circular(5.r)),
                          padding: EdgeInsets.all(3.sp),
                          width: double.maxFinite,
                          height: 0.52.sh,
                          child: Column(
                            children: [
                              //? billing table heading
                              const BillingTableHeading(),
                              6.verticalSpace,
                              SizedBox(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return BillingItemTile(
                                      index: index,
                                      slNumber: index + 1,
                                      itemName: ctrl.billingItems[index]['name'],
                                      qnt: ctrl.billingItems[index]['qnt'],
                                      kitchenNote: ctrl.billingItems[index]['ktNote'],
                                      price: ctrl.billingItems[index]['price'],
                                      onLongTap: () {
                                        //? to update or delete the items added in the billing list
                                        deleteItemFromBillAlert(context, index);
                                      },
                                    );
                                  },
                                  itemCount: ctrl.billingItems.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TotalPriceTxt(price: ctrl.totalPrice),
                        //?  controller buttons
                        //? if navigate from orderViewScreen for updating order
                        //? then it only showing update order and cancel btn
                        ctrl.isNavigateFromKotUpdate
                            ? Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            height: 40.h,
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Flexible(
                                    child: ProgressButton(
                                      btnCtrlName: 'kotUpdate',
                                      text: 'Update KOT Order',
                                      ctrl: ctrl,
                                      color: Colors.green,
                                      onTap: () async {
                                        ctrl.updateKotOrder();
                                      },
                                    ),
                                  ),
                                  3.horizontalSpace,
                                  Flexible(
                                    child: AppMiniButton(
                                      color: Colors.redAccent,
                                      text: 'Cancel Update',
                                      onTap: () {
                                        //  Get.offNamed(RouteHelper.getOrderViewScreen());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ))
                            : Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            height: 40.h,
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Flexible(
                                    child: ProgressButton(
                                      btnCtrlName: 'kot',
                                      text: 'Order',
                                      ctrl: ctrl,
                                      color: Colors.green,
                                      onTap: () async {
                                        //? if settled button clicked cant add new item
                                        if (ctrl.isClickedSettle.value) {
                                          AppSnackBar.errorSnackBar('This bill is already settled', 'Click new order !');
                                          ctrl.btnControllerKot.error();
                                          await Future.delayed(const Duration(milliseconds: 500), () {
                                            ctrl.btnControllerKot.reset();
                                          });
                                        } else {
                                          await ctrl.sendKotOrder();
                                        }
                                      },
                                    ),
                                  ),
                                  3.horizontalSpace,
                                  Flexible(
                                    child: AppMiniButton(
                                      color: const Color(0xffee588f),
                                      text: 'Settle',
                                      onTap: () async {
                                        ctrl.settleBillingCash(context, ctrl);
                                      },
                                    ),
                                  ),
                                  3.horizontalSpace,
                                  Flexible(
                                    child: ProgressButton(
                                      btnCtrlName: 'hold',
                                      text: 'Hold',
                                      ctrl: ctrl,
                                      color: AppColors.mainColor_2,
                                      onTap: () async {
                                        await ctrl.addHoldBillItem();
                                      },
                                    ),
                                  ),
                                  3.horizontalSpace,
                                  Flexible(
                                    child: AppMiniButton(
                                      color: AppColors.mainColor,
                                      text: 'KOT',
                                      onTap: () {
                                        ctrl.kotDialogBox(context);
                                      },
                                    ),
                                  ),
                                  3.horizontalSpace,
                                  Flexible(
                                    child: AppMiniButton(
                                      color: AppColors.mainColor,
                                      text: 'New Order',
                                      onTap: () async {
                                        //Get.find<HiveHoldBillController>().clearBill(index: 1);
                                        ctrl.enableNewOrder();
                                      },
                                    ),
                                  ),
                                  3.horizontalSpace,
                                  Flexible(
                                    child: AppMiniButton(
                                      color: const Color(0xff62c5ce),
                                      text: 'All Order',
                                      onTap: () {
                                        //  Get.offNamed(RouteHelper.getOrderViewScreen());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                )),
          );
        }),
      ),
    );
  }
}
