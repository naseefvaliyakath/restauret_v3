import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response,FormData,MultipartFile;
import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../error_handler/error_handler.dart';


class HttpService extends GetxService{
  //? secure storage for saving token
  FlutterSecureStorage storage =  const FlutterSecureStorage();
  Dio _dio = Dio();
  String token = STARTUP_TOKEN;

  @override
  void onInit() async {
    initializeSecureStorage();
    token = await storage.read(key: 'token') ?? STARTUP_TOKEN;
    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6IjQzMjEiLCJpYXQiOjE2NzEyMTQyOTV9.gB6CXlz5nj4twK-DBGBlpus85UxLYvhrLMl8j0LCZog";
    _dio = Dio(BaseOptions(baseUrl: BASE_URL, headers: {"Authorization": "Bearer $token"}));
    initializeInterceptors();
    super.onInit();
  }

  Future<Response> getRequest(String url) async {
    // TODO: implement getRequest

    Response response;
    try {
      response = await _dio.get(url);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    } finally {}

    return response;
  }

  Future<Response> getRequestWithBody(String url, body) async {
    // TODO: implement getRequest

    Response response;
    try {
      response = await _dio.get(url, queryParameters: body);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    } finally {}

    return response;
  }

  //delete with id
  Future<Response> delete(String url, body) async {
    // TODO: implement getRequest

    Response response;
    try {
      response = await _dio.delete(url, data: json.encode(body));
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    } finally {}

    return response;
  }

  Future<Response> updateData(String url, dynamic body) async {
    Response response;
    try {
      response = await _dio.put(url, data: json.encode(body));
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    } finally {}
    return response;
  }

  //insert with body
  Future<Response> insertWithBody(String url, body) async {
    // TODO: implement getRequest

    Response response;
    try {
      response = await _dio.post(url, data: body);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    } finally {}

    return response;
  }

  Future<Response> insertFood({
    required File? file,
    required fdShopId,
    required cookTime,
    required fdName,
    required fdCategory,
    required fdPrice,
    required fdThreeBiTwoPrsPrice,
    required fdHalfPrice,
    required fdQtrPrice,
    required fdIsLoos,
  }) async {
    FormData formData;
    if (kDebugMode) {
      print(file);
    }

    if (file != null) {
      if (kDebugMode) {
        print('no file in body');
      }
      String fileName = file.path.split('/').last;
      formData = FormData.fromMap({
        "myFile": await MultipartFile.fromFile(file.path, filename: fileName),
        "fdName": fdName,
        "fdCategory": fdCategory,
        "fdFullPrice": fdPrice,
        "fdThreeBiTwoPrsPrice": fdThreeBiTwoPrsPrice,
        "fdHalfPrice": fdHalfPrice,
        "fdQtrPrice": fdQtrPrice,
        "fdIsLoos": fdIsLoos,
        "cookTime": cookTime,
        "fdShopId": fdShopId,
      });
    } else {
      if (kDebugMode) {
        print('body has no file');
      }
      formData = FormData.fromMap({
        "myFile": null,
        "fdName": fdName,
        "fdCategory": fdCategory,
        "fdFullPrice": fdPrice,
        "fdThreeBiTwoPrsPrice": fdThreeBiTwoPrsPrice,
        "fdHalfPrice": fdHalfPrice,
        "fdQtrPrice": fdQtrPrice,
        "fdIsLoos": fdIsLoos,
        "cookTime": cookTime,
        "fdShopId": fdShopId,
      });
    }

    Response response;
    try {
      response = await _dio.post(INSERT_FOOD_URL, data: formData);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    } finally {}

    return response;
  }

  Future<Response> updateFood(
      {required File? file,
      required fdName,
      required fdCategory,
      required fdPrice,
      required fdThreeBiTwoPrsPrice,
      required fdHalfPrice,
      required fdQtrPrice,
      required fdIsLoos,
      required cookTime,
      required fdShopId,
      required fdImg,
      required fdIsToday,
      required fdId}) async {
    FormData formData;

    if (kDebugMode) {
      print(file);
    }

    if (file != null) {
      if (kDebugMode) {
        print(file);
      }
      String fileName = file.path.split('/').last;
      formData = FormData.fromMap({
        "myFile": await MultipartFile.fromFile(file.path, filename: fileName),
        "fdName": fdName,
        "fdCategory": fdCategory,
        "fdFullPrice": fdPrice,
        "fdThreeBiTwoPrsPrice": fdThreeBiTwoPrsPrice,
        "fdHalfPrice": fdHalfPrice,
        "fdQtrPrice": fdQtrPrice,
        "fdIsLoos": fdIsLoos,
        "cookTime": cookTime,
        "fdShopId": fdShopId,
        "fdImg": fdImg,
        "fdIsToday": fdIsToday,
        "fdId": fdId,
      });
    } else {
      if (kDebugMode) {
        print('body has no file');
      }
      formData = FormData.fromMap({
        "myFile": null,
        "fdName": fdName,
        "fdCategory": fdCategory,
        "fdFullPrice": fdPrice,
        "fdThreeBiTwoPrsPrice": fdThreeBiTwoPrsPrice,
        "fdHalfPrice": fdHalfPrice,
        "fdQtrPrice": fdQtrPrice,
        "fdIsLoos": fdIsLoos,
        "cookTime": cookTime,
        "fdShopId": fdShopId,
        "fdIsToday": fdIsToday,
        "fdId": fdId,
      });
    }

    Response response;
    try {
      response = await _dio.put(UPDATE_FOOD_URL, data: formData);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    } finally {}
    return response;
  }

//for upload online app with image
  Future<Response> insertOnlineApp({
    required File? file,
    required fdShopId,
    required appName,
  }) async {
    FormData formData;
    if (kDebugMode) {
      print(file);
    }

    if (file != null) {
      if (kDebugMode) {
        print('body has no file');
      }
      String fileName = file.path.split('/').last;
      formData = FormData.fromMap(
          {"myFile": await MultipartFile.fromFile(file.path, filename: fileName), "fdShopId": fdShopId, "appName": appName});
    } else {
      if (kDebugMode) {
        print('body has no file');
      }
      formData = FormData.fromMap({"myFile": null, "fdShopId": fdShopId, "appName": appName});
    }

    Response response;
    try {
      response = await _dio.post(INSERT_ONLINE_APP, data: formData);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    } finally {}

    return response;
  }

  initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) async {
      // Do something before request is sent
      if (kDebugMode) {
        // print("${request.method} | ${request.path}");
      }
      return handler.next(request); //continue
    }, onResponse: (response, handler) {
      // Do something with response data
      if (kDebugMode) {
        // print("response from intercept ${response.statusCode} ${response.statusMessage} ${response.data}");
      }
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      // Do something with response error
      if (kDebugMode) {
        // print('deo error${e.message}');
      }
      // AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
      return handler.next(e);
    }));
  }

  updatingToken(tokenFromLogin){
    token = tokenFromLogin;
  }
  initializeSecureStorage(){
    try {
      if(Platform.isAndroid){
            AndroidOptions getAndroidOptions() => const AndroidOptions(
              encryptedSharedPreferences: true,
            );
            storage = FlutterSecureStorage(aOptions: getAndroidOptions());
          }
    } catch (e) {
      return;
    }
  }
}
