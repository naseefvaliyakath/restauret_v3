import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/login_screen/controller/startup_controller.dart';
import 'package:rest_verision_3/screens/settings_page_screen/controller/settings_controller.dart';
import '../../widget/common_widget/buttons/app_min_button.dart';
import '../../widget/common_widget/buttons/progress_button.dart';
import '../../widget/common_widget/text_field_widget.dart';

class AddNewComplaintAlertBody extends StatelessWidget {
  const AddNewComplaintAlertBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (ctrl) {
      ctrl.complaintMobTD.text = Get.find<StartupController>().shopNumber.toString();
      String? selectedValue;
      return SizedBox(
        width: 1.sw * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldWidget(
              hintText: 'Enter details ....',
              textEditingController: ctrl.complaintTextTD,
              borderRadius: 15.r,
              maxLIne: 3,
              onChange: (_) {},
            ),
            10.verticalSpace,
            TextFieldWidget(
              hintText: 'Enter phone ....',
              textEditingController: ctrl.complaintMobTD,
              borderRadius: 15.r,
              isNumberOnly: true,
              onChange: (_) {},
            ),
            10.verticalSpace,
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  alignment: AlignmentDirectional.center,
                  isExpanded: true,
                  hint: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 16.sp,
                        color: Colors.black,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          ctrl.selectedComplaintType.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: ctrl.complaintType
                      .map((item) => DropdownMenuItem<String>(
                    alignment: AlignmentDirectional.centerEnd,
                    value: item,
                    child: GestureDetector(
                      onLongPress: () {
                      },
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Text(
                          item.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    ctrl.updateSelectedComplaintType(value as String);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14.sp,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.grey,
                  buttonHeight: 50.sp,
                  buttonWidth: 160.sp,
                  buttonPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.white,
                  ),
                  buttonElevation: 2,
                  itemHeight: 40.sp,
                  itemPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                  dropdownMaxHeight: 200.sp,
                  dropdownWidth: 200.sp,
                  dropdownPadding: null,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  dropdownElevation: 8,
                  scrollbarRadius: Radius.circular(40.r),
                  scrollbarThickness: 0,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(-20, 0),
                ),
              ),
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
                        btnCtrlName: 'addComplaint',
                        text: 'Submit',
                        ctrl: ctrl,
                        color: Colors.green,
                        onTap: () async {
                          if(FocusScope.of(context).isFirstFocus) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                         await ctrl.insertComplaint();
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
