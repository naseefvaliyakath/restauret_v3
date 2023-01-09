import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../constants/api_link/api_link.dart';
import '../../../services/service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../socket/socket_controller.dart';


class TableManageController extends GetxController {
  //to get category's
//   final FoodsRepo _foodsRepo = Get.find<FoodsRepo>();
//   final HttpService _httpService = Get.find<HttpService>();
//   final IO.Socket _socket = Get.find<SocketController>().socket;
//
//   bool addCategoryToggle = false; // to show add category or room card and text field
//   bool addCategoryLoading = false; // to show progress while adding new category or room
//
//
//  int kotIdFromOrderManageAlertGb =-1;
//
//   List<Room>? _room = [];
//
//   List<Room>? get room => _room;
//
//   //to get order details for showing uin chair
//   List<KitchenOrder> _kotBillingItems = [];
//
//   List<KitchenOrder>? get kotBillingItems => _kotBillingItems;
//
//   //single kot order for selected chair
//   //when click on chair it show the orders of that chair
//   KitchenOrder singleKitchenOrder = KitchenOrder(
//       Kot_id: -1,
//       totelPrice: 0,
//       fdOrderType: 'Dining',
//       errorCode: 'Error',
//       fdOrderStatus: 'Pending',
//       error: true,
//       totalSize: 0,
//       orderColor: 111);
//
//   //retrieving all kotTable details not list
//   //it itrate all array of kotTableChairSetList from db save in it
//   final List<KotTableChairSet> _kotTableChairSetList = [];
//
//   List<KotTableChairSet> get kotTableChairSetList => _kotTableChairSetList;
//
//   final RoundedLoadingButtonController btnControllerCancelKotOrderInTable = RoundedLoadingButtonController();
//
//   //roomId for sending create table screen
//   int _roomId = -1;
//
//   int get roomId => _roomId;
//
//   //to make chair shifting mode
//   bool _chairShiftMode = false;
//
//   bool get chairShiftMode => _chairShiftMode;
//
//   bool _linkChairMode = false;
//
//   bool get linkChairMode => _linkChairMode;
//
//   //all table chair set
//   List<TableChairSet> _tableSetLIst = [];
//
//   List<TableChairSet> get tableSetLIst => _tableSetLIst;
//
//   //selected table chair set for tapping different room
//   List<TableChairSet> _selecedTableSetLIst = [];
//
//   List<TableChairSet> get selecedTableSetLIst => _selecedTableSetLIst;
//
//   //this will get the current tableChair detals of shifting (for update)
//   KotTableChairSet shiftingTable = KotTableChairSet(-1, -1, 'L', -1, -1);
//
//   //tochane tapped coloer of category
//   int _tappedIndex = 0;
//
//   int get tappedIndex => _tappedIndex;
//
//   bool isLoading = false;
//
//   //for room update need other loader , so after catch isLoading become false so in ctr.list.length may couse error
//   bool isLoadingRoom = false;
//
//   //to add room name
//   late TextEditingController roomNameTD;
//
//   @override
//   void onInit() async {
//     getxArgumetsReciveHadler();
//     _socket.dispose();
//     _socket.connect();
//     roomNameTD = TextEditingController();
//     setUpKitchenOrderFromDbListner();
//     setUpKitchenOrderSingleListener();
//     await getRoom();
//     geTableSet();
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     _socket.close();
//     _socket.dispose();
//     roomNameTD.dispose();
//   }
//
//   // get rooms
//   getRoom() async {
//     try {
//       showLoadingCategory();
//       showLoading();
//       update();
//       MyResponse response = await _foodsRepo.getRoom();
//
//       if (response.statusCode == 1) {
//         hideLoadingCategory();
//         update();
//         RoomResponse parsedResponse = response.data;
//         if (parsedResponse.data == null) {
//           _room = [];
//         } else {
//           _room = parsedResponse.data;
//           print('rooms $_room');
//         }
//
//         //toast
//
//       } else {
//         print(response.message);
//         // AppSnackBar.errorSnackBar(response.status, response.message);
//         return;
//       }
//     } catch (e) {
//       showLoadingCategory();
//       update();
//       rethrow;
//     } finally {
//       //to get first room room id , then when tapping room tab this function will call
//       if (room!.isNotEmpty) {
//         getRoomId(0);
//       }
//       hideLoading();
//       update();
//     }
//   }
//
//
//
//   // to update room list after add new room , in this no show loading function
//   getRoomNoScreenRefresh() async {
//     try {
//       MyResponse response = await _foodsRepo.getRoom();
//       if (response.statusCode == 1) {
//         RoomResponse parsedResponse = response.data;
//         if (parsedResponse.data == null) {
//           _room = [];
//         } else {
//           _room = parsedResponse.data;
//           update();
//         }
//
//         //toast
//
//       } else {
//         print(response.message);
//         // AppSnackBar.errorSnackBar(response.status, response.message);
//         return;
//       }
//     } catch (e) {
//       rethrow;
//     } finally {}
//   }
//
//   //insert room
//   Future insertRoom() async {
//     try {
//       addCategoryLoading = true;
//       update();
//       String roomNameString = '';
//       roomNameString = roomNameTD.text;
//       if (roomNameString.trim() != '') {
//         Map<String, dynamic> roomDetails = {
//           'fdShopId': 10,
//           'roomName': roomNameString,
//         };
//
//         final response = await _httpService.insertWithBody(INSERT_ROOMS, roomDetails);
//
//         RoomResponse parsedResponse = RoomResponse.fromJson(response.data);
//         if (parsedResponse.error) {
//           AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode);
//         } else {
//           getRoomNoScreenRefresh();
//           AppSnackBar.successSnackBar('Success', parsedResponse.errorCode);
//           update();
//         }
//       } else {
//         AppSnackBar.errorSnackBar('Field is Empty', 'Pleas enter any room name');
//       }
//     } on DioError catch (e) {
//       AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
//     } catch (e) {
//       AppSnackBar.errorSnackBar('Error', 'Something Wrong !!');
//     } finally {
//       roomNameTD.text = '';
//       addCategoryLoading = false;
//       addCategoryToggle = false;
//       update();
//     }
//   }
//
//   // to get room id from select different rooms
//   getRoomId(int index) {
//     try {
//       //if rooms is empty
//       if (_room!.isEmpty) {
//         _roomId = -1;
//       } else {
//         _roomId = _room?[index].room_id ?? -1;
//       }
//     } catch (e) {
//       _roomId = -1;
//     }
//     print('room_id$_roomId');
//   }
//
//   //get all  Table Chair
//   geTableSet() async {
//     try {
//       showLoading();
//       update();
//       MyResponse response = await _foodsRepo.geTableSet(10);
//
//       hideLoading();
//       update();
//
//       if (response.statusCode == 1) {
//         TableChairSetResponse? parsedResponse = response.data;
//         if (parsedResponse == null) {
//           _tableSetLIst = [];
//           _selecedTableSetLIst = [];
//         } else {
//           _tableSetLIst = parsedResponse.data!;
//           //on page loading show first room tables
//           updateTableChairSetWithRoomId(0);
//           print('table set $_tableSetLIst');
//         }
//
//         //toast
//
//       } else {
//         print('${response.message}');
//         // AppSnackBar.errorSnackBar(response.status, response.message);
//         return;
//       }
//     } catch (e) {
//       // AppSnackBar.errorSnackBar('error', 'Soothing went to Wrong');
//       rethrow;
//     }
//     update();
//   }
//
//
//   //get all  Table Chair no refresh
//   geTableSetNoRefresh() async {
//     try {
//
//       MyResponse response = await _foodsRepo.geTableSet(10);
//
//       if (response.statusCode == 1) {
//         TableChairSetResponse? parsedResponse = response.data;
//         if (parsedResponse == null) {
//           _tableSetLIst = [];
//           _selecedTableSetLIst = [];
//         } else {
//           _tableSetLIst = parsedResponse.data!;
//           //on page loading show first room tables
//           updateTableChairSetWithRoomId(0);
//           print('table set $_tableSetLIst');
//         }
//
//         //toast
//
//       } else {
//         print('${response.message}');
//         // AppSnackBar.errorSnackBar(response.status, response.message);
//         return;
//       }
//     } catch (e) {
//       // AppSnackBar.errorSnackBar('error', 'Soothing went to Wrong');
//       rethrow;
//     }
//     update();
//   }
//
//   //for first load data to bill from data base
//   setUpKitchenOrderFromDbListner() {
//     try {
//       KitchenOrderArray order = KitchenOrderArray(error: true, errorCode: '', totalSize: 0);
//       _socket.on('database-data-receive', (data) {
//         print('kot socket database refresh');
//         order = KitchenOrderArray.fromJson(data);
//         List<KitchenOrder>? kitchenOrders = order.kitchenOrder;
//         //no error
//         if (!order.error) {
//           //check if item is already in list
//           _kotBillingItems.clear();
//           _kotTableChairSetList.clear();
//           for (var elementKitchenOrders in kitchenOrders!) {
//             //adding all kitchenOrder
//             _kotBillingItems.add(elementKitchenOrders);
//             //then from kitchen order take table details
//             for (var elementTableChairSet in elementKitchenOrders.kotTableChairSet!) {
//               _kotTableChairSetList.add(elementTableChairSet);
//             }
//           }
//
//           update();
//         } else {
//           return;
//         }
//       });
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   //for single order adding live
//   setUpKitchenOrderSingleListener() {
//     try {
//       KitchenOrder order = KitchenOrder(
//           fdOrderType: '',
//           totelPrice: 0,
//           fdOrderStatus: '',
//           Kot_id: 0,
//           errorCode: '',
//           totalSize: 0,
//           error: true,
//           orderColor: 111);
//       _socket.on('kitchen_orders_receive', (data) {
//         print('kotorder single rcv');
//         order = KitchenOrder.fromJson(data);
//         //no error
//         if (!order.error) {
//           //check if item is already in list
//           bool isExist = true;
//           for (var element in _kotBillingItems) {
//             if (element.Kot_id != order.Kot_id) {
//               isExist = false;
//             } else {
//               isExist = true;
//             }
//           }
//           //add if not exist
//           if (isExist == false) {
//             _kotBillingItems.insert(0, order);
//             //then from kitchen order take table details
//             for (var elementTableChairSet in order.kotTableChairSet!) {
//               _kotTableChairSetList.add(elementTableChairSet);
//             }
//           } else {
//             _kotBillingItems = _kotBillingItems;
//           }
//           update();
//         } else {
//           return;
//         }
//       });
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   //this emit will recive and emit from server to refresh data
//   refreshDatabaseKot() {
//     _socket.emit('refresh-database-order');
//   }
//
//   //for showing order details when clickmchair
//   getKotOrderListFromKotId(int kotId) {
//     try {
//       for (var element in _kotBillingItems) {
//         if (element.Kot_id == kotId) {
//           singleKitchenOrder = element;
//           update();
//           break;
//         } else {
//           singleKitchenOrder = singleKitchenOrder;
//         }
//       }
//     } catch (e) {
//       singleKitchenOrder = singleKitchenOrder;
//       rethrow;
//     }
//   }
//
//   //to delete/cacell kot order
//   deleteKotOrder(int KotId) async {
//     try {
//       Map<String, dynamic> data = {
//         'Kot_id': KotId,
//       };
//       final response = await _httpService.delete(DELETE_KOT_ORDER, data);
//       FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
//       if (parsedResponse.error) {
//         btnControllerCancelKotOrderInTable.error();
//         AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode);
//       } else {
//         btnControllerCancelKotOrderInTable.success();
//         AppSnackBar.successSnackBar('Success', parsedResponse.errorCode);
//         refreshDatabaseKot();
//       }
//     } on DioError catch (e) {
//       btnControllerCancelKotOrderInTable.error();
//       AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
//     } catch (e) {
//       btnControllerCancelKotOrderInTable.error();
//       AppSnackBar.errorSnackBar('Error', 'Something wet to wrong');
//     } finally {
//       Future.delayed(const Duration(seconds: 1), () {
//         btnControllerCancelKotOrderInTable.reset();
//       });
//       update();
//     }
//   }
//
//   //edit kot order or update kot order
//   updateKotOrder({required kotId}) {
//     getKotOrderListFromKotId(kotId);
//     Get.offNamed(RouteHelper.getDiningBillingScreen(), arguments: {'kotItem': singleKitchenOrder, 'from': 'tableManage'});
//   }
//
//   //to set shifted mode
//   updateShiftedMode(bool shiftedMOde) {
//     _chairShiftMode = shiftedMOde;
//     update();
//   }
//
//   //this function will call when shift button click
//   //and give the detais of shifting chair to variable shiftingTable
//   getTheDetailsOfShiftingChair({required int kotId, required int tbChrIndexInDb}) {
//     //this will assign the detals of kot in the current chair to singleKotOrder variable
//     // this will call when shift button will click
//     // now the detals of fromShift chair in singleKotOrder variable
//     getKotOrderListFromKotId(kotId);
//     for (var element in singleKitchenOrder.kotTableChairSet!) {
//       if (element.tbChrIndexInDb == tbChrIndexInDb) {
//         shiftingTable = element;
//       }
//     }
//
//     print('current_tb_id${shiftingTable.tableId}');
//   }
//
//   shiftChairAlert({
//     required BuildContext context,
//     required int kotId,
//     required int tableIndex,
//     required int tableId,
//     required int chrIndex,
//     required String position,
//   }) {
//     generalConfirmAlert(
//       context: context,
//       title: 'Shift the chair ?',
//       desc: 'do you want to shift the chair to T${tableIndex + 1}-C${chrIndex + 1}',
//       onTap: () {
//         updateShiftedChair(newChrIndex: chrIndex, newPosition: position, newTableId: tableId);
//       },
//       onTapCancel: () {},
//     );
//   }
//
//   /// update shifting table to server///
//
//
//   //to handle Get.argemrt fro diffrent pages like fro hold item or kot update .. etc
//   getxArgumetsReciveHadler() {
//     var args = Get.arguments ?? {'kotId': -1};
//
//     int kotIdFromOrderManageAlert = args['kotId'] ??-1;
//     if (kotIdFromOrderManageAlert != -1) {
//       receiveKotIdForAddNewChairToKotOrder(kotIdFromOrderManageAlert);
//     }
//   }
//
//   receiveKotIdForAddNewChairToKotOrder(kotIdFromOrderManageAlert){
//     print('kot id from order alert$kotIdFromOrderManageAlert');
//     kotIdFromOrderManageAlertGb = kotIdFromOrderManageAlert;
//   }
//
//   Future updateShiftedChair({
//     required int newTableId,
//     required String newPosition,
//     required int newChrIndex,
//   }) async {
//     try {
//       //check shiftingTable(current table) is selected or not
//       //if error its -1
//       if (shiftingTable.tableId != -1) {
//         Map<String, dynamic> tableShiftUpdate = {
//           'fdShopId': 10,
//           'Kot_id': shiftingTable.Kot_id,
//           'tbChrIndexInDb': shiftingTable.tbChrIndexInDb,
//           'currentTableId': shiftingTable.tableId,
//           'currentPosition': shiftingTable.position,
//           'currentChrIndex': shiftingTable.chrIndex,
//           'newTableId': newTableId,
//           'newPosition': newPosition,
//           'newChrIndex': newChrIndex,
//         };
//         final response = await _httpService.updateData(SHIFT_TABLE_CHR, tableShiftUpdate);
//
//         FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
//         if (parsedResponse.error) {
//           // btnControllerUpdateKot.error();
//           AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode);
//         } else {
//           print('object');
//           //btnControllerUpdateKot.success();
//           AppSnackBar.successSnackBar('Success', parsedResponse.errorCode);
//           refreshDatabaseKot();
//           updateShiftedMode(false);
//           update();
//         }
//       } else {
//         //btnControllerUpdateKot.error();
//         AppSnackBar.errorSnackBar('Error !', 'Something wrong');
//       }
//     } on DioError catch (e) {
//       //btnControllerUpdateKot.error();
//       AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
//     } catch (e) {
//       //btnControllerUpdateKot.error();
//     } finally {
//       update();
//       print('finally');
//       Future.delayed(const Duration(seconds: 1), () {
//         // btnControllerUpdateKot.reset();
//       });
//     }
//   }
//
//   getClickedTableChairId({
//     required BuildContext context,
//     required int tableIndex,
//     required int tbChrIndexInDb, //this oly for updating purpose
//     required int tableId,
//     required String position,
//     required int chrIndex,
//     required int kotId,
//   }) {
//     Map<String, dynamic> selectedTable = {
//       'tableIndex': tableIndex,
//       'tableId': tableId,
//       'position': position,
//       'chrIndex': chrIndex
//     };
//
//     if (chairShiftMode == true) {
//       shiftChairAlert(
//         //this details in new chair details for updating the shift
//         context: context,
//         tableId: tableId,
//         chrIndex: chrIndex,
//         tableIndex: tableIndex,
//         position: position,
//         kotId: kotId,
//       );
//     } else if (linkChairMode == true) {
//       linkChairAlert(context: context, tableId: tableId, chrIndex: chrIndex, position: position, kotId: singleKitchenOrder.Kot_id);
//     } else {
//       //no order in that chair
//       if (kotId == -1) {
//         //if navigation from order view screen for adding  chair in kot
//         if(kotIdFromOrderManageAlertGb != -1){
//           addChairToKotAlert(context: context, tableId: tableId, chrIndex: chrIndex, position: position, kotId: kotIdFromOrderManageAlertGb);
//
//         }
//         else{
//           Get.offNamed(RouteHelper.getDiningBillingScreen(), arguments: {'selectedTable': selectedTable, 'roomId': _roomId});
//         }
//
//       } else {
//         //to get order of chair in this kot
//         getKotOrderListFromKotId(kotId);
//         viewOrderInTableAlert(kotId: kotId, tbChrIndexInDb: tbChrIndexInDb, context: context);
//       }
//     }
//   }
//
//   //link order to chair//
//
//   updateLinkChairMode(bool linkChairMode) {
//     _linkChairMode = linkChairMode;
//     update();
//   }
//
//   linkChairAlert({
//     required BuildContext context,
//     required int kotId,
//     required int tableId,
//     required int chrIndex,
//     required String position,
//   }) {
//     generalConfirmAlert(
//       context: context,
//       title: 'Link this chair ?',
//       desc: 'do you want to link the this chair ?',
//       onTap: () {
//         addLinkChair(newChrIndex: chrIndex, newPosition: position, newTableId: tableId, kotId: kotId, fdShopId: 10);
//       },
//       onTapCancel: () {},
//     );
//   }
//
// //add link chair to server
//   Future addLinkChair({
//     required int newTableId,
//     required String newPosition,
//     required int newChrIndex,
//     required int kotId,
//     required int fdShopId,
//   }) async {
//     try {
//       print('kotId $kotId');
//       if (kotId != -1) {
//         Map<String, dynamic> linkChairData = {
//           'fdShopId': fdShopId,
//           'Kot_id': kotId,
//           'newTableId': newTableId,
//           'newPosition': newPosition,
//           'newChrIndex': newChrIndex,
//         };
//         final response = await _httpService.updateData(LINK_TABLE_CHR, linkChairData);
//
//         FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
//         if (parsedResponse.error) {
//           AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode);
//         } else {
//           AppSnackBar.successSnackBar('Success', parsedResponse.errorCode);
//           //to make this -1 after add chair in koot from kot manage alert
//           //else again it add  to chair
//           kotIdFromOrderManageAlertGb = -1;
//           refreshDatabaseKot();
//           updateLinkChairMode(false);
//           update();
//         }
//       } else {
//         AppSnackBar.errorSnackBar('Error', 'Something wrong !!');
//       }
//     } on DioError catch (e) {
//       AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
//     } catch (e) {
//       rethrow;
//     } finally {
//       update();
//       print('finally');
//       Future.delayed(const Duration(seconds: 1), () {});
//     }
//   }
//
//   //link order to chair//
//
// //add chair to existing kot
//   addChairToKotAlert({
//     required BuildContext context,
//     required int kotId,
//     required int tableId,
//     required int chrIndex,
//     required String position,
//   }) {
//     generalConfirmAlert(
//       context: context,
//       title: 'Link this chair ?',
//       desc: 'do you want to link the this chair ?',
//       onTap: () {
//         addChairToKot(newChrIndex: chrIndex, newPosition: position, newTableId: tableId, kotId: kotId, fdShopId: 10);
//       },
//       onTapCancel: () {},
//     );
//   }
//
//
//   Future addChairToKot({
//     required int newTableId,
//     required String newPosition,
//     required int newChrIndex,
//     required int kotId,
//     required int fdShopId,
//   }) async {
//     try {
//       print('kotId $kotId');
//       if (kotId != -1) {
//         Map<String, dynamic> linkChairData = {
//           'fdShopId': fdShopId,
//           'Kot_id': kotId,
//           'newTableId': newTableId,
//           'newPosition': newPosition,
//           'newChrIndex': newChrIndex,
//         };
//         final response = await _httpService.updateData(ADD_CHR_TO_KOT, linkChairData);
//
//         FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
//         if (parsedResponse.error) {
//           AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode);
//         } else {
//           AppSnackBar.successSnackBar('Success', parsedResponse.errorCode);
//           //to make this -1 after add chair in koot from kot manage alert
//           //else again it add  to chair
//           kotIdFromOrderManageAlertGb = -1;
//           refreshDatabaseKot();
//           updateLinkChairMode(false);
//           update();
//         }
//       } else {
//         AppSnackBar.errorSnackBar('Error', 'Something wrong !!');
//       }
//     } on DioError catch (e) {
//       AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
//     } catch (e) {
//       rethrow;
//     } finally {
//       update();
//       print('finally');
//       Future.delayed(const Duration(seconds: 1), () {});
//     }
//   }
//
//
//   deleteTable(int id, bool isAnyOrderInTable) async {
//     try {
//       //in table some order is there
//       if (isAnyOrderInTable) {
//         AppSnackBar.errorSnackBar('Orders live in table cannot delete ! ', 'First Delete orders from this table !');
//       } else {
//         Map<String, dynamic> tableData = {
//           'table_id': id,
//           'fdShopId': 10,
//         };
//         final response = await _httpService.delete(DELETE_TABLE, tableData);
//         FoodResponse parsedResponse = FoodResponse.fromJson(response.data);
//         if (parsedResponse.error) {
//           AppSnackBar.errorSnackBar('Error', parsedResponse.errorCode);
//         } else {
//           geTableSetNoRefresh();
//           AppSnackBar.successSnackBar('Success', parsedResponse.errorCode);
//         }
//       }
//     } on DioError catch (e) {
//       AppSnackBar.errorSnackBar('Error', MyDioError.dioError(e));
//     } catch (e) {
//       AppSnackBar.errorSnackBar('Error', 'Something wet to wrong');
//     } finally {
//       update();
//     }
//
//     update();
//   }
//
//   //to add category widget show and hide
//   setAddcategoryToggle(bool val) {
//     addCategoryToggle = val;
//     update();
//   }
//
//   //to change tapped category
//   setCategoryTappedIndex(int val) async {
//     _tappedIndex = val;
//     //to get room id from tapping different room
//     await getRoomId(val);
//     updateTableChairSetWithRoomId(val);
//     update();
//   }
//
//   //this will sort tableset asper room name
//   updateTableChairSetWithRoomId(int roomIndex) {
//     _selecedTableSetLIst.clear();
//     for (var element in _tableSetLIst) {
//       int RoomId = _room?[roomIndex].room_id ?? -1;
//       print(RoomId);
//       if (element.room_id == RoomId) {
//         _selecedTableSetLIst.add(element);
//       }
//     }
//   }
//
//   showLoading() {
//     isLoading = true;
//   }
//
//   hideLoading() {
//     isLoading = false;
//   }
//
//   showLoadingCategory() {
//     isLoadingRoom = true;
//   }
//
//   hideLoadingCategory() {
//     isLoadingRoom = false;
//   }
}
