import 'package:get/get.dart';
import 'package:rest_verision_3/models/settled_order_response/settled_order.dart';
import 'package:rest_verision_3/repository/settled_order_repository.dart';
import '../models/my_response.dart';
import '../models/settled_order_response/settled_order_response.dart';

class SettledOrderData extends GetxController {
  final SettledOrderRepo _settledOrderRepo = Get.find<SettledOrderRepo>();

  //?in this array get all room data from api through out the app working
  //? to save all room
  final List<SettledOrder> _allSettledOrder = [];

  List<SettledOrder> get allSettledOrder => _allSettledOrder;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<MyResponse> getAllSettledOrder({DateTime? startDate , DateTime? endTime}) async {
    try {
      MyResponse response = await _settledOrderRepo.getAllSettledOrder(startDate: startDate,endDate: endTime);

      if (response.statusCode == 1) {
        SettledOrderResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allSettledOrder;
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _allSettledOrder.clear();
          _allSettledOrder.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allSettledOrder, status: 'Success', message:  'Updated successfully');
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message:  'Something wrong !!');
      }
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message:  'Something wrong !!');
    }
    finally{
      update();
    }

  }

}
