import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/strings/my_strings.dart';
import '../../routes/route_helper.dart';
import '../../screens/login_screen/controller/startup_controller.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/text_field_widget.dart';

class PasswordPromptAlertBody extends StatelessWidget {
  final String reason;
  const PasswordPromptAlertBody({Key? key, required this.reason}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StartupController>(builder: (ctrl) {
      bool horizontal = 1.sh < 1.sw ? true : false;
      return SizedBox(
        width: horizontal ?  0.3.sw : 0.6.sw ,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldWidget(
              hintText: 'Enter password ....',
              textEditingController: ctrl.passTd,
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
                          if(FocusScope.of(context).isFirstFocus) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                       bool result = await ctrl.checkPassword();
                       if(result){
                         if(reason == EXIT_TO_CASHIER){
                           //? resting app mode to cashier
                           ctrl.resetAppModeNumberInHive();
                           Get.offAllNamed(RouteHelper.getHome());
                         }
                         else if(reason == ENTER_TO_REPORT){
                           Navigator.pop(context);
                           Get.toNamed(RouteHelper.getReportScreen());
                         }

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
