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
    {'text': "QUICK PAY", 'circleColor': Colors.yellowAccent},
    {'text': "ALL ORDER", 'circleColor': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderViewController>(builder: (ctrl) {
        return ctrl.isLoading
            ? const MyLoading()
            : RefreshIndicator(
                onRefresh: () async {
                  ctrl.getAllSettledOrder();
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
                            Get.back();
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
                                child: Icon(
                                  FontAwesomeIcons.bell,
                                  size: 24.sp,
                                )),
                          ),
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(110.h),
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
                                    const DatePickerForOrderView(),
                                    const QrScannerIconBtn(),
                                  ],
                                ),
                                SizedBox(
                                  //? type of order like KOT , SETTLED ,HOLD
                                  height: 55.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categoryCard.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return OrderCategory(
                                        onTap: () async {
                                          //? for color change
                                          ctrl.setStatusTappedIndex(index);
                                          // ?for show different orders
                                          ctrl.updateTappedTabName(categoryCard[index]['text'] ?? 'KOT');
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
                                        color: ctrl.tappedIndex == index ? AppColors.mainColor_2 : Colors.white,
                                        circleColor: categoryCard[index]['circleColor'],
                                        text: categoryCard[index]['text'] ?? 'KOT',
                                      );
                                    },
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
                                  name: ctrl.kotBillingItems[index].fdOrder!.isEmpty ? "error" : ctrl.kotBillingItems[index].fdOrder?[0].name ?? "",
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
                                  dateTime: '26-04-20222 : 10:30',
                                  totalItem: ctrl.kotBillingItems[index].fdOrder?.length ?? 0,
                                );
                              }
                              if (ctrl.tappedTabName == 'SETTLED') {
                                return OrderSettledCard(
                                  //? to show first item name in the settled order
                                  name: ((ctrl.settledBillingItems[index].fdOrder) ?? []).isEmpty ? "no item" : (ctrl.settledBillingItems[index].fdOrder?[0].name ?? ""),
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
                                          ctrl.getAllSettledOrder();
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
                                  dateTime: '26-04-20222 : 10:30',
                                  totalItem: ctrl.settledBillingItems[index].fdOrder?.length ?? 0,
                                  kotId: ctrl.settledBillingItems[index].fdOrderKot ?? -1,
                                  payType: ctrl.settledBillingItems[index].paymentType ?? CASH,
                                );
                              }

                              if (ctrl.tappedTabName == 'HOLD') {
                                return OrderHoldCard(
                                  //? checking if bill array is empty
                                  name: ctrl.holdBillingItems[index].holdItem!.isEmpty ? 'error' : ctrl.holdBillingItems[index].holdItem?[0]['name'] ?? 'error',
                                  price: (ctrl.holdBillingItems[index].totel ?? 0).toString(),
                                  onTap: () {
                                    MyDialogBody.myConfirmDialogBody(
                                        title: 'update this order ?',
                                        context: context,
                                        desc: ' Do yoy want to update this order ? ',
                                        btnCancelText: 'Delete',
                                        btnOkText: 'Update',
                                        onTapOK: () {
                                          ctrl.unHoldHoldItem(
                                              holdBillingItems: ctrl.holdBillingItems[index].holdItem ?? [],
                                              holdItemIndex: index,
                                              orderType: ctrl.holdBillingItems[index].orderType ?? TAKEAWAY);
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
                                  dateTime: '${ctrl.holdBillingItems[index].date ?? 'date'} ${ctrl.holdBillingItems[index].time ?? 'time'}',
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
              );
      }),
    );
  }
}
