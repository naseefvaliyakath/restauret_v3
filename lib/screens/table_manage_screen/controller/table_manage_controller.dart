import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/constants/strings/my_strings.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../alerts/show_tables_alert/table_shift_select_alert.dart';
import '../../../api_data_loader/room_data.dart';
import '../../../api_data_loader/table_chair_data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../constants/api_link/api_link.dart';
import '../../../error_handler/error_handler.dart';
import '../../../models/kitchen_order_response/kitchen_order.dart';
import '../../../models/kitchen_order_response/kitchen_order_array.dart';
import '../../../models/my_response.dart';
import '../../../models/room_response/room.dart';
import '../../../models/table_chair_response/table_chair_set.dart';
import '../../../repository/kot_repository.dart';
import '../../../repository/room_repository.dart';
import '../../../routes/route_helper.dart';
import '../../../services/dio_error.dart';
import '../../../services/service.dart';
import '../../../socket/socket_controller.dart';
import '../../../widget/common_widget/snack_bar.dart';
import '../../login_screen/controller/startup_controller.dart';

class TableManageController extends GetxController {
  bool showErr = Get.find<StartupController>().showErr;
  final ErrorHandler errHandler = Get.find<ErrorHandler>();

  final RoomData _roomData = Get.find<RoomData>();
  final RoomRepo _roomRepo = Get.find<RoomRepo>();
  final KotRepo _kotRepo = Get.find<KotRepo>();
  final TableChairSetData _tableChairSetData = Get.find<TableChairSetData>();
  final IO.Socket _socket = Get.find<SocketController>().socket;
  final HttpService _httpService = Get.find<HttpService>();

  bool addCategoryToggle = false; // to show add category or room card and text field
  bool addCategoryLoading = false; // to show progress while adding new category or room
  ScrollController scrollController = ScrollController();

  final RoundedLoadingButtonController btnControllerCancelKotOrderInTable = RoundedLoadingButtonController();

  //? this will store all onlineApp from the server
  //? not showing in UI or change
  final List<Room> _storedRoom = [];

  //? onlineApp to show in UI
  final List<Room> _myRoom = [];

  List<Room> get myRoom => _myRoom;

  final List<TableChairSet> _storedTableChairSet = [];

  //? onlineApp to show in UI
  final List<TableChairSet> _myTableChairSet = [];

  List<TableChairSet> get myTableChairSet => _myTableChairSet;

  final List<KitchenOrder> _kotBillingItems = [];

  List<KitchenOrder> get kotBillingItems => _kotBillingItems;

  //? kot orders only containing tables
  final List<KitchenOrder> tableOrders = [];

  int _tappedIndex = 0;

  //? to pass create table screen
  int selectedRoomId = 0;
  String selectedRoomName = MAIN_ROOM;

  int get tappedIndex => _tappedIndex;

  bool isLoading = false;

  //? for room update need other loader , so after catch isLoading become false so in ctr.list.length may course error
  bool isLoadingRoom = false;

  //? to enable shift mode when click shift mode
  bool shiftMode = false;
  //? to enable link mode when click shift mode
  bool linkMode = false;

  //? to add room name
  late TextEditingController roomNameTD;

  //? saving tableId and tableNumber for shifting.
  int currentTableId = -1;
  int currentTableNumber = -1;
  int kotIdForShiftTable = -1;

  @override
  void onInit() async {
    roomNameTD = TextEditingController();
    await getInitialRoom();
    await getInitialTableChairSet();
    //? for full feature application
    if (Get.find<StartupController>().applicationPlan == 1) {
      _socket.connect();
      setUpKitchenOrderFromDbListener(); //? first load kotBill data from db
    } else {
      getAllKot();
    }
    super.onInit();
  }

  @override
  void onClose() {
    _socket.close();
    _socket.dispose();
    roomNameTD.dispose();
  }

  //? to load o first screen loading
  getInitialRoom() async {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedRoom from RoomData controller
      if (_roomData.allRoom.isEmpty) {
        if (kDebugMode) {
          print(_roomData.allRoom.length);
          print('data loaded from db');
        }
        await refreshRoom(showSnack: false);
      } else {
        if (kDebugMode) {
          print('data loaded from room data');
        }
        //? load data from variable
        _storedRoom.clear();
        _storedRoom.addAll(_roomData.allRoom);
        //? to show room  in UI
        _myRoom.clear();
        _myRoom.addAll(_storedRoom);
        selectedRoomId = _myRoom.first.room_id ?? -1;
        selectedRoomName = _myRoom.first.roomName ?? MAIN_ROOM;
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'getInitialRoom()');
      return;
    } finally {
      update();
    }
  }

  //? this function will call getAllRoom() in RoomData
  refreshRoom({bool showSnack = true}) async {
    try {
      MyResponse response = await _roomData.getAllRoom();
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<Room> rooms = response.data;
          _storedRoom.clear();
          _storedRoom.addAll(rooms);
          //? to show full room in UI
          _myRoom.clear();
          _myRoom.addAll(_storedRoom);
          //? storing room name and id initially
          selectedRoomId = _myRoom.first.room_id ?? -1;
          selectedRoomName = _myRoom.first.roomName ?? MAIN_ROOM;
          //? to hide snack-bar on page starting , because this method is calling page starting
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        //? to hide snack-bar on page starting , because this method is calling page starting
        if (showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'refreshRoom()');
      return;
    } finally {
      update();
    }
  }

  //? to load o first screen loading
  getInitialTableChairSet() async {
    try {
      //?if no data in side data controller
      //? then load fresh data from db
      //?else fill _storedRoom from RoomData controller
      if (_tableChairSetData.allTableChairSet.isEmpty) {
        if (kDebugMode) {
          print('TableChairSet length ${_tableChairSetData.allTableChairSet.length}');
          print('data loaded from db');
        }
        await refreshTableChairSet(showSnack: false);
      } else {
        if (kDebugMode) {
          print('data loaded from room data');
        }
        //? load data from variable
        _storedTableChairSet.clear();
        _storedTableChairSet.addAll(_tableChairSetData.allTableChairSet);
        //? to show room  in UI
        sortTableByRoom(selectedRoomId);
      }
      update();
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'getInitialTableChairSet()');
      return;
    } finally {
      update();
    }
  }

  //? this function will call getAllRoom() in TableChairSet
  refreshTableChairSet({bool showSnack = true}) async {
    try {
      MyResponse response = await _tableChairSetData.getAllTableChairSet();
      if (response.statusCode == 1) {
        if (response.data != null) {
          List<TableChairSet> tables = response.data;
          _storedTableChairSet.clear();
          _storedTableChairSet.addAll(tables);

          //? to show full room in UI
          sortTableByRoom(selectedRoomId);
          //? to hide snack-bar on page starting , because this method is calling page starting
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        //? to hide snack-bar on page starting , because this method is calling page starting
        if (showSnack) {
          AppSnackBar.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'refreshTableChairSet()');
      return;
    } finally {
      update();
    }
  }

  //?insert room
  Future insertRoom() async {
    try {
      addCategoryLoading = true;
      update();
      String roomNameString = '';
      roomNameString = roomNameTD.text;
      if (roomNameString.trim() != '') {
        MyResponse response = await _roomRepo.insertRoom(roomNameString);
        if (response.statusCode == 1) {
          refreshRoom();
          //! snack bar showing when refresh category no need to show here
        } else {
          AppSnackBar.errorSnackBar('Error', response.message);
          return;
        }
      } else {
        AppSnackBar.errorSnackBar('Field is Empty', 'Pleas enter any room name');
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'insertRoom()');
      return;
    } finally {
      roomNameTD.text = '';
      addCategoryLoading = false;
      setAddCategoryToggle(false);
      update();
    }
  }

  // //? to delete the room
  deleteRoom({required int roomId, required String roomName}) async {
    try {
      //? check user try to delete main room
      addCategoryLoading = true;
      update();
      MyResponse response = await _roomRepo.deleteRoom(roomId);
      if (response.statusCode == 1) {
        refreshRoom();
        //! snack bar showing when refreshCategory no need to show here
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
        return;
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'deleteRoom()');
      return;
    } finally {
      addCategoryLoading = false;
      update();
    }
  }

  //? for first load data to bill from data base
  setUpKitchenOrderFromDbListener() {
    try {
      KitchenOrderArray order = KitchenOrderArray(error: true, errorCode: '', totalSize: 0);
      _socket.on('database-data-receive', (data) {
        if (kDebugMode) {
          print('kot data socket database refresh');
        }
        //? this is not single KOT order , its list of orders
        order = KitchenOrderArray.fromJson(data);
        List<KitchenOrder> kitchenOrders = [];
        kitchenOrders.addAll(order.kitchenOrder ?? []);
        //? no error
        bool err = order.error;
        if (!err) {
          //? check if item is already in list
          _kotBillingItems.clear();
          //? adding KOT order by if is exist then not added
          _kotBillingItems.addAll(kitchenOrders);
          update();
        } else {
          return;
        }
      });
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'setUpKitchenOrderFromDbListener()');
      return;
    }
  }

  //? this emit will receive in server and emit from server to refresh data
  refreshDatabaseKot({bool showSnack = true}) {
    if(Get.find<StartupController>().applicationPlan == 1){
      _socket.emit('refresh-database-order',Get.find<StartupController>().SHOPE_ID);
    }
    else{
      getAllKot(showSnack: showSnack);
    }

  }

  getAllKot({bool showSnack = false}) async {
    try {
      MyResponse response = await _kotRepo.getAllKot();
      if (response.statusCode == 1) {
        KitchenOrderArray parsedResponse = response.data;
        if (parsedResponse.kitchenOrder == null) {
          _kotBillingItems;
        } else {
          _kotBillingItems.clear();
          _kotBillingItems.addAll(parsedResponse.kitchenOrder?.toList() ?? []);
          if (showSnack) {
            AppSnackBar.successSnackBar('Success', response.message);
          }
        }
      } else {
        AppSnackBar.errorSnackBar('Error', response.message);
      }
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'getAllKot()');
      return;
    } finally {
      update();
    }
  }

  //to add category widget show and hide
  setAddCategoryToggle(bool val) {
    addCategoryToggle = val;
    update();
  }

  //to change tapped category
  setCategoryTappedIndex(int val) async {
    _tappedIndex = val;
    selectedRoomId = _myRoom.elementAt(val).room_id ?? -1;
    selectedRoomName = _myRoom.elementAt(val).roomName ?? MAIN_ROOM;
    sortTableByRoom(selectedRoomId);
    update();
  }

  sortTableByRoom(int roomId_) {
    List<TableChairSet> sorterTable = [];
    for (var element in _storedTableChairSet) {
      if (element.room_id == roomId_) {
        sorterTable.add(element);
      }
    }
    _myTableChairSet.clear();
    _myTableChairSet.addAll(sorterTable);
    update();
  }

  updateKotOrder({required kotBillingOrder}) {
    //? fromTableManage is to check update kot is from table mange screen , then select table option will disable
    Get.offNamed(RouteHelper.getBillingScreenScreen(), arguments: {'kotItem': kotBillingOrder, 'fromTableManage': 'true'});
  }

  updateShiftMode(bool isShiftMode) {
    shiftMode = isShiftMode;
    update();
  }


  updateLinkMode(bool isLinkMode) {
    linkMode = isLinkMode;
    update();
  }

  saveCurrentTableIdAndTableNumber({
    required int tableId,
    required int tableNumber,
    required int kotId,
  }) {
    currentTableId = tableId;
    currentTableNumber = tableNumber;
    kotIdForShiftTable = kotId;
  }

  shiftOrLinkTable({required int newTableId, required int newTableNumber, required String newRoom,}) {
    if(linkMode){
      updateLinkChair(newTableId: newTableId,newTableNumber: newTableNumber, newRoom: newRoom);
    }else {
      updateShiftedChair(newTableId: newTableId, newTableNumber: newTableNumber, newRoom: newRoom);
    }
  }

  Future updateShiftedChair({
    required int newTableId,
    required int newTableNumber,
    required String newRoom,
  }) async {
    try {
      if (kotIdForShiftTable != -1 && currentTableId != -1 && currentTableNumber != -1) {
        Map<String, dynamic> tableShiftUpdate = {
          'fdShopId': Get.find<StartupController>().SHOPE_ID,
          'Kot_id': kotIdForShiftTable,
          'currentTable': currentTableNumber,
          'currentTableId': currentTableId,
          'newTable': newTableNumber,
          'newTableId': newTableId,
          'newRoom': newRoom,
        };
        final response = await _httpService.updateData(SHIFT_TABLE_CHR, tableShiftUpdate);

        KitchenOrderArray parsedResponse = KitchenOrderArray.fromJson(response.data);
        if (parsedResponse.error) {
          String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
          AppSnackBar.successSnackBar('Success', myMessage);
          refreshDatabaseKot(showSnack: false);
          getInitialTableChairSet();
          updateShiftMode(false);
          currentTableNumber = -1;
          currentTableId = -1;
          kotIdForShiftTable = -1;
        } else {
          String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
          AppSnackBar.successSnackBar('Error', myMessage);
        }
      } else {
        AppSnackBar.errorSnackBar('Error !', 'Something wrong');
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      AppSnackBar.errorSnackBar('Error', myMessage);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'shiftChair()');
    } finally {
      update();
    }
  }


  Future updateLinkChair({
    required int newTableId,
    required int newTableNumber,
    required String newRoom,
  }) async {
    try {
      if (kotIdForShiftTable != -1 && currentTableId != -1 && currentTableNumber != -1) {
        Map<String, dynamic> tableShiftUpdate = {
          'fdShopId': Get.find<StartupController>().SHOPE_ID,
          'Kot_id': kotIdForShiftTable,
          'newTable': newTableNumber,
          'newTableId': newTableId,
          'newRoom': newRoom,
        };
        final response = await _httpService.updateData(LINK_TABLE_CHR, tableShiftUpdate);

        KitchenOrderArray parsedResponse = KitchenOrderArray.fromJson(response.data);
        if (parsedResponse.error) {
          String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Updated successfully';
          AppSnackBar.successSnackBar('Success', myMessage);
          refreshDatabaseKot(showSnack: false);
          getInitialTableChairSet();
          updateShiftMode(false);
          currentTableNumber = -1;
          currentTableId = -1;
          kotIdForShiftTable = -1;
        } else {
          String myMessage = showErr ? (parsedResponse.errorCode ?? 'error') : 'Something wrong !!';
          AppSnackBar.successSnackBar('Error', myMessage);
        }
      } else {
        AppSnackBar.errorSnackBar('Error !', 'Something wrong');
      }
    } on DioError catch (e) {
      String myMessage = showErr ? MyDioError.dioError(e) : MyDioError.dioError(e);
      AppSnackBar.errorSnackBar('Error', myMessage);
    } catch (e) {
      String myMessage = showErr ? e.toString() : 'Something wrong !!';
      AppSnackBar.errorSnackBar('Error', myMessage);
      errHandler.myResponseHandler(error: e.toString(), pageName: 'table_manage_controller', methodName: 'shiftChair()');
    } finally {
      update();
    }
  }

  showLoading() {
    isLoading = true;
  }

  hideLoading() {
    isLoading = false;
  }

  showLoadingCategory() {
    isLoadingRoom = true;
  }

  hideLoadingCategory() {
    isLoadingRoom = false;
  }
}
