import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../../constants/strings/my_strings.dart';
import '../../models/settled_order_response/settled_order.dart';
import '../../screens/login_screen/controller/startup_controller.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/common_text/mid_text.dart';
import '../../widget/common_widget/common_text/small_text.dart';
import '../../widget/common_widget/horizontal_divider.dart';
import '../../widget/common_widget/kot_bill_item_heding.dart';
import '../../widget/common_widget/kot_item_tile.dart';


//? body of invoice alert for settled order not in KOT list
class InvoiceAlertBodyOrderView extends StatelessWidget {
  final SettledOrder singleOrder;
  final List<dynamic> billingItems;

  const InvoiceAlertBodyOrderView({Key? key,  required this.billingItems, required this.singleOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TicketWidget(
      width: 0.8 * 1.sw,
      height: 0.68 * 1.sh,
      isCornerRounded: true,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 50.sp,
              height: 50.sp,
              decoration:  BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(Get.find<StartupController>().logoImg),
                ),
              )),
          BigText(text: 'INVOICE', color: Colors.black,size: 20.sp,),
          HorizontalDivider(color: Colors.black, height: 1.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallText(
                text: 'ORDER ID : ${singleOrder.settled_id ?? -1}',
                color: Colors.black54,
                size: 15.sp,
              ),
              SmallText(
                text: 'DATE : ${DateFormat('dd-MM-yyyy  hh:mm aa').format(singleOrder.settledTime ?? DateTime.now())}',
                color: Colors.black54,
                size: 10.sp,
              ),
            ],
          ),
          3.verticalSpace,
          SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MidText(
                  text: singleOrder.fdOrderType == ONLINE ? 'TYPE : ${singleOrder.fdOrderType ?? TAKEAWAY}  (${singleOrder.fdOnlineApp})' :  'TYPE : ${singleOrder.fdOrderType ?? TAKEAWAY}',
                  size: 13.sp,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          3.verticalSpace,
          HorizontalDivider(color: Colors.black, height: 1.sp),
          const KotBillItemHeading(showPrice: true,),
          HorizontalDivider(color: Colors.black, height: 1.sp),
          3.verticalSpace,
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                return KotItemTile(
                  hideKotNote: true,
                  index: index,
                  slNumber: index + 1,
                  showPrice: true,
                  itemName: billingItems[index]['name'] ?? '',
                  price:  billingItems[index]['price'] ?? 0,
                  qnt: billingItems[index]['qnt'] ?? 0,
                  kitchenNote: billingItems[index]['ktNote'] ?? '',
                );
              },
              itemCount: billingItems.length,
            ),
          ),
          HorizontalDivider(color: Colors.black, height: 1.sp),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Grand Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MidText(text: 'Bill Amount      : ',size: 10.sp,),
                    MidText(text: '${singleOrder.grandTotal ?? 0}',size: 10.sp,),
                  ],
                ),
                //Charges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MidText(text: 'Charges             : ',size: 10.sp,),
                    MidText(text: '${singleOrder.charges ?? 0}',size: 10.sp,),
                  ],
                ),
                //Discount in cash
                Visibility(
                   visible: singleOrder.discountCash == 0 ? false : true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MidText(text: 'Discount           : ',size: 10.sp,),
                      MidText(text: '${singleOrder.discountCash ?? 0}',size: 10.sp,),
                    ],
                  ),
                ),

                //Discount in %
                Visibility(
                  visible: singleOrder.discountPersent == 0 ? false : true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MidText(text: 'Discount in %  : ',size: 10.sp,),
                      MidText(text: '${singleOrder.discountPersent ?? 0}',size: 10.sp,),
                    ],
                  ),
                ),

                HorizontalDivider(color: Colors.black54, height: 1.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MidText(text: 'Final Amount            : ',size: 13.sp,),
                    MidText(text: ' ${singleOrder.netAmount ?? 0}',size: 13.sp,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MidText(text: 'Cash Received  : ',size: 13.sp,),
                    MidText(text: ' ${singleOrder.cashReceived ?? 0}',size: 13.sp,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MidText(text: 'Change               : ',size: 13.sp,),
                    MidText(text: ' ${singleOrder.change ?? 0}',size: 13.sp,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MidText(text: 'Method               : ',size: 13.sp,),
                    MidText(text: ' ${(singleOrder.paymentType ?? CASH).toUpperCase()}',size: 13.sp,),
                  ],
                ),
              ],
            ),
          ),
          //? delivery address
          Visibility(
            //? check if its from home delivery and user entered an address and in general setting user selected show delivery address in invoice
            visible: ((Get.find<StartupController>().setShowDeliveryAddressInBillToggle)  && (singleOrder.fdOrderType == HOME_DELEVERY) && ((singleOrder.fdDelAddress?['name'] ?? '').trim() != '')) ? true : false,
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  3.verticalSpace,
                  HorizontalDivider(color: Colors.black54, height: 1.sp),
                  3.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MidText(
                        text: 'Delivery address',
                        size: 13.sp,
                      ),


                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MidText(
                        text: 'Name                   :  ',
                        size: 13.sp,
                      ),
                      MidText(
                        text:  singleOrder.fdDelAddress?['name'] ?? 'name',
                        size: 13.sp,
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MidText(
                        text: 'Phone number  :  ',
                        size: 13.sp,
                      ),
                      MidText(
                        text: (singleOrder.fdDelAddress?['number'] ?? 0).toString(),
                        size: 13.sp,
                      ),

                    ],
                  ),
                  3.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: MidText(
                          text: 'Address               :  ',
                          size: 13.sp,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          singleOrder.fdDelAddress?['address'] ?? 'address',
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
