import 'package:get/get.dart';
import '../../../api_data_loader/category_data.dart';
import '../controller/add_food_controller.dart';


class AddFoodBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CategoryData>(CategoryData(), permanent: true);
    Get.lazyPut<AddFoodController>(() => AddFoodController());
  }
}