import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/screens/add_food_screen/add_food_screen.dart';
import 'package:rest_verision_3/screens/add_food_screen/pc_add_food_screen.dart';

import 'controller/add_food_controller.dart';


class AddFoodScreenFrame extends StatelessWidget {
  const AddFoodScreenFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddFoodController>(builder: (logic) {
      bool horizontal = 1.sh < 1.sw ? true : false;
      return Scaffold(body:
      horizontal ? const PcAddFoodScreen() : const AddFoodScreen());
    });
  }
}

