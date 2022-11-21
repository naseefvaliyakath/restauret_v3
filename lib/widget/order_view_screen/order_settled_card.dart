import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors/app_colors.dart';


class OrderSettledCard extends StatelessWidget {
  final String name;
  final String price;
  final String orderStatus;
  final String payType;
  final int settledId;
  final int kotId;
  final int totalItem;
  final DateTime dateTime;
  final String orderType;

  final Function onTap;
  final Function onLongTap;

  const OrderSettledCard(
      {Key? key,
      required this.name,
      required this.price,
      required this.onTap, required this.onLongTap,
      required this.orderStatus,
      required this.settledId,
      required this.totalItem,
      required this.dateTime,
      required this.orderType,
      required this.payType,
      required this.kotId, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      onLongPress: (){
        onLongTap();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(4, 6),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.3),
              )
            ],
            border: Border.all(color: Colors.green, width: 3.sp)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        child: Text(
                          orderType == '' ? 'error' : orderType,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 21.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      5.verticalSpace,
                      FittedBox(
                        child: Text(
                          orderStatus == '' ? 'error' : orderStatus,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      5.verticalSpace,
                      FittedBox(
                        child: Text(
                          'ID : $settledId',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.mainColor_2,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          kotId == -1 ? 'NO KOT' : 'KOT : $kotId',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.mainColor_2,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 10.sp,
                          ),
                          Text(
                            'payment : $payType',
                            style: TextStyle(fontSize: 10.sp),
                          )
                        ],
                      )
                    ],
                  ),
                  5.verticalSpace,
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    FittedBox(
                      child: Text(
                        name == '' ? 'error' : name,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    5.verticalSpace,
                    FittedBox(
                      child: Text(
                        'Total Items : $totalItem',
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    5.verticalSpace,
                    FittedBox(
                      child: Text(
                        DateFormat('dd-MM-yyyy  hh:mm aa').format(dateTime),
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    5.verticalSpace,
                    FittedBox(
                      child: Text(
                          'Total : $price',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
