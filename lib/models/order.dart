class OrderModel {
  String itemName;
  int quantity;
  String shopName;
  String? status;

  double? purchasePrice;
  bool isDelivered; // 🚚 NEW

  OrderModel({
    required this.itemName,
    required this.quantity,
    required this.shopName,
    this.status,
    this.purchasePrice,
    this.isDelivered = false,
  });
}