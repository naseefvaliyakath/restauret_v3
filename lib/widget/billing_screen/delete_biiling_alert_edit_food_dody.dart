import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors/app_colors.dart';
import '../common_widget/common_text/big_text.dart';
import '../common_widget/text_field_widget.dart';


class DeleteBillingAlertEditBillBody extends StatelessWidget {
  final Function qntDecrement;
  final Function qntIncrement;
  final Function priceDecrement;
  final Function priceIncrement;
  final int count;
  final double price;
  final TextEditingController ktTextCtrl;

  const DeleteBillingAlertEditBillBody(
      {Key? key,
      required this.qntDecrement,
      required this.qntIncrement,
      required this.priceDecrement,
      required this.priceIncrement,
      required this.count,
      required this.price,
      required this.ktTextCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // price and qnt btn
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Wrap(direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center, children: [
                BigText(
                  text: 'QUANTITY',
                  size: 15.sp,
                ),
                SizedBox(
                  width: 120.w,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          10.horizontalSpace,
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                            ),
                            onPressed: () {
                              qntDecrement();
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
                            icon: const Icon(
                              Icons.add_circle,
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
            ),
            Flexible(
              child: Wrap(direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center, children: [
                BigText(
                  text: 'PRICE',
                  size: 15.sp,
                ),
                SizedBox(
                  width: 120.w,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          10.horizontalSpace,
                          IconButton(
                            icon: const Icon(
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
                            icon: const Icon(
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
            ),
          ],
        ),
        //kitchen text
        TextFieldWidget(
          borderRadius: 10.r,
          hintText: 'Add Kitchen Text',
          textEditingController: ktTextCtrl,
          maxLIne: 2,
          onChange: (_) {},
        ),
      ],
    );
  }
}
