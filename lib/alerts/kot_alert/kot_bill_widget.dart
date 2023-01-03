import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rest_verision_3/models/kitchen_order_response/kitchen_order.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../../constants/strings/my_strings.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/common_text/mid_text.dart';
import '../../widget/common_widget/common_text/small_text.dart';
import '../../widget/common_widget/horizontal_divider.dart';
import '../../widget/common_widget/kot_bill_item_heding.dart';
import '../../widget/common_widget/kot_item_tile.dart';

class KotBillWidget extends StatelessWidget {
  final String type;
  final int kotId;
  final List<dynamic> billingItems;

  //? for show the table from order view page
  final String tableName;

  //? this for order from order view page
  final KitchenOrder fullKot;

  const KotBillWidget(
      {Key? key,
      required this.type,
      required this.billingItems,
      required this.kotId,
      this.tableName = '',
      required this.fullKot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    //? registering controller if kot is from billing screen
    if (type != 'ORDER_VIEW') {
      if (Get.isRegistered<BillingScreenController>()) {
        Get.lazyPut<BillingScreenController>(() => BillingScreenController());
      }
    }
    return TicketWidget(
      width: horizontal ? 0.5.sw :  0.8 * 1.sw,
      height: 0.68 * 1.sh,
      isCornerRounded: true,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BigText(text: 'KOT', color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallText(
                text: 'KOT ID : $kotId',
                color: Colors.black54,
                size: 15.sp,
              ),
              SmallText(
                text: 'DATE : ${DateFormat('dd-MM-yyyy  hh:mm aa').format((fullKot.kotTime) ?? DateTime.now())}',
                color: Colors.black54,
                size: 10.sp,
              ),
            ],
          ),
          3.verticalSpace,
          HorizontalDivider(color: Colors.black, height: 1.sp),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MidText(
                  //? to show order type and in online billing screen show like 'online (Thalabath)' and -
                  //?  its for kot from billing screen
                  text: type != 'ORDER_VIEW'
                      ? 'TYPE : $type  ${type == ONLINE ? '(${Get.find<BillingScreenController>().selectedOnlineApp})' : ''}'
                      //? to show order type and in online  show like 'online (Thalabath)' and -
                      //?  its from order view page need to take details from kotOrder model
                      : 'TYPE : ${fullKot.fdOrderType}  ${fullKot.fdOrderType == ONLINE ? '(${fullKot.fdOnlineApp})' : ''}',
                  size: 13.sp,
                  color: Colors.black,
                ),
                MidText(
                  text: type == DINING
                      ? Get.find<BillingScreenController>().selectedTableChairSet[1] == -1 ? 'TABLE : NOT SELECTED':
                      'TABLE : T-${Get.find<BillingScreenController>().selectedTableChairSet[1]} C-${Get.find<BillingScreenController>().selectedTableChairSet[2]}  (${(Get.find<BillingScreenController>().selectedTableChairSet[0]).toString().toUpperCase()})'
                      : type == 'ORDER_VIEW'
                          ? 'TABLE :T-${fullKot.kotTableChairSet?[1] ?? 1} C-${fullKot.kotTableChairSet?[2] ?? 1}  (${(fullKot.kotTableChairSet?[0] ?? MAIN_ROOM).toString().toUpperCase()})' : 'TABLE : ',
                  size: 13.sp,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          3.verticalSpace,
          HorizontalDivider(color: Colors.black, height: 1.sp),
          const KotBillItemHeading(),
          HorizontalDivider(color: Colors.black, height: 1.sp),
          5.verticalSpace,
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return KotItemTile(
                  index: index,
                  slNumber: index + 1,
                  itemName: billingItems[index]['name'] ?? '',
                  qnt: billingItems[index]['qnt'] ?? 0,
                  kitchenNote: billingItems[index]['ktNote'] ?? '',
                );
              },
              itemCount: billingItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
