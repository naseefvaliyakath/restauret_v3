import 'package:get/get.dart';

import '../../../api_data_loader/category_data.dart';
import '../controller/update_food_controller.dart';


class UpdateFoodBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CategoryData>(CategoryData(), permanent: true);
    Get.lazyPut<UpdateFoodController>(() => UpdateFoodController());

  }
}