//? this repository call  all the data from api and store MyResponse the variable
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/error_handler/error_handler.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/category_response/category_response.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class CategoryRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

  Future<MyResponse> getCategory() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(GET_CATEGORY, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      CategoryResponse parsedResponse = CategoryResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'categoryRepo',methodName: 'getCategory()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
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
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'categoryRepo',methodName: 'insertCategory()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
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
        print(parsedResponse.errorCode);
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) :MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'categoryRepo',methodName: 'deleteCategory()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
    }
  }
}
