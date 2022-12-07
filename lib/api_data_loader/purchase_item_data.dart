import 'package:get/get.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item_response.dart';
import '../models/my_response.dart';
import '../repository/purchase_item_repository.dart';

class PurchaseItemsData extends GetxController {
  final PurchaseItemRepo _purchaseItemRepo = Get.find<PurchaseItemRepo>();
  //? to store purchaseItem
  final List<PurchaseItem> _allPurchaseItem = [];
  List<PurchaseItem> get allPurchaseItem => _allPurchaseItem;

  @override
  Future<void> onInit() async {
    super.onInit();
  }


  Future<MyResponse> getAllPurchaseItem({DateTime? startDate, DateTime? endDate}) async {
    try {
      MyResponse response = await _purchaseItemRepo.getAllPurchase(startDate: startDate,endDate: endDate);

      if (response.statusCode == 1) {
        PurchaseItemResponse parsedResponse = response.data;
        if (parsedResponse.data == null) {
          _allPurchaseItem;
          return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
        } else {
          _allPurchaseItem.clear();
          _allPurchaseItem.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allPurchaseItem, status: 'Success', message:  'Updated successfully');
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
      }
    } catch (e) {
      return MyResponse(statusCode: 0, status: 'Error', message: 'Something wrong !!');
    }finally{
      update();
    }

  }



}