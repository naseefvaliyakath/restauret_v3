import 'package:get/get.dart';
import 'package:rest_verision_3/constants/hive_constants/hive_costants.dart';
import '../../../local_storage/local_storage_controller.dart';

class GeneralSettingsController extends GetxController {
  final MyLocalStorage _myLocalStorage = Get.find<MyLocalStorage>();

  //? to set toggle btn as per saved data
  bool setShowDeliveryAddressInBillToggle = true;

  //? to set toggle btn as per saved data
  bool setAllowCreditBookToWaiterToggle = false;

  //? to set toggle btn as per saved data
  bool setAllowPurchaseBookToWaiterToggle = false;

  @override
  void onInit() async {
    await readShowDeliveryAddressInBillFromHive();
    await readAllowCreditBookToWaiterFromHive();
    await readAllowPurchaseBookToWaiterFromHive();
    super.onInit();
  }


  //? to set show or hide address in bill in hive
  Future setShowDeliveryAddressInBillInHive(bool showOrHide) async {
    try {
      await _myLocalStorage.setData(HIVE_SHOW_ADDRESS_IN_BILL, showOrHide);
      setShowDeliveryAddressInBillToggle = showOrHide;
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
      update();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  //? to set allow or restrict open  creditBook in hive
  Future setAllowCreditBookToWaiter(bool allowCreditBook) async {
    try {
      await _myLocalStorage.setData(ALLOW_CREDIT_BOOK_TO_WAITER, allowCreditBook);
      setAllowCreditBookToWaiterToggle = allowCreditBook;
      update();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> readAllowCreditBookToWaiterFromHive() async {
    try {
      bool result = await _myLocalStorage.readData(ALLOW_CREDIT_BOOK_TO_WAITER) ?? false;
      setAllowCreditBookToWaiterToggle = result;
      update();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  //? to set allow or restrict open  purchaseBook in hive
  Future setAllowPurchaseBookToWaiter(bool allowPurchaseBook) async {
    try {
      await _myLocalStorage.setData(ALLOW_CREDIT_BOOK_TO_WAITER, allowPurchaseBook);
      setAllowPurchaseBookToWaiterToggle = allowPurchaseBook;
      update();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> readAllowPurchaseBookToWaiterFromHive() async {
    try {
      bool result = await _myLocalStorage.readData(ALLOW_PURCHASE_BOOK_TO_WAITER) ?? false;
      setAllowPurchaseBookToWaiterToggle = result;
      update();
      return result;
    } catch (e) {
      rethrow;
    }
  }


}