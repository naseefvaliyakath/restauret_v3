import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_colors/app_colors.dart';


class ViewOrderListItemTile extends StatelessWidget {
  final int index;
  final int slNumber;
  final String itemName;
  final int qnt;
  final double price;
  final String kitchenNote;
  final String ordStatus;
  final Function onLongTap;

  const ViewOrderListItemTile(
      {Key? key,
      required this.slNumber,
      required this.itemName,
      required this.qnt,
      required this.price,
      required this.kitchenNote,
      required this.onLongTap,
      this.index = 0,
        required this.ordStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        onLongTap();
      },
      //to close keybord in search fiels
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        decoration: BoxDecoration(
            color: (index % 2 == 0) ? AppColors.textHolder : const Color(0xffd2e3ee),
            border: Border.all(color: AppColors.textGrey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(5.r)),
        height: 40.h,
        width: 1.sw * 0.6,
        padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 2.sp),
        margin: EdgeInsets.only(bottom: 2.sp),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 1.sw * 0.05,
                padding: EdgeInsets.only(left: 5.sp),
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    slNumber.toString(),
                    maxLines: 1,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black,
                thickness: 1.sp,
              ),
              SizedBox(
                width: 1.sw * 0.275,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        itemName,
                        maxLines: 1,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      Text(
                        kitchenNote,
                        maxLines: 1,
                        style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black,
                thickness: 1.sp,
              ),
              SizedBox(
                width: 1.sw * 0.06,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    qnt.toString(),
                    maxLines: 1,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black,
                thickness: 1.sp,
              ),
              SizedBox(
                width: 1.sw * 0.08,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    price.toString(),
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black,
                thickness: 1.sp,
              ),
              SizedBox(
                width: 1.sw * 0.08,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    ordStatus,
                    style: TextStyle(fontSize: 13.sp, color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
