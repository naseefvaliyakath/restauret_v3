import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';


class OrderHoldCard extends StatelessWidget {
  final String name;
  final String price;
  final int orderId;
  final int totalItem;
  final String dateTime;
  final String orderType;


  final Function onTap;

  const OrderHoldCard(
      {Key? key,
        required this.name,
        required this.price,
        required this.onTap,
        required this.orderId,
        required this.totalItem,
        required this.dateTime,
        required this.orderType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
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
            border: Border.all(color: Colors.blue, width: 3.sp)),
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
                          'HOLD',
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
                          orderType == '' ? 'error' : orderType,
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
                          'HOLD NO : $orderId',
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
                            '5 Min',
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
                        dateTime == '' ? 'error' : dateTime,
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
                          'Rs : $price',
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
