class OrdersByType {
  OrdersByType({required this.type, required this.orderCount, required this.priceTotal});

  final String type;
  final num orderCount;
  final num priceTotal;
}

class OrdersByPaymentMethod {
  OrdersByPaymentMethod({required this.priceTotal, required this.paymentMethod, required this.orderCount});

  final String paymentMethod;
  final num orderCount;
  final num priceTotal;
}

class OrdersByOnlineApp {
  OrdersByOnlineApp({required this.appName, required this.orderCount, required this.priceTotal});

  final String appName;
  final num orderCount;
  final num priceTotal;
}

class OrdersByFoodName {
  OrdersByFoodName({required this.title, required this.qtyTotal, required this.priceTotal});

  final String title;
  final num qtyTotal;
  final num priceTotal;
}