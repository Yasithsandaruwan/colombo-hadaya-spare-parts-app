import '../models/order.dart';

class SupplierModel {
  final String name;
  final List<String> keywords;

  SupplierModel({
    required this.name,
    required this.keywords,
  });
}

class OrderService {
  static List<OrderModel> orders = [];

  static void addOrder(OrderModel order) {
    orders.add(order);
  }

  // ---------------- SUPPLIERS ----------------

  static List<SupplierModel> suppliers = [
    SupplierModel(name: "Trans Asia Cellular", keywords: [
      "screen", "display", "oled", "lcd", "battery", "charging", "camera",
      "fingerprint", "speaker", "microphone", "vibration", "antenna", "sim",
      "charger", "cable", "tempered", "cover", "bluetooth", "power bank"
    ]),
    SupplierModel(name: "Asia Cellular", keywords: [
      "screen", "battery", "charging", "camera", "speaker", "sim", "charger"
    ]),
    SupplierModel(name: "Star Cellular", keywords: [
      "screen", "battery", "charging", "camera", "speaker", "microphone"
    ]),
    SupplierModel(name: "Global Cellular", keywords: [
      "screen", "battery", "charging", "camera", "sim", "accessory"
    ]),
    SupplierModel(name: "Prime Cellular", keywords: [
      "screen", "battery", "charging", "charger", "cable"
    ]),
    SupplierModel(name: "Pettah Cellular", keywords: [
      "screen", "battery", "charging", "camera", "frame", "fingerprint", "power bank"
    ]),
    SupplierModel(name: "Lanka Mobile Parts", keywords: [
      "screen", "battery", "charging", "camera", "speaker", "microphone", "power bank"
    ]),
    SupplierModel(name: "Mobile Parts Hub", keywords: [
      "screen", "battery", "charging", "camera", "tools"
    ]),
    SupplierModel(name: "Smart Tech Parts", keywords: [
      "screen", "battery", "ic", "camera", "smd"
    ]),
    SupplierModel(name: "Tech Parts Lanka", keywords: [
      "screen", "battery", "charging", "camera", "ic"
    ]),
    SupplierModel(name: "City Spare Parts", keywords: [
      "screen", "battery", "charging", "camera", "tools"
    ]),
    SupplierModel(name: "IC Tech Lanka", keywords: [
      "ic", "smd", "chip", "resistor", "capacitor"
    ]),
    SupplierModel(name: "Mobile Chip Center", keywords: [
      "ic", "cpu", "board", "chip"
    ]),
    SupplierModel(name: "Micro Electronics", keywords: [
      "ic", "smd", "solder"
    ]),
    SupplierModel(name: "Smart IC Solutions", keywords: [
      "ic", "repair", "solder"
    ]),
  ];

  // ---------------- MATCHING LOGIC ----------------

  static List<String> getAllMatchingSuppliers(String itemName) {
    String item = itemName.toLowerCase();
    List<String> matches = [];

    for (var supplier in suppliers) {
      for (var keyword in supplier.keywords) {
        if (item.contains(keyword)) {
          matches.add(supplier.name);
          break;
        }
      }
    }

    return matches;
  }

  // ---------------- GROUP BY SUPPLIER ----------------

  static Map<String, List<OrderModel>> getGroupedBySupplier() {
    Map<String, List<OrderModel>> grouped = {};

    for (var order in orders) {
      // 🔥 IMPORTANT: only show items that still need buying
      if (order.remainingQuantity <= 0) continue;

      List<String> matchedSuppliers =
          getAllMatchingSuppliers(order.itemName);

      if (matchedSuppliers.isEmpty) {
        grouped.putIfAbsent("Other Supplier", () => []);
        grouped["Other Supplier"]!.add(order);
      } else {
        for (var supplier in matchedSuppliers) {
          grouped.putIfAbsent(supplier, () => []);
          grouped[supplier]!.add(order);
        }
      }
    }

    return grouped;
  }

  // ---------------- ANALYTICS ----------------

  static double getTotalCost() {
    double total = 0;

    for (var o in orders) {
      total += o.totalPrice;
    }

    return total;
  }

  static Map<String, double> getTotalPerShop() {
    Map<String, double> totals = {};

    for (var o in orders) {
      totals[o.shopName] =
          (totals[o.shopName] ?? 0) + o.totalPrice;
    }

    return totals;
  }

  static Map<String, List<OrderModel>> getOrdersByShop() {
    Map<String, List<OrderModel>> grouped = {};

    for (var order in orders) {
      grouped.putIfAbsent(order.shopName, () => []);
      grouped[order.shopName]!.add(order);
    }

    return grouped;
  }

  // STORE SHOP CONTACTS
  static Map<String, String> shopContacts = {};

  static void saveShopContact(String shopName, String phone) {
    shopContacts[shopName] = phone;
  }

  static Map<String, int> getMostRequestedItems() {
    Map<String, int> count = {};

    for (var order in orders) {
      count[order.itemName] =
          (count[order.itemName] ?? 0) + order.quantity;
    }

    // sort descending
    var sorted = Map.fromEntries(
      count.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    return sorted;
  }
}