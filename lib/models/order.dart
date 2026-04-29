class OrderModel {
  String itemName;
  int quantity;
  String shopName;
  String? status;

  double? purchasePrice;
  bool isDelivered;

  // Optional: for Firebase document ID
  String? id;

  // Optional: timestamp (useful later)
  DateTime? timestamp;

  OrderModel({
    required this.itemName,
    required this.quantity,
    required this.shopName,
    this.status,
    this.purchasePrice,
    this.isDelivered = false,
    this.id,
    this.timestamp,
  });

  // Convert object to Map (for Firebase or storage)
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'shopName': shopName,
      'status': status,
      'purchasePrice': purchasePrice,
      'isDelivered': isDelivered,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  // Create object from Map (from Firebase)
  factory OrderModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return OrderModel(
      id: documentId,
      itemName: map['itemName'] ?? '',
      quantity: map['quantity'] ?? 0,
      shopName: map['shopName'] ?? '',
      status: map['status'],
      purchasePrice: map['purchasePrice'] != null
          ? (map['purchasePrice'] as num).toDouble()
          : null,
      isDelivered: map['isDelivered'] ?? false,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'])
          : null,
    );
  }
}