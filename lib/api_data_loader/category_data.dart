import 'package:get/get.dart';
import '../error_handler/error_handler.dart';
import '../models/category_response/category.dart';
import '../models/category_response/category_response.dart';
import '../models/my_response.dart';
import '../repository/category_repository.dart';
import '../screens/login_screen/controller/startup_controller.dart';


class CategoryData extends GetxController {
  final CategoryRepo _categoryRepo = Get.find<CategoryRepo>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

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
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _category.clear();
          _category.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _category, status: 'Success', message:  response.message);
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: response.message);
      }
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'categoryData',methodName: 'getCategory()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }finally{
      update();
    }

  }
}
