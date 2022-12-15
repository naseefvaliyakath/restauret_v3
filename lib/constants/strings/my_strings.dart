import 'package:rest_verision_3/models/notice_and_update/notice_and_update.dart';
import 'package:rest_verision_3/models/shop_response/shop.dart';

import '../../models/kitchen_order_response/kitchen_order.dart';

const String SCREEN_TODAY = 'todayFoodScreen';
const String SCREEN_ALLFOOD = 'allFoodScreen';
const String CREDIT_USER_SCREEN = 'creditUserScreen';


const String COMMON_CATEGORY = 'COMMON';

const String IMG_LINK = 'https://mobizate.com/uploads/sample.jpg';
const String PENDING = 'pending';
const String COMPLETE = 'complete';
const String PROGRESS = 'progress';
const String READY = 'ready';
const String REJECT = 'reject';


const String TAKEAWAY = 'Takeaway';
const String HOME_DELEVERY = 'Home delivery';
const String ONLINE = 'online';
const String DINING = 'Dining';

const String BILLING_SCREEN = 'billing';
const String ORDER_VIEW_SCREEN = 'orderView';

const String TAKEAWAY_SCREEN_NAME = 'Takeaway billing';
const String HOME_DELEVERY_SCREEN_NAME = 'Home delivery';
const String ONLINE_SCREEN_NAME = 'Online delivery';
const String DINING_SCREEN_NAME = 'Dining billing';

const String NO_ONLINE_APP = 'no_app';
const String MAIN_ROOM = 'main_room';

const String CASH = 'cash';
const String CARD = 'card';
const String ONLINE_PAY = 'online';
const String PENDINGCASH = 'pending';
const String TYPE_1 = 'type-1';
const String TYPE_2 = 'type-2';

KitchenOrder EMPTY_KITCHEN_ORDER = KitchenOrder(
  Kot_id: -1,
  error: true,
  errorCode: 'SomethingWrong',
  totalSize: 0,
  fdOrderStatus: PENDING,
  fdOrderType: TAKEAWAY,
  fdOrder: [],
  fdShopId: -1,
  totalPrice: 0,
  orderColor: 111,
  fdDelAddress: {'name': '', 'number': 0, 'address': ''},
);

Shop EMPTY_SHOP = Shop(-1, 'error', 0000, 'error', 2,'0000', '0000',DateTime.now(),'https://mobizate.com/uploadsOnlineApp/logo_hotel.png');

NoticeAndUpdate EMPTY_NOTICE_UPDATE = NoticeAndUpdate(-1,'notice', ['0.0.0','0.0.0','0.0.0'], ['ios','android','windows'], [5,10,15,20], DateTime.now(), true, 'error');

List<int> TABLE_NUMBER = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];

List<int> CHAIR_NUMBER = [1,2,3,4,5,6,7,8,9,10];


List<String> COMPLAINT_TYPE = ['Enquiry','Complaint','Suggestion','Doubt'];

//? used in password prompt as reason
const String EXIT_TO_CASHIER = 'EXIT_TO_CASHIER';
const String ENTER_TO_REPORT = 'ENTER_TO_REPORT';


