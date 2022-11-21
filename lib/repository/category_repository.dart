//? this repository call  all the data from api and store MyResponse the variable
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/category_response/category_response.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class CategoryRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getCategory() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(GET_CATEGORY, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      CategoryResponse parsedResponse = CategoryResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

  //? insert room
  Future<MyResponse> insertCategory(roomNameString) async {
    try {
      Map<String, dynamic> categoryDetails = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'catName': roomNameString,
      };

      final response = await _httpService.insertWithBody(INSERT_CATEGORY, categoryDetails);
      CategoryResponse parsedResponse = CategoryResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ?  response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }


  //? delete category
  deleteCategory(int id) async {
    try {
      Map<String, dynamic> categoryData = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'CatId': id,
      };
      final response = await _httpService.delete(DELETE_CATEGORY, categoryData);
      CategoryResponse parsedResponse = CategoryResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        String errorCode = parsedResponse.errorCode == 'First delete foods with this category' ? parsedResponse.errorCode.toString() : 'Something went wrong';
        return MyResponse(statusCode: 0, status: 'Cannot delete !', message: errorCode.toString());
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }
}
