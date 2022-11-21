import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/mid_text.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/small_text.dart';

import '../../constants/app_colors/app_colors.dart';

class MultiplePriceRadioGroup extends StatelessWidget {
  final int index;
  const MultiplePriceRadioGroup({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillingScreenController>(builder: (ctrl) {
      return SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GFRadio(
                  size: 20,
                  value: 1,
                  groupValue: ctrl.selectedMultiplePrice,
                  onChanged: (value) {
                    ctrl.updateSelectedMultiplePrice((value as int),index);
                  },
                  inactiveIcon: null,
                  activeBorderColor: GFColors.SUCCESS,
                  radioColor: GFColors.SUCCESS,
                ),
                3.verticalSpace,
                const SmallText(text: 'Full')
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GFRadio(
                  size: 20,
                  value: 2,
                  groupValue: ctrl.selectedMultiplePrice,
                  onChanged: (value) {
                    ctrl.updateSelectedMultiplePrice((value as int),index);
                  },
                  inactiveIcon: null,
                  activeBorderColor: GFColors.SUCCESS,
                  radioColor: GFColors.SUCCESS,
                ),
                3.verticalSpace,
                const SmallText(text: '3 / 4')
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GFRadio(
                  size: 20,
                  value: 3,
                  groupValue: ctrl.selectedMultiplePrice,
                  onChanged: (value) {
                    ctrl.updateSelectedMultiplePrice((value as int),index);
                  },
                  inactiveIcon: null,
                  activeBorderColor: GFColors.SUCCESS,
                  radioColor: GFColors.SUCCESS,
                ),
                3.verticalSpace,
                const SmallText(text: 'Half')
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GFRadio(
                  size: 20,
                  value: 4,
                  groupValue: ctrl.selectedMultiplePrice,
                  onChanged: (value) {
                    ctrl.updateSelectedMultiplePrice((value as int),index);
                  },
                  inactiveIcon: null,
                  activeBorderColor: GFColors.SUCCESS,
                  radioColor: GFColors.SUCCESS,
                ),
                3.verticalSpace,
                const SmallText(text: 'Quarter')
              ],
            ),
          ],
        ),
      );
    });
  }
}
