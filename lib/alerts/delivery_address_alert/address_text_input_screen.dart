import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_verision_3/screens/billing_screen/controller/billing_screen_controller.dart';

import '../../widget/common_widget/text_field_widget.dart';

class AddressTextInputScreen extends StatelessWidget {
  final BillingScreenController ctrl;

  const AddressTextInputScreen({Key? key, required this.ctrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal = 1.sh < 1.sw ? true : false;
    return Container(
      width:horizontal ? 0.3.sw : 0.75.sw,
      color: Colors.white,
      padding: EdgeInsets.all(10.sp),
      child: SizedBox(
        width: 0.8.sw,
        child: (Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //phone number
            Flexible(
                child: TextFieldWidget(
              textEditingController: ctrl.deliveryAddrNumberCtrl,
              hintText: 'Phone Number',
              isDens: true,
              hintSize: 16,
              borderRadius: 10.r,
              isNumberOnly: true,
              keyBordType: TextInputType.number,
              txtLength: 12,
              onChange: (number) {
                ctrl.getDeliveryAddressItemForRefillItem(number);
              },
            )),
            10.verticalSpace,

            //cus name
            Flexible(
                child: TextFieldWidget(
              textEditingController: ctrl.deliveryAddrNameCtrl,
              hintText: 'Customer Name',
              isDens: true,
              hintSize: 16,
              borderRadius: 10.r,
              onChange: (_) {},
            )),
            10.verticalSpace,
            //cus address
            Flexible(
                child: TextFieldWidget(
              textEditingController: ctrl.deliveryAddrAddressCtrl,
              hintText: 'Enter Address',
              isDens: true,
              maxLIne: 3,
              hintSize: 16,
              borderRadius: 10.r,
              onChange: (_) {},
            )),

            10.verticalSpace,
          ],
        )),
      ),
    );
  }
}
