import 'package:get/get.dart';
import 'package:rest_verision_3/models/settled_order_response/settled_order.dart';
import 'package:rest_verision_3/repository/settled_order_response.dart';

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

  getAllSettledOrder() async {
    try {
      MyResponse response = await _settledOrderRepo.getAllSettledOrder();

      if (response.statusCode == 1) {
        SettledOrderResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allSettledOrder;
        } else {
          _allSettledOrder.clear();
          _allSettledOrder.addAll(parsedResponse.data?.toList() ?? []);
        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
    update();
  }
}
