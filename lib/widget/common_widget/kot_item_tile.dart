import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class KotItemTile extends StatelessWidget {
  final int index;
  final int slNumber;
  final String itemName;
  final int qnt;
  final double price;
  final String kitchenNote;
  //? in final invoice no need kitchen note
  final bool hideKotNote;
  //? only needed in invoice
  final bool showPrice;


  const KotItemTile(
      {Key? key,
      required this.slNumber,
      required this.itemName,
      required this.qnt,
      required this.kitchenNote,
        this.index = 0,
         this.hideKotNote = false,  this.showPrice = false,  this.price = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white),
      margin: EdgeInsets.only(bottom: 1.sp),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              slNumber.toString(),
              maxLines: 1,
              style: TextStyle(fontSize: 13.sp),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: showPrice ? 150.w : 200.w,
                  child: Text(
                    itemName,
                    maxLines: 1,
                    //softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
                Visibility(
                  visible: !hideKotNote ,
                  child: Text(
                    kitchenNote,
                    maxLines: 1,
                    style: TextStyle(fontSize: 8.sp, color: Colors.black),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: showPrice ? true : false,
              child: SizedBox(
                width: 50.w,
                child: Text(
                  price.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
                  maxLines: 1,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ),
            SizedBox(
              child: Text(
                qnt.toString(),
                maxLines: 1,
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
