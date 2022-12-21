import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rest_verision_3/constants/app_colors/app_colors.dart';
import 'package:rest_verision_3/widget/common_widget/common_text/big_text.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../widget/common_widget/loading_page.dart';
import '../../widget/common_widget/text_field_widget.dart';
import 'controller/startup_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<StartupController>(builder: (ctrl) {
        return SafeArea(
          child: Center(
            child: ctrl.showLogin ? Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 0.8.sw,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BigText(text: 'SUBSCRIPTION ID'),
                      20.verticalSpace,
                      TextFieldWidget(
                        isNumberOnly: true,
                        keyBordType: TextInputType.number,
                        hintText: 'Enter Your Subscription ID ....',
                        textEditingController: ctrl.subIdTD,
                        borderRadius: 15.r,
                        onChange: (_) async {
                        },
                      ),
                      20.verticalSpace,
                  RoundedLoadingButton(
                    successIcon: Icons.check_circle_outline,
                    failedIcon: Icons.error_outline,
                    color: AppColors.mainColor,
                    successColor: Colors.green,
                    completionDuration: const Duration(milliseconds: 0),
                    duration: const Duration(milliseconds: 100),
                    controller: ctrl.btnControllerLogin,
                    onPressed: () async {
                      if(FocusScope.of(context).isFirstFocus) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                      await ctrl.loginToApp();
                    },
                    child: const BigText(text: 'Login',color: Colors.white,),
                  )

                    ],
                  ),
                ),
              ),
            ) : const MyLoading(),
          ),
        );
      }),
    );
  }
}
