import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../screens/login_screen/controller/startup_controller.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/text_field_widget.dart';

class ChangePasswordPromptAlertBody extends StatelessWidget {
  const ChangePasswordPromptAlertBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StartupController>(builder: (ctrl) {
      bool horizontal = 1.sh < 1.sw ? true : false;
      return SizedBox(
        width:horizontal ? 0.3.sw : 1.sw * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldWidget(
              hintText: 'Current password ....',
              textEditingController: ctrl.passTd,
              borderRadius: 15.r,
              onChange: (_) {},
            ),
            10.verticalSpace,
            TextFieldWidget(
              hintText: 'New password ....',
              textEditingController: ctrl.newPassTd,
              borderRadius: 15.r,
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
                        btnCtrlName: 'passwordPrompt',
                        text: 'Submit',
                        ctrl: ctrl,
                        color: Colors.green,
                        onTap: () async {
                          ctrl.changePassword(
                            context: context,
                              subcId: ctrl.subcId,
                              fdShopId: ctrl.SHOPE_ID,
                              password: ctrl.passTd.text,
                              newPassword: ctrl.newPassTd.text);
                          if(FocusScope.of(context).isFirstFocus) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
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
