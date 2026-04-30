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
}

class OrderModel {
  String itemName;
  int quantity; // original ordered quantity
  String shopName;
  DateTime createdAt;

  String? status;

  List<PurchaseRecord> purchases; // 🔥 NEW

  OrderModel({
    required this.itemName,
    required this.quantity,
    required this.shopName,
    DateTime? createdAt,
    this.status,
    List<PurchaseRecord>? purchases,
  })  : createdAt = createdAt ?? DateTime.now(),
        purchases = purchases ?? [];

  // 🔥 TOTAL PURCHASED
  int get purchasedQuantity =>
      purchases.fold(0, (sum, p) => sum + p.quantity);

  // 🔥 REMAINING
  int get remainingQuantity => quantity - purchasedQuantity;

  // 🔥 TOTAL PRICE
  double get totalPrice =>
      purchases.fold(0, (sum, p) => sum + p.total);

  bool get isCompleted => remainingQuantity <= 0;

  // 🔥 ADD PURCHASE
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

  // 🔥 REMOVE PURCHASE (ONLY FROM ONE SUPPLIER)
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
}