import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/update_food_screen/pc_update_food_screen.dart';
import 'package:rest_verision_3/screens/update_food_screen/update_food_screen.dart';
import 'controller/update_food_controller.dart';

class UpdateFoodScreenFrame extends StatelessWidget {
  const UpdateFoodScreenFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateFoodController>(builder: (logic) {
      bool horizontal = 1.sh < 1.sw ? true : false;
      return Scaffold(body:
      horizontal ? const PcUpdateFoodScreen() : const UpdateFoodScreen());
    });
  }
}