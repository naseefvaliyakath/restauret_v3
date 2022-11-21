import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/radio/gf_radio.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_radio_type.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../screens/settings_page_screen/controller/settings_controller.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/common_text/mid_text.dart';
import '../../widget/common_widget/text_field_widget.dart';


class ChangeModeOfAppAlertBody extends StatelessWidget {
  const ChangeModeOfAppAlertBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (ctrl) {
      return SizedBox(
        width: 1.sw * 0.8,
        child: MediaQuery.removePadding(
          context: context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GFCard(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: [
                        GFRadio(
                          type: GFRadioType.custom,
                          activeIcon:  Icon(Icons.monetization_on,size: 24.sp),
                          inactiveIcon:  Icon(Icons.monetization_on,size: 24.sp),
                          activeBgColor: AppColors.mainColor_2,
                          size: GFSize.MEDIUM,
                          value: 1,
                          groupValue: ctrl.groupValueForModes,
                          onChanged: (val) {
                            ctrl.updateModesOfApp(1);
                          },
                          radioColor: GFColors.SUCCESS,
                        ),
                        5.verticalSpace,
                        const MidText(
                          text: 'CASHIER',
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GFRadio(
                          type: GFRadioType.custom,
                          activeIcon: Icon(Icons.fastfood,size: 24.sp),
                          inactiveIcon: Icon(Icons.fastfood,size: 24.sp),
                          activeBgColor: AppColors.mainColor_2,
                          size: GFSize.MEDIUM,
                          value: 2,
                          groupValue: ctrl.groupValueForModes,
                          onChanged: (val) {
                            ctrl.updateModesOfApp(2);
                          },
                          radioColor: GFColors.SUCCESS,
                        ),
                        5.verticalSpace,
                        const MidText(
                          text: 'KITCHEN',
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GFRadio(
                          type: GFRadioType.custom,
                          activeIcon: Icon(Icons.man,size: 24.sp),
                          inactiveIcon: Icon(Icons.man,size: 24.sp),
                          activeBgColor: AppColors.mainColor_2,
                          size: GFSize.MEDIUM,
                          value: 3,
                          groupValue: ctrl.groupValueForModes,
                          onChanged: (val) {
                            ctrl.updateModesOfApp(3);
                          },
                          radioColor: GFColors.SUCCESS,
                        ),
                        5.verticalSpace,
                        const MidText(
                          text: 'WAITER',
                        )
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                //? check app mode number is 1 and selected also 1 then no need of pass box
                height: ctrl.appModeNumber != ctrl.groupValueForModes ? 120.sp : 0,
                width: 1.sw * 0.8,
                child: SizedBox(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 50.sp,
                        child: TextFieldWidget(
                          hintText: 'Enter Password ....',
                          //? password checking handled in startup controller
                          textEditingController: Get.find<StartupController>().passTd,
                          borderRadius: 15.r,
                          onChange: (_) {},
                        ),
                      ),
                      15.verticalSpace,
                      SizedBox(
                          height: 40.sp,

                          child: ProgressButton(
                            btnCtrlName: 'passwordPrompt',
                            text: 'Submit',
                            ctrl: Get.find<StartupController>(),
                            color: AppColors.mainColor_2,
                            onTap: () async {
                             bool result = await Get.find<StartupController>().checkPassword();
                             if(result){
                               ctrl.modeChangeSubmit();
                             }
                            },
                          )),
                      10.verticalSpace,
                    ],
                  ),
                ),
              )],
          ),
        ),
      );
    });
  }
}
