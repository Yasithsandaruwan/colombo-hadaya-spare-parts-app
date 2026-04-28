class OrderModel {
  String itemName;
  int quantity;
  String shopName;
  String? status; // can be null

  OrderModel({
    required this.itemName,
    required this.quantity,
    required this.shopName,
    this.status, // default = null
  });
}