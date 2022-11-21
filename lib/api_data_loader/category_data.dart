import 'package:get/get.dart';
import 'package:rest_verision_3/screens/add_food_screen/controller/add_food_controller.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';
import 'package:rest_verision_3/screens/update_food_screen/controller/update_food_controller.dart';

import '../models/category_response/category.dart';
import '../models/category_response/category_response.dart';
import '../models/my_response.dart';
import '../repository/category_repository.dart';
import '../screens/all_food_screen/controller/all_food_controller.dart';
import '../screens/billing_screen/controller/billing_screen_controller.dart';

class CategoryData extends GetxController {
  final CategoryRepo _categoryRepo = Get.find<CategoryRepo>();

  //?in this array get all category data from api through out the app working
  //? to save all category
  final List<Category> _category = [];

  List<Category> get category => _category;

  @override
  Future<void> onInit() async {
    //? no need to call getCategory() so its called inside add AddFoodController and updateFoodController on initially
    super.onInit();
  }

  Future<MyResponse> getCategory() async {
    try {
      MyResponse response = await _categoryRepo.getCategory();

      if (response.statusCode == 1) {
        CategoryResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _category;
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _category.clear();
          _category.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _category, status: 'Success', message:  'Updated successfully');
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
      }
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
    }finally{
      update();
    }

  }
}
