import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/widget/common_widget/horizontal_divider.dart';

import '../../constants/app_colors/app_colors.dart';
import '../../constants/strings/my_strings.dart';
import '../../printer/controller/print_controller.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/common_text/big_text.dart';
import '../../widget/common_widget/text_field_widget.dart';
import 'invoice_alert_for_billing_page.dart';
import 'payment_drop_down_for_billing.dart';


//? this is the popup open when click settled btn click to enter cash details in billing screen
class OrderSettleScreenInBilling extends StatelessWidget {
  final ctrl;

  const OrderSettleScreenInBilling({Key? key, required this.ctrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        width: 0.8.sw,
        padding: EdgeInsets.all(10.sp),
        child: SizedBox(
          width: 0.8.sw,
          child: (Column(
            children: [
              const HorizontalDivider(),
              10.verticalSpace,
              //net total
              Row(
                children: [
                  FittedBox(
                    child: BigText(
                      text: 'Total : ',
                      size: 20.sp,
                      color: AppColors.titleColor,
                    ),
                  ),
                  Flexible(
                      child: TextFieldWidget(
                    textEditingController: ctrl.settleNetTotalCtrl.value,
                    hintText: 'Amount',
                    isDens: true,
                    hintSize: 16,
                    isNumberOnly:true,
                    borderRadius: 10.r,
                    onChange: (value) {
                      ctrl.calculateNetTotal();
                    },
                  ))
                ],
              ),
              10.verticalSpace,

              //discount
              Row(
                children: [
                  FittedBox(
                    child: BigText(
                      text: 'Discount : ',
                      size: 20.sp,
                      color: AppColors.titleColor,
                    ),
                  ),
                  Flexible(
                      child: TextFieldWidget(
                    textEditingController: ctrl.settleDiscountPercentageCtrl.value,
                    hintText: 'in %',
                    isDens: true,
                    hintSize: 16,
                    isNumberOnly:true,
                    borderRadius: 10.r,
                    onChange: (value) {
                      ctrl.calculateNetTotal();
                    },
                  )),
                  Flexible(
                      child: TextFieldWidget(
                    textEditingController: ctrl.settleDiscountCashCtrl.value,
                    hintText: 'in Cash',
                    isDens: true,
                    hintSize: 16,
                    borderRadius: 10.r,
                    isNumberOnly:true,
                    onChange: (_) {
                      ctrl.calculateNetTotal();
                    },
                  ))
                ],
              ),
              10.verticalSpace,
              Row(
                children: [
                  FittedBox(
                    child: BigText(
                      text: 'Charges : ',
                      size: 20.sp,
                      color: AppColors.titleColor,
                    ),
                  ),
                  Flexible(
                      child: TextFieldWidget(
                    textEditingController: ctrl.settleChargesCtrl.value,
                    hintText: 'Amount',
                    hintSize: 16,
                    isDens: true,
                    isNumberOnly:true,
                    borderRadius: 10.r,
                    onChange: (_) {
                      ctrl.calculateNetTotal();
                    },
                  ))
                ],
              ),
              10.verticalSpace,
              //grand total
              Row(
                children: [
                  FittedBox(
                    child: BigText(
                      text: 'Final Amount : ',
                      size: 20.sp,
                      color: AppColors.titleColor,
                    ),
                  ),
                  Flexible(
                      child: TextFieldWidget(
                    textEditingController: ctrl.settleGrandTotalCtrl.value,
                    hintText: 'Final Amount',
                    isDens: true,
                    hintSize: 16,
                        isNumberOnly:true,
                    borderRadius: 10.r,
                    onChange: (_) {},
                  ))
                ],
              ),
              10.verticalSpace,
              //payment type
              Row(
                children: [
                  FittedBox(
                    child: BigText(
                      text: 'Payment : ',
                      size: 20.sp,
                      color: AppColors.titleColor,
                    ),
                  ),
                   const Flexible(child: PaymentDropDownForBilling())
                ],
              ),
              10.verticalSpace,
              //cash received
              Row(
                children: [
                  FittedBox(
                    child: BigText(
                      text: 'Cash Received : ',
                      size: 20.sp,
                      color: AppColors.titleColor,
                    ),
                  ),
                  Flexible(
                      child: TextFieldWidget(
                    textEditingController: ctrl.settleCashReceivedCtrl.value,
                    hintText: 'Amount Received',
                    isDens: true,
                    hintSize: 16,
                    isNumberOnly:true,
                    borderRadius: 10.r,
                    onChange: (value) {
                      ctrl.calculateNetTotal();
                    },
                  ))
                ],
              ),
              10.verticalSpace,
              //change cash text
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FittedBox(
                    child: BigText(
                      text: 'Change : ',
                      size: 20.sp,
                      color: AppColors.titleColor,
                    ),
                  ),
                  10.horizontalSpace,
                  FittedBox(
                    child: BigText(
                      text: ctrl.balanceChange.value.toString(),
                      size: 20.sp,
                      color: AppColors.mainColor,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              //buttons
              SizedBox(
                height: 40.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: ctrl.isClickedSettle.value
                            ? AppMiniButton(text: 'Settled', color: Colors.grey, onTap: () {}) //? disable if already click
                            : ProgressButton(
                                btnCtrlName: 'settle',
                                ctrl: ctrl,
                                color: Colors.blue,
                                text: 'settle',
                                onTap: () async {
                                  if(FocusScope.of(context).isFirstFocus) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  }
                                  await ctrl.insertSettledBill(context);
                                },
                              )),
                    3.horizontalSpace,
                    Flexible(
                      child: AppMiniButton(
                        color: const Color(0xff4caf50),
                        text: 'Print',
                        onTap: () {
                          if(FocusScope.of(context).isFirstFocus) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                          //? delay for close keyboard if its open
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Navigator.pop(context);
                            //? bill page to print invoice
                            invoiceAlertForBillingViewPage(
                              from: BILLING_SCREEN,
                              context: context,
                              grandTotal:ctrl.grandTotalNew ?? 0,
                              discountPercent: ctrl.discountPresent ?? 0,
                              discountCash: ctrl.discountCash ?? 0,
                              charges: ctrl.charges ?? 0,
                              billingItems: ctrl.billingItems ?? [],
                              change: ctrl.balanceChange.value ?? 0,
                              netAmount:ctrl.netTotal ?? 0,
                              cashReceived:ctrl.cashReceived ?? 0,
                              orderType: ctrl.orderType.toString(),
                              deliveryAddress: ctrl.fdDelAddress,
                              selectedOnlineApp: ctrl.selectedOnlineApp,
                            );
                          });

                        },
                      ),
                    ),
                    3.horizontalSpace,
                    Flexible(
                      child: ctrl.isClickedSettle.value
                          ? AppMiniButton(text: 'Settle & print', color: Colors.grey, onTap: () {}) //? disable if already click
                          : ProgressButton(
                        btnCtrlName: 'settle_print',
                        ctrl: ctrl,
                        textSize: 13.sp,
                        color: AppColors.mainColor,
                        text: 'settle & print',
                        onTap: () async {
                          if(FocusScope.of(context).isFirstFocus) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        //? result is true if successfully settled
                        bool result =  await ctrl.insertSettledBill(context,settleOnly:false);
                        if(result){
                          Get.find<PrintCTRL>().printInVoice(
                            billingItems: ctrl.billingItems ?? [],
                            orderType: ctrl.orderType.toString(),
                            selectedOnlineApp: ctrl.selectedOnlineApp,
                            deliveryAddress: ctrl.fdDelAddress,
                            grandTotal: ctrl.grandTotalNew ?? 0,
                            change: ctrl.balanceChange.value ?? 0,
                            cashReceived: ctrl.cashReceived ?? 0,
                            netAmount: ctrl.netTotal ?? 0,
                            discountCash: ctrl.discountCash ?? 0,
                            discountPercent: ctrl.discountPresent ?? 0,
                            charges: ctrl.charges ?? 0,
                          );
                        }
                        },
                      ),
                    ),
                    3.horizontalSpace,
                  ],
                ),
              ),
            ],
          )),
        ),
      );
    });
  }
}
