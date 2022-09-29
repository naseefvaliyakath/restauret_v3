import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/app_secret_constants/app_secret_constants.dart';
import '../constants/api_link/api_link.dart';
import '../models/foods_response/food_response.dart';
import '../models/my_response.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

//? this repository call  all the data from api and store MyResponse the variable
class FoodRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();

  Future<MyResponse> getTodayFoods() async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(TODAY_FOOD_URL, {'fdShopId': SHOPE_ID});
      FoodResponse? parsedResponse = FoodResponse.fromJson(response.data);
      return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));
    } catch (e) {
      rethrow;
      // return MyResponse(statusCode: 0, status: 'Error', message: 'Error');
    } finally {}
  }

  Future<MyResponse> getAllFoods() async {
    // TODO: implement getNewsHeadline

    try {
      final response = await _httpService.getRequestWithBody(ALL_FOOD_URL, {'fdShopId': SHOPE_ID});
      FoodResponse? parsedResponse = FoodResponse.fromJson(response.data);
      return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));
    } catch (e) {
      rethrow;
      // return MyResponse(statusCode: 0, status: 'Error', message: 'Error');
    } finally {}
  }

  //! need add shopId for retrieving foods
  //! currently it not used now using search from local data
  Future<MyResponse> searchTodayFoods({required int fdShopId, required String query, required String fdIsToday}) async {
    // TODO: implement getNewsHeadline

    try {
      //? fdIsToday has no effect working based in server side
      final response = await _httpService.getRequestWithBody(SEARCH_TODAY_FOOD, {'fdName': query, 'fdIsToday': fdIsToday});
      FoodResponse? parsedResponse = FoodResponse.fromJson(response.data);
      return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));
    } catch (e) {
      rethrow;
      // return MyResponse(statusCode: 0, status: 'Error', message: 'Error');
    } finally {}
  }

  //! need add shopId for retrieving foods
  //! currently it not used now using search from local data
  Future<MyResponse> searchAllFoods({required int fdShopId, required String query, required String fdIsToday}) async {
    // TODO: implement getNewsHeadline

    try {
      //? fdIsToday has no effect work based on server side
      final response = await _httpService.getRequestWithBody(SEARCH_ALL_FOOD, {'fdName': query, 'fdIsToday': fdIsToday});
      FoodResponse? parsedResponse = FoodResponse.fromJson(response.data);
      return MyResponse(statusCode: 1, status: 'Success', data: parsedResponse, message: response.statusMessage.toString());
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));
    } catch (e) {
      rethrow;
      // return MyResponse(statusCode: 0, status: 'Error', message: 'Error');
    } finally {}
  }

  //! update today food
  Future<MyResponse> updateTodayFood(int fdId, String isToday) async {
    try {
      Map<String, dynamic> foodData = {'fdId': fdId, 'fdIsToday': isToday, 'fdShopId': SHOPE_ID};
      final response = await _httpService.updateData(TODAY_FOOD_UPDATE, foodData);
      FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
      if (parsedResponse.error) {
        return MyResponse(statusCode: 0, status: 'Error', message: response.statusMessage.toString());
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: MyDioError.dioError(e));
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: e.toString());
    }
  }
}
