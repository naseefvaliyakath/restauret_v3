import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../constants/app_colors/app_colors.dart';


class MyToggleSwitch extends StatelessWidget {
  final Function onToggle;
  final bool value;
  //? if its true then change btn text from full-loos to change-no for img upload
  final bool forImg;

  const MyToggleSwitch({Key? key, required this.onToggle, required this.value,  this.forImg = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      inactiveText: forImg ? 'image' : 'Full',
      activeText: forImg ? 'choose' :'Loos',
      inactiveColor: AppColors.mainColor_2,
      height: 28.0.sp,
      width: 70.sp,
      valueFontSize: 12.0,
      toggleSize: 20.0.sp,
      value: value,
      borderRadius: 50.0.r,
      padding: 5.sp,
      showOnOff: true,
      onToggle: (val) {
        onToggle(val);
      },
    );
  }
}
