import 'package:dio/dio.dart';
class MyDioError{
  static String dioError(e) {
    String error = 'Something Wrong';
    switch (e.type) {
      case DioErrorType.connectTimeout:
        error = 'Connection Time Out';
        break;
      case DioErrorType.receiveTimeout:
        error =  'Receive Time Out';
        break;
      case DioErrorType.sendTimeout:
        error =  'Send Time Out';
        break;
      case DioErrorType.cancel:
        error =  'Request Cancelled';
        break;

      case DioErrorType.response:
        error =  'Response Error';
        break;
      case DioErrorType.other:
        error =  'Something went to wrong';
        break;
      default:
        error =  'Something went to wrong';
    }
    return error;
  }
}
