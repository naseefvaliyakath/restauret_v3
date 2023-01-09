import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../screens/purchase_book_screen/controller/purchase_book_controller.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/text_field_widget.dart';

class AddNewPurchaseAlertBody extends StatelessWidget {
  const AddNewPurchaseAlertBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseBookCTRL>(builder: (ctrl) {
      bool horizontal = 1.sh < 1.sw ? true : false;
      return SizedBox(
        width: horizontal ? 0.3.sw : 1.sw * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldWidget(
              hintText: 'Enter Amount ....',
              textEditingController: ctrl.priceTD,
              isNumberOnly: true,
              borderRadius: 15.r,
              onChange: (_) {},
            ),
            10.verticalSpace,
            TextFieldWidget(
              hintText: 'Enter Description ....',
              textEditingController: ctrl.descTD,
              borderRadius: 15.r,
              maxLIne: 3,
              onChange: (_) {},
            ),
            10.verticalSpace,
            SizedBox(
              height: 45.h,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: ProgressButton(
                        btnCtrlName: 'addPurchase',
                        text: 'Submit',
                        ctrl: ctrl,
                        color: Colors.green,
                        onTap: () async {
                          if(FocusScope.of(context).isFirstFocus) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                         await ctrl.insertPurchaseItem();
                         Navigator.pop(context);
                        },
                      ),
                    ),
                    10.horizontalSpace,
                    Flexible(
                      fit: FlexFit.tight,
                      child: AppMiniButton(
                          text: 'Close',
                          color: Colors.redAccent,
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
