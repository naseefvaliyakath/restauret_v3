import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:rest_verision_3/models/complaints/complaint_response.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item_response.dart';

import '../constants/api_link/api_link.dart';
import '../constants/app_secret_constants/app_secret_constants.dart';
import '../models/my_response.dart';
import '../screens/login_screen/controller/startup_controller.dart';
import '../services/dio_error.dart';
import '../services/service.dart';

class ComplaintRepo extends GetxService {
  final HttpService _httpService = Get.find<HttpService>();



  //?insert complaint
  Future<MyResponse> insertComplaint(int phone,String complaintType, String description) async {
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
        return MyResponse(
            statusCode: 0,
            status: 'Error',
            message: SHOW_ERR ? parsedResponse.errorCode.toString() : 'Something wrong !!');
      } else {
        return MyResponse(statusCode: 1, status: 'Success', message: parsedResponse.errorCode.toString());
      }
    } on DioError catch (e) {
      return MyResponse(
          statusCode: 0, status: 'Error', message: SHOW_ERR ? MyDioError.dioError(e) : 'Something wrong !!');
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: SHOW_ERR ? e.toString() : 'Something wrong !!');
    }
  }


}
