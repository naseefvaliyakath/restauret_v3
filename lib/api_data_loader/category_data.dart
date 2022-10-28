import 'package:get/get.dart';
import 'package:rest_verision_3/screens/add_food_screen/controller/add_food_controller.dart';
import 'package:rest_verision_3/screens/today_food_screen/controller/today_food_controller.dart';
import 'package:rest_verision_3/screens/update_food_screen/controller/update_food_controller.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
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

  getCategory({
    bool fromAddFood = false,
    bool fromUpdateFood = false,
    bool fromBilling = false,
    bool fromToday = false,
    bool fromAllFood = false,
  }) async {
    try {
      MyResponse response = await _categoryRepo.getCategory();

      if (response.statusCode == 1) {
        CategoryResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _category;
        } else {
          _category.clear();
          _category.addAll(parsedResponse.data?.toList() ?? []);
          if (fromAddFood) {
            if (Get.isRegistered<AddFoodController>()) {
              Get.find<AddFoodController>().refreshMyCategory(_category);
            } else {
              Get.lazyPut<AddFoodController>(() => AddFoodController());
              Get.find<AddFoodController>().refreshMyCategory(_category);
            }
          }
          if (fromUpdateFood) {
            if (Get.isRegistered<UpdateFoodController>()) {
              Get.find<UpdateFoodController>().refreshMyCategory(_category);
            } else {
              Get.lazyPut<UpdateFoodController>(() => UpdateFoodController());
              Get.find<UpdateFoodController>().refreshMyCategory(_category);
            }
          }
          if (fromBilling) {
            if (Get.isRegistered<BillingScreenController>()) {
              Get.find<BillingScreenController>().refreshMyCategory(_category);
            } else {
              Get.lazyPut<BillingScreenController>(() => BillingScreenController());
              Get.find<BillingScreenController>().refreshMyCategory(_category);
            }
          }

          if (fromToday) {
            if (Get.isRegistered<TodayFoodController>()) {
              Get.find<TodayFoodController>().refreshMyCategory(_category);
            } else {
              Get.lazyPut<TodayFoodController>(() => TodayFoodController());
              Get.find<TodayFoodController>().refreshMyCategory(_category);
            }
          }

          if (fromAllFood) {
            if (Get.isRegistered<AllFoodController>()) {
              Get.find<AllFoodController>().refreshMyCategory(_category);
            } else {
              Get.lazyPut<AllFoodController>(() => AllFoodController());
              Get.find<AllFoodController>().refreshMyCategory(_category);
            }
          }
        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
    update();
  }
}
