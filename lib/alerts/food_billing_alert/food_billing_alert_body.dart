import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/text_field_widget.dart';
import 'multiple_price_radio_grp.dart';


class FoodBillingAlertBody extends StatelessWidget {

  //? index of kot item in myKotList
  final int index;
  final String fdIsLoos;
  final String name;
  final Function qntDecrement;
  final Function qntIncrement;
  final Function priceDecrement;
  final Function priceIncrement;
  final int count;
  final double price;
  final TextEditingController ktTextCtrl;
  final Function addFoodToBill;

  const FoodBillingAlertBody({Key? key,
    required this.fdIsLoos,
    required this.qntDecrement,
    required this.qntIncrement,
    required this.priceDecrement,
    required this.priceIncrement,
    required this.count,
    required this.price,
    required this.ktTextCtrl,
    required this.addFoodToBill,
    required this.index,
    required this.name,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return GetBuilder<BillingScreenController>(builder: (ctrl) {
      return Center(
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                //? if multi price food then need to add quarter , half .. etc with food name
                fdIsLoos == 'no' ? name : ctrl.multiSelectedFoodName,
                style: TextStyle(fontSize: 20.sp, color: AppColors.titleColor, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              //? price and qnt btn
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: horizontal ? 50.w : 120.w,
                      child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            BigText(
                              text: 'QUANTITY',
                              size: 15.sp,
                            ),
                            SizedBox(
                              width:horizontal ? 50.w : 120.w,
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
                                          size: horizontal ? 55.sp : 24.sp,
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
                                          size:horizontal ? 55.sp : 24.sp,
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
                    SizedBox(
                      width: horizontal ? 50.w :120.w,
                      child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            BigText(
                              text: 'PRICE',
                              size: 15.sp,
                            ),
                            SizedBox(
                              width:horizontal ? 50.w : 120.w,
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
                                          size:horizontal ? 55.sp : 24.sp,
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
                                          size:horizontal ? 55.sp : 24.sp,
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
              ),
              10.verticalSpace,
              //multiple price toggle
              Visibility(
                  visible: fdIsLoos == 'yes' ? true : false,
                  child: MultiplePriceRadioGroup(index: index)),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                margin: EdgeInsets.symmetric(vertical: 5.sp),
                height: 35.sp,
                child: AppMiniButton(
                    text: 'Add Item',
                    color: AppColors.mainColor,
                    onTap: () {
                      addFoodToBill();
                    }),
              ),
              5.verticalSpace,
            ],
          ),
        ),
      );
    });
  }
}
