import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import 'package:rest_verision_3/screens/order_view_screen/controller/order_view_controller.dart';

import '../../constants/strings/my_strings.dart';

class PaymentDropDownForUpdateSettledOrder extends StatelessWidget {
  const PaymentDropDownForUpdateSettledOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selected;
    return GetBuilder<OrderViewController>(builder: (ctrl) {

      return Center(
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    focusColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                    isDense: true,
                    hint: Text(
                      ctrl.selectedPaymentForUpdateSettledOrder.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey,
                      ),
                    ),
                    value: selected,
                    onChanged: (String? newValue) {
                      if (kDebugMode) {
                        print(newValue);
                      }
                      ctrl.selectedPaymentForUpdateSettledOrder = newValue ?? CASH;
                      ctrl.updateSelectedPaymentForUpdateSettledOrder(newValue ?? CASH);
                    },
                    items: ctrl.myPaymentMethods.map((e) {
                      return DropdownMenuItem<String>(
                        value: e ?? CASH,
                        // value: _mySelection,
                        child: SizedBox(
                          width: 0.3 * 1.sw,
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: const Icon(Icons.fastfood_rounded),
                              ),
                              10.horizontalSpace,
                              Flexible(

                                child: Text((e ?? CASH).toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 12.sp
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}