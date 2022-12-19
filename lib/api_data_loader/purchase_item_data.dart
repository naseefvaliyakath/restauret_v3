import 'package:get/get.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item.dart';
import 'package:rest_verision_3/models/purchase_items/purchase_item_response.dart';
import '../error_handler/error_handler.dart';
import '../models/my_response.dart';
import '../repository/purchase_item_repository.dart';
import '../screens/login_screen/controller/startup_controller.dart';

class PurchaseItemsData extends GetxController {
  final PurchaseItemRepo _purchaseItemRepo = Get.find<PurchaseItemRepo>();
  final ErrorHandler _errHandler = Get.find<ErrorHandler>();
  bool showErr  = Get.find<StartupController>().showErr;

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
          return MyResponse(statusCode: 0, status: 'Error', message: response.message);
        } else {
          _allPurchaseItem.clear();
          _allPurchaseItem.addAll(parsedResponse.data?.toList() ?? []);
          return MyResponse(statusCode: 1,data: _allPurchaseItem, status: 'Success', message:   response.message);
        }
      } else {
        return MyResponse(statusCode: 0, status: 'Error', message:  response.message);
      }
    } catch (e) {
      _errHandler.myResponseHandler(error: e.toString(),pageName: 'purchaseItemData',methodName: 'getAllPurchaseItem()');
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      return MyResponse(statusCode: 0, status: 'Error', message: myMessage);
    }finally{
      update();
    }

  }



}