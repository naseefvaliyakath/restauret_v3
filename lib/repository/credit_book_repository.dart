import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/credit_debit_response/credit_debit_response.dart';
import 'package:rest_verision_3/models/credit_user_response/credit_user_response.dart';


import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class CreditBookRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();



  //?insert credit user
  Future<MyResponse> insertCreditUser(String crUserName) async {
    try {

      Map<String, dynamic> userDetails = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'crUserName': crUserName,
      };

      final response = await _httpService.insertWithBody(INSERT_CREDIT_USER, userDetails);

      CreditUserResponse parsedResponse = CreditUserResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? parsedResponse.errorCode.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: parsedResponse.errorCode.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }


  //? get all credit users
  Future<MyResponse> getCreditUser() async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_CREDIT_USER, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      CreditUserResponse? parsedResponse = CreditUserResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error',  message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

  //? delete category
  deleteCreditUser(int id,String crUserName) async {
    try {
      Map<String, dynamic> userData = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'crUserId': id,
        'crUserName': crUserName,
      };
      final response = await _httpService.delete(DELETE_CREDIT_USER,userData);
      CreditUserResponse parsedResponse = CreditUserResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? parsedResponse.errorCode.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success',message:  response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }


  //? get all credit debit with user id
  Future<MyResponse> getCreditDebit(int crUserId) async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_CREDIT_DEBIT, {'fdShopId': Get.find<StartupController>().SHOPE_ID, 'crUserId': crUserId});
      CreditDebitResponse? parsedResponse = CreditDebitResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error',  message: SHOW_ERR ? response.statusMessage.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

  //?insert credit debit
  Future<MyResponse> insertCreditDebit(int crUserId,String description,num debitAmount,num creditAmount) async {
    try {

      Map<String, dynamic> creditDetails = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'crUserId': crUserId,
        'description': description,
        'debitAmount': debitAmount,
        'creditAmount':creditAmount
      };

      final response = await _httpService.insertWithBody(INSERT_CREDIT_DEBIT, creditDetails);

      CreditDebitResponse parsedResponse = CreditDebitResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? parsedResponse.errorCode.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: parsedResponse.errorCode.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }


  //? delete category
  deleteCreditDebit(int crUserId,int creditDebitId) async {
    try {
      Map<String, dynamic> creditData = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'crUserId': crUserId,
        'creditDebitId': creditDebitId,
      };
      final response = await _httpService.delete(DELETE_CREDIT_DEBIT,creditData);
      CreditDebitResponse parsedResponse = CreditDebitResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? parsedResponse.errorCode.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success',message:  response.statusMessage.toString());
      }
    } on DioError catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }

}