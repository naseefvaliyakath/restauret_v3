import 'package:get/get.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/category_response/category.dart';
import '../models/category_response/category_response.dart';
import '../models/my_response.dart';
import '../repository/category_repository.dart';


class CategoryData extends GetxController {
  final CategoryRepo _categoryRepo = Get.find<CategoryRepo>();

  //?in this array get all category data from api through out the app working
  //? to save all category
  final List<Category> _allCategory = [];
  List<Category> get allCategory => _allCategory;

  @override
  Future<void> onInit() async {
    //getAllCategory();
    super.onInit();
  }

  getAllCategory() async {
    try {
      MyResponse response = await _categoryRepo.getCategory();

      if (response.statusCode == 1) {
        CategoryResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allCategory;
        } else {
          _allCategory.addAll(parsedResponse.data?.toList() ?? []);
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
