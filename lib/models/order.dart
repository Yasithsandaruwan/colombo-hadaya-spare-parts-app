class OrderModel {
  String itemName;
  int quantity;
  String shopName;
  String status;

  OrderModel({
    required this.itemName,
    required this.quantity,
    required this.shopName,
    this.status = "pending",
  });
}