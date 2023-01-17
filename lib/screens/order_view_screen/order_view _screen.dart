import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import '../../alerts/invoice_alert_for_order_view_page/invoice_alert_for_order_view.dart';
import '../../alerts/kot_order_manage_alert/kot_order_manage_alert.dart';
import '../../alerts/my_dialog_body.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../hive_database/controller/hive_hold_bill_controller.dart';
import '../../models/kitchen_order_response/order_bill.dart';
import '../../routes/route_helper.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/snack_bar.dart';
import '../../widget/order_view_screen/date_picker_for_order_view.dart';
import '../../widget/order_view_screen/order_category.dart';
import '../../widget/order_view_screen/order_hold_card.dart';
import '../../widget/order_view_screen/order_settled_card.dart';
import '../../widget/order_view_screen/order_status_card.dart';
import '../../widget/order_view_screen/qr_scanner_icon_btn.dart';
import 'controller/order_view_controller.dart';

class OrderViewScreen extends StatelessWidget {
  OrderViewScreen({Key? key}) : super(key: key);

  //? category tabs for different order type
  final List categoryCard = [
    {'text': "KOT", 'circleColor': Colors.redAccent},
    {'text': "SETTLED", 'circleColor': Colors.green},
    {'text': "HOLD", 'circleColor': Colors.blueAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderViewController>(builder: (ctrl) {
      ScrollController scrollController = ScrollController();
      bool horizontal = 1.sh < 1.sw ? true : false;
      return WillPopScope(
        onWillPop: () async {
          Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": ctrl.fromBillingScreenName});
          return false;
        },
        child: Scaffold(
          body: ctrl.isLoading
              ? const MyLoading()
              : RefreshIndicator(
            onRefresh: () async {
              ctrl.refreshSettledOrder(showSnack: true);
              ctrl.refreshDatabaseKot();
              AppSnackBar.successSnackBar('Success', 'Data refreshed');
            },
            child: SafeArea(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                primary: false,
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    //? back arrow
                    leading: BackButton(
                      onPressed: () {
                        Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {"billingPage": ctrl.fromBillingScreenName});
                      },
                    ),
                    snap: true,
                    //? heading
                    title: const Text(
                      'All Orders',
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    titleTextStyle: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w600),
                    actions: [
                      Badge(
                        badgeColor: Colors.red,
                        child: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: IconButton(
                                onPressed: () {
                                  Get.toNamed(RouteHelper.getNotificationScreen());
                                },
                                icon: Icon(
                                  FontAwesomeIcons.bell,
                                  size: 24.sp,
                                ))),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(horizontal ? 130.h :  110.h),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                    child: BigText(
                                      text: 'Today Date : ',
                                      size: 18.sp,
                                    )),
                                DatePickerForOrderView(
                                  dateTime: ctrl.selectedDateRangeForSettledOrder,
                                  onTap: () async {
                                    if (ctrl.tappedTabName == 'SETTLED') {
                                      await ctrl.datePickerForSettledOrder(context);
                                    } else {
                                      AppSnackBar.myFlutterToast(message: 'Sorting only for settled order', bgColor: Colors.black54);
                                    }
                                  },
                                ),
                                const QrScannerIconBtn(),
                              ],
                            ),
                            SizedBox(
                              //? type of order like KOT , SETTLED ,HOLD
                              height: horizontal ? 75.h : 55.h,
                              width: double.maxFinite,
                              child: Center(
                                child: Scrollbar(
                                  thickness: Platform.isWindows ? 10.sp : 0,
                                  controller: scrollController,
                                  child: ListView(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ... categoryCard.map((e) {
                                        return OrderCategory(
                                          firstLetter: e['text'][0],
                                          onTap: () async {
                                            //? for color change
                                            ctrl.setStatusTappedIndex(categoryCard.indexOf(e));
                                            // ?for show different orders
                                            ctrl.updateTappedTabName(e['text'] ?? 'KOT');
                                            if (ctrl.tappedTabName == 'KOT') {
                                              //  ctrl.refreshDatabaseKot();
                                            }
                                            if (ctrl.tappedTabName == 'SETTLED') {
                                              //  ctrl.getAllSettledOrder();
                                            }
                                            if (ctrl.tappedTabName == 'HOLD') {
                                              await ctrl.getAllHoldOrder();
                                            }
                                          },
                                          color: ctrl.tappedIndex == categoryCard.indexOf(e) ? AppColors.mainColor_2 : Colors.white,
                                          circleColor: e['circleColor'],
                                          text: e['text'] ?? 'KOT',
                                        );
                                      }).toList()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    backgroundColor: const Color(0xfffafafa),
                  ),
                  //? orders
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0.sp,
                        mainAxisSpacing: 18.sp,
                        crossAxisSpacing: 18.sp,
                        childAspectRatio: 2 / 2.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          // checking witch tab is selected
                          if (ctrl.tappedTabName == 'KOT') {
                            return OrderStatusCard(
                              name: ctrl.kotBillingItems[index].fdOrder!.isEmpty
                                  ? "error"
                                  : ctrl.kotBillingItems[index].fdOrder?[0].name ?? "",
                              price: (ctrl.kotBillingItems[index].totalPrice ?? 0).toString(),
                              onTap: () {
                                //? to show all KOT management buttons
                                kotOrderManageAlert(context: context, ctrl: ctrl, index: index);
                              },
                              //? changing Bg color as per the order status
                              borderColor: ctrl.kotBillingItems[index].fdOrderStatus == PENDING
                                  ? Colors.orange
                                  : ctrl.kotBillingItems[index].fdOrderStatus == PROGRESS
                                  ? Colors.pink
                                  : ctrl.kotBillingItems[index].fdOrderStatus == READY
                                  ? Colors.green
                                  : ctrl.kotBillingItems[index].fdOrderStatus == REJECT
                                  ? Colors.red
                                  : Colors.orange,
                              //? changing card color as per order status
                              cardColor: ctrl.kotBillingItems[index].fdOrderStatus == REJECT
                                  ? Colors.red.withOpacity(0.1)
                                  : ctrl.kotBillingItems[index].fdOrderStatus == READY
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.white,
                              orderId: ctrl.kotBillingItems[index].Kot_id ?? -1,
                              orderStatus: ctrl.kotBillingItems[index].fdOrderStatus ?? PENDING,
                              orderType: ctrl.kotBillingItems[index].fdOrderType ?? TAKEAWAY,
                              tableName: ctrl.kotBillingItems[index].kotTableChairSet?[0] ?? {'room': MAIN_ROOM, 'table': -1, 'chair': -1},
                              dateTime: ctrl.kotBillingItems[index].kotTime ?? DateTime.now(),
                              totalItem: ctrl.kotBillingItems[index].fdOrder?.length ?? 0,
                            );
                          }
                          if (ctrl.tappedTabName == 'SETTLED') {
                            return OrderSettledCard(
                              //? to show first item name in the settled order
                              name: ((ctrl.settledBillingItems[index].fdOrder) ?? []).isEmpty
                                  ? "no item"
                                  : (ctrl.settledBillingItems[index].fdOrder?[0].name ?? ""),
                              price: '${ctrl.settledBillingItems[index].grandTotal ?? 0}',
                              onLongTap: () {
                                MyDialogBody.myConfirmDialogBody(
                                    title: 'update this order ?',
                                    context: context,
                                    desc: ' Do yoy want to update this order ? ',
                                    btnCancelText: 'Delete',
                                    btnOkText: 'Edit',
                                    onTapOK: () {
                                      Navigator.pop(context);
                                      ctrl.updateSettleBillingCash(context, ctrl, index);
                                    },
                                    onTapCancel: () async {
                                      //? delete the settled item from list
                                      ctrl.deleteSettledOrder(ctrl.settledBillingItems[index].settled_id ?? -1);
                                      Navigator.pop(context);
                                      //? to refresh after update
                                      ctrl.refreshSettledOrder(showSnack: true);
                                    });
                              },
                              //? to show bill of settled order
                              onTap: () {
                                //? billing list
                                final List<OrderBill> fdOrder = [];
                                final List<dynamic> billingItems = [];
                                fdOrder.addAll(ctrl.settledBillingItems[index].fdOrder?.toList() ?? []);
                                billingItems.clear();
                                //? adding fdOrder to billingItem list
                                for (var element in fdOrder) {
                                  billingItems.add({
                                    'fdId': element.fdId ?? -1,
                                    'name': element.name ?? '',
                                    'qnt': element.qnt ?? 0,
                                    'price': (element.price ?? 0).toDouble(),
                                    'ktNote': element.ktNote ?? '',
                                  });
                                }
                                //? to show invoice
                                invoiceAlertForOrderViewPage(
                                  singleOrder: ctrl.settledBillingItems[index],
                                  billingItems: billingItems,
                                  context: context,
                                );
                              },
                              settledId: ctrl.settledBillingItems[index].settled_id ?? -1,
                              orderStatus: ctrl.settledBillingItems[index].fdOrderStatus ?? 'error',
                              orderType: ctrl.settledBillingItems[index].fdOrderType ?? 'error',
                              dateTime: ctrl.settledBillingItems[index].settledTime ?? DateTime.now(),
                              totalItem: ctrl.settledBillingItems[index].fdOrder?.length ?? 0,
                              kotId: ctrl.settledBillingItems[index].fdOrderKot ?? -1,
                              payType: ctrl.settledBillingItems[index].paymentType ?? CASH,
                            );
                          }

                          if (ctrl.tappedTabName == 'HOLD') {
                            return OrderHoldCard(
                              //? checking if bill array is empty
                              name: ctrl.holdBillingItems[index].holdItem!.isEmpty
                                  ? 'error'
                                  : ctrl.holdBillingItems[index].holdItem?[0]['name'] ?? 'error',
                              price: (ctrl.holdBillingItems[index].totel ?? 0).toString(),
                              onTap: () {
                                MyDialogBody.myConfirmDialogBody(
                                    title: 'update this order ?',
                                    context: context,
                                    desc: ' Do yoy want to update this order ? ',
                                    btnCancelText: 'Delete',
                                    btnOkText: 'Update',
                                    onTapOK: () {
                                      Get.back();
                                      //? delayed for just animation
                                      Future.delayed(const Duration(seconds: 1), () {
                                        ctrl.unHoldHoldItem(
                                            holdBillingItems: ctrl.holdBillingItems[index].holdItem ?? [],
                                            holdItemIndex: index,
                                            orderType: ctrl.holdBillingItems[index].orderType ?? TAKEAWAY);
                                      });
                                    },
                                    onTapCancel: () async {
                                      //? delete the hold item from list
                                      await Get.find<HiveHoldBillController>().deleteHoldBill(index: index);
                                      Navigator.pop(context);
                                      //? to refresh after delete
                                      ctrl.getAllHoldOrder();
                                    });
                              },
                              orderId: index + 1,
                              orderType: ctrl.holdBillingItems[index].orderType ?? TAKEAWAY,
                              dateTime:
                              '${ctrl.holdBillingItems[index].date ?? 'date'} ${ctrl.holdBillingItems[index].time ?? 'time'}',
                              totalItem: ctrl.holdBillingItems[index].holdItem?.length ?? 0,
                            );
                          }
                        },
                        childCount: ctrl.tappedTabName == 'KOT'
                            ? ctrl.kotBillingItems.length
                            : ctrl.tappedTabName == 'SETTLED'
                            ? ctrl.settledBillingItems.length
                            : ctrl.tappedTabName == 'HOLD'
                            ? ctrl.holdBillingItems.length
                            : 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      );
    });
  }
}
