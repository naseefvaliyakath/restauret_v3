import 'package:get/get.dart';
import 'package:rest_verision_3/constants/hive_constants/hive_costants.dart';
import '../../../local_storage/local_storage_controller.dart';

class GeneralSettingsController extends GetxController {
  final MyLocalStorage _myLocalStorage = Get.find<MyLocalStorage>();

  //? to set toggle btn as per saved data
  bool setShowDeliveryAddressInBillToggle = true;

  @override
  void onInit() async {
    await readShowDeliveryAddressInBillFromHive();
    super.onInit();
  }


  //? to set show or hide address in bill in hive
  Future setShowDeliveryAddressInBillInHive(bool showOrHide) async {
    try {
      await _myLocalStorage.setData(HIVE_SHOW_ADDRESS_IN_BILL, showOrHide);
      setShowDeliveryAddressInBillToggle = showOrHide;
      update();
      update();
    } catch (e) {
      rethrow;
    }
  }

  //? to set show or hide address in bill in hive
  Future<bool> readShowDeliveryAddressInBillFromHive() async {
    try {
      bool result = await _myLocalStorage.readData(HIVE_SHOW_ADDRESS_IN_BILL) ?? true;
      setShowDeliveryAddressInBillToggle = result;
      print('hive toggle $setShowDeliveryAddressInBillToggle');
      update();
      return result;
    } catch (e) {
      rethrow;
    }
  }

}