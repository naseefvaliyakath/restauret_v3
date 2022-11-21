import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/alerts/password_prompt_alert/password_prompt_to_cashier_alert.dart';
import 'package:rest_verision_3/screens/kitchen_mode_screen/kitchen_mode_main/controller/kitchen_mode_main_controller.dart';
import 'package:rest_verision_3/widget/common_widget/snack_bar.dart';
import '../../routes/route_helper.dart';


class KitchenModeDropDown extends StatelessWidget {
  const KitchenModeDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KitchenModeMainController>(builder: (ctrl) {
      return Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            focusColor: Colors.transparent,
            customButton: Icon(
              Icons.list,
              size: 35.sp,
              color: Colors.black,
            ),
            items: [
              ...MenuItems.firstItems.map(
                    (item) =>
                    DropdownMenuItem<MenuItem>(
                      value: item,
                      child: MenuItems.buildItem(item),
                    ),
              ),

            ],
            onChanged: (value) async {
              MenuItems.onChanged(context, value as MenuItem);
              if(value.text == 'Log Out'){
                ctrl.logOutFromApp();
              }
              else if(value.text == 'Exit'){
                passwordPromptToCashierMode(context: context);
              }
              else if(value.text == 'Ring'){
                    await ctrl.setNewKotRingSound(!ctrl.kotRingSound);
                    //? to update data
                    await ctrl.readNewKotRingSound();
                    AppSnackBar.myFlutterToast(message: ctrl.kotRingSound ?'Sound mode active' : 'Silent mode active', bgColor: Colors.black54);
              }
              else if(value.text == 'Alert'){
                await ctrl.setRingRememberAlert(!ctrl.ringRememberAlertSound);
                //? to update data
                await ctrl.readRingRememberAlert();
                AppSnackBar.myFlutterToast(message: ctrl.ringRememberAlertSound ? 'Sound mode active' : 'Silent mode active', bgColor: Colors.black54);
              }
            },
            itemHeight: 48.sp,
            itemPadding: EdgeInsets.only(left: 16.sp, right: 16.sp),
            dropdownWidth: 160.sp,
            dropdownPadding: EdgeInsets.symmetric(vertical: 6.sp),
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.white,
            ),
            dropdownElevation: 8,
            offset: const Offset(0, 8),
          ),
        ),
      );
    });
  }


}


class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home, ring, soundOnOff,exit,logout];


  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const ring = MenuItem(text: 'Ring', icon: Icons.ring_volume);
  static const soundOnOff = MenuItem(text: 'Alert', icon: Icons.add_alert_sharp);
  static const exit = MenuItem(text: 'Exit', icon: Icons.exit_to_app_rounded);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.power_settings_new);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
            item.icon,
            color: Colors.black,
            size: 22.sp
        ),
        SizedBox(
            width: 10.sp
        ),
        Text(
          item.text,
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp
          ),
        ),
      ],
    );
  }

  //? we not using this
  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {

    }
  }
}
