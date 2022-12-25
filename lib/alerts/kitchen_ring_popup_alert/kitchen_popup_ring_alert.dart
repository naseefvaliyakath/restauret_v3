import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_verision_3/alerts/kitchen_ring_popup_alert/kitcheOrderPopupAlertBody.dart';

import '../../models/kitchen_order_response/kitchen_order.dart';

void kitchenRingPopupAlert(KitchenOrder kitchenOrder) {
  Get.defaultDialog(
      title: '',
      backgroundColor: Colors.transparent,
      content: KitchenOrderPopupAlertBody( kitchenOrder: kitchenOrder)
  );
}

