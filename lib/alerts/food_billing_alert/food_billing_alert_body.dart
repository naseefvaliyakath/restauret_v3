import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/text_field_widget.dart';




class FoodBillingAlertBody extends StatelessWidget {
  final String name;
  final Function qntDecrement;
  final Function qntIncrement;
  final Function priceDecrement;
  final Function priceIncrement;
  final int count;
  final double price;
  final TextEditingController ktTextCtrl;
  final Function addFoodToBill;

  const FoodBillingAlertBody(
      {Key? key,
      required this.name,
      required this.qntDecrement,
      required this.qntIncrement,
      required this.priceDecrement,
      required this.priceIncrement,
      required this.count,
      required this.price,
      required this.ktTextCtrl,
      required this.addFoodToBill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 20.sp, color: AppColors.titleColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          //price and qnt btn
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Wrap(direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  BigText(
                    text: 'QUANTITY',
                    size: 15.sp,
                  ),
                  SizedBox(
                    width: 120.w,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            10.horizontalSpace,
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                size: 24.sp,
                              ),
                              onPressed: () {
                                qntDecrement;
                              },
                              iconSize: 24.w,
                              color: Colors.black54,
                            ),
                            5.horizontalSpace,
                            BigText(
                              text: count.toString(),
                              size: 15.w,
                              color: AppColors.titleColor,
                            ),
                            5.horizontalSpace,
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                size: 24.sp,
                              ),
                              onPressed: () {
                                qntIncrement();
                              },
                              iconSize: 24.w,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
                Wrap(direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  BigText(
                    text: 'PRICE',
                    size: 15.sp,
                  ),
                  SizedBox(
                    width: 120.w,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            10.horizontalSpace,
                            IconButton(
                              icon: Icon(
                                size: 24.sp,
                                Icons.remove_circle,
                              ),
                              onPressed: () {
                                priceDecrement();
                              },
                              iconSize: 24.w,
                              color: Colors.black54,
                            ),
                            5.horizontalSpace,
                            BigText(
                              text: price.toString(),
                              size: 15.w,
                              color: AppColors.titleColor,
                            ),
                            5.horizontalSpace,
                            IconButton(
                              icon: Icon(
                                size: 24.sp,
                                Icons.add_circle,
                              ),
                              onPressed: () {
                                priceIncrement();
                              },
                              iconSize: 24.w,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          10.verticalSpace,
          //kitchen text
          TextFieldWidget(
            borderRadius: 10.r,
            hintText: 'Add Kitchen Text',
            textEditingController: ktTextCtrl,
            maxLIne: 2,
            onChange: (_) {},
          ),
          10.verticalSpace,
          AppMiniButton(
              text: 'Add Item',
              color: AppColors.mainColor,
              onTap: () {
                addFoodToBill();
              }),
          5.verticalSpace,
        ],
      ),
    );
  }
}
