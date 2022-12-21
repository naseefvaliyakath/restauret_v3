import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/credit_debit_response/credit_debit_response.dart';
import 'package:rest_verision_3/models/credit_user_response/credit_user_response.dart';

import '../constants/api_link/api_link.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class CreditBookRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr = Get.find<StartupController>().showErr;


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
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'creditBookRepo',methodName: 'insertCreditUser()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
    }
  }


  //? get all credit users
  Future<MyResponse> getCreditUser() async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_CREDIT_USER, {'fdShopId': Get.find<StartupController>().SHOPE_ID});
      CreditUserResponse? parsedResponse = CreditUserResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error',  message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'creditBookRepo',methodName: 'getCreditUser()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
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
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success',message:  myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'creditBookRepo',methodName: 'deleteCreditUser()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }


  //? get all credit debit with user id
  Future<MyResponse> getCreditDebit(int crUserId) async {
    // TODO: implement getNewsHeadline
    try {
      final response = await _httpService.getRequestWithBody(GET_CREDIT_DEBIT, {'fdShopId': Get.find<StartupController>().SHOPE_ID, 'crUserId': crUserId});
      CreditDebitResponse? parsedResponse = CreditDebitResponse.fromJson(response.data);
      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error',  message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success',data: parsedResponse, message:  myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'creditBookRepo',methodName: 'getCreditDebit()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
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
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'creditBookRepo',methodName: 'creditDetails()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
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
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success',message:  myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'creditBookRepo',methodName: 'deleteCreditDebit()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message:myMessage);
    }
  }

}