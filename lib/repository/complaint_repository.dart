import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/models/complaints/complaint_response.dart';
import '../constants/api_link/api_link.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class ComplaintRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr = Get.find<StartupController>().showErr;

  //?insert complaint
  Future<MyResponse> insertComplaint(int phone, String complaintType, String description) async {
    try {
      Map<String, dynamic> complaintData = {
        'fdShopId': Get.find<StartupController>().SHOPE_ID,
        'description': description,
        'complaintType': complaintType,
        'phone': phone
      };

      final response = await _httpService.insertWithBody(INSERT_COMPLAINT, complaintData);

      ComplaintResponse parsedResponse = ComplaintResponse.fromJson(response.data);

      if (parsedResponse.error ?? true) {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
        return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
      } else {
        String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
        return MyResponse(statusCode: 1, status: 'Success', message: myMessage);
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) :MyDioError.dioError(e);
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'complaintRepo',methodName: 'insertComplaint()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }
  }
}
