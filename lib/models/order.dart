class PurchaseRecord {
  String supplierName;
  int quantity;
  double unitPrice;

  PurchaseRecord({
    required this.supplierName,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;

  Map<String, dynamic> toJson() {
    return {
      "supplierName": supplierName,
      "quantity": quantity,
      "unitPrice": unitPrice,
    };
  }

  static PurchaseRecord fromJson(Map<String, dynamic> json) {
    return PurchaseRecord(
      supplierName: json["supplierName"] ?? "",
      quantity: (json["quantity"] ?? 0) as int,
      unitPrice: (json["unitPrice"] ?? 0).toDouble(),
    );
  }
}

class OrderModel {
  String? id;
  String itemName;
  int quantity; // original ordered quantity
  String shopName;
  DateTime createdAt;
  DateTime scheduledFor;
  DateTime? deliveredAt;

  String? status;

  List<PurchaseRecord> purchases; // NEW

  OrderModel({
    this.id,
    required this.itemName,
    required this.quantity,
    required this.shopName,
    DateTime? createdAt,
    DateTime? scheduledFor,
    DateTime? deliveredAt,
    this.status,
    List<PurchaseRecord>? purchases,
  })  : createdAt = createdAt ?? DateTime.now(),
        scheduledFor = scheduledFor ?? _scheduleFor(createdAt ?? DateTime.now()),
        deliveredAt = deliveredAt,
        purchases = purchases ?? [];

  Map<String, dynamic> toJson() {
    return {
      "itemName": itemName,
      "quantity": quantity,
      "shopName": shopName,
      "createdAt": createdAt.toIso8601String(),
      "scheduledFor": scheduledFor.toIso8601String(),
      "deliveredAt": deliveredAt?.toIso8601String(),
      "status": status,
      "purchases": purchases.map((p) => p.toJson()).toList(),
    };
  }

  static OrderModel fromJson(Map<String, dynamic> json, {String? id}) {
    final purchasesJson = (json["purchases"] as List<dynamic>?) ?? [];
    final createdAt = DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now();
    final scheduledFor = DateTime.tryParse(json["scheduledFor"] ?? "") ??
        _scheduleFor(createdAt);
    final deliveredAt = DateTime.tryParse(json["deliveredAt"] ?? "");
    return OrderModel(
      id: id,
      itemName: json["itemName"] ?? "",
      quantity: (json["quantity"] ?? 0) as int,
      shopName: json["shopName"] ?? "",
      createdAt: createdAt,
      scheduledFor: scheduledFor,
      deliveredAt: deliveredAt,
      status: json["status"],
      purchases: purchasesJson
          .map((p) => PurchaseRecord.fromJson(Map<String, dynamic>.from(p)))
          .toList(),
    );
  }

  //  TOTAL PURCHASED
  int get purchasedQuantity =>
      purchases.fold(0, (sum, p) => sum + p.quantity);

  //  REMAINING
  int get remainingQuantity => quantity - purchasedQuantity;

  //  TOTAL PRICE
  double get totalPrice =>
      purchases.fold(0, (sum, p) => sum + p.total);

  bool get isCompleted => remainingQuantity <= 0;

  bool get isDelivered => deliveredAt != null;

  void markDelivered() {
    deliveredAt = DateTime.now();
  }

  //  ADD PURCHASE
  void addPurchase({
    required String supplierName,
    required int qty,
    required double unitPrice,
  }) {
    if (qty <= 0) return;

    if (qty > remainingQuantity) {
      qty = remainingQuantity;
    }

    purchases.add(
      PurchaseRecord(
        supplierName: supplierName,
        quantity: qty,
        unitPrice: unitPrice,
      ),
    );

    _updateStatus();
  }

  //  REMOVE PURCHASE 
  void removePurchaseFromSupplier(String supplierName) {
    purchases.removeWhere((p) => p.supplierName == supplierName);
    _updateStatus();
  }

  void _updateStatus() {
    if (purchasedQuantity == 0) {
      status = "pending";
    } else if (remainingQuantity == 0) {
      status = "completed";
    } else {
      status = "partial";
    }
  }

  static DateTime _scheduleFor(DateTime createdAt) {
    final cutoff = DateTime(
      createdAt.year,
      createdAt.month,
      createdAt.day,
      14,
      0,
    );
    final baseDay = createdAt.isAfter(cutoff)
        ? DateTime(createdAt.year, createdAt.month, createdAt.day + 1)
        : DateTime(createdAt.year, createdAt.month, createdAt.day);
    return DateTime(baseDay.year, baseDay.month, baseDay.day);
  }
}