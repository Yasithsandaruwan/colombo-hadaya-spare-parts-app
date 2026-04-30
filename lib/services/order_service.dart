import '../models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static bool _loaded = false;

  static Future<void> init() async {
    if (_loaded) return;
    await loadOrders();
    await loadShopContacts();
    _loaded = true;
  }

  static Future<void> addOrder(OrderModel order) async {
    try {
      final doc = await _db.collection("orders").add(order.toJson());
      order.id = doc.id;
    } catch (_) {
      // Keep local data even if cloud write fails.
    }
    orders.add(order);
  }

  static Future<void> saveOrder(OrderModel order) async {
    if (order.id == null) return;
    try {
      await _db.collection("orders").doc(order.id).set(order.toJson());
    } catch (_) {
      // Keep local data even if cloud write fails.
    }
  }

  static Future<void> saveDraft(String shopName, List<OrderModel> items) async {
    try {
      await _db.collection("draftOrders").doc(shopName).set({
        "items": items.map((o) => o.toJson()).toList(),
        "updatedAt": DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Ignore draft save failures.
    }
  }

  static Future<List<OrderModel>> loadDraft(String shopName) async {
    try {
      final doc = await _db.collection("draftOrders").doc(shopName).get();
      if (!doc.exists) return [];
      final data = doc.data();
      final items = (data?["items"] as List<dynamic>? ?? []);
      return items
          .map((item) => OrderModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clearDraft(String shopName) async {
    try {
      await _db.collection("draftOrders").doc(shopName).delete();
    } catch (_) {
      // Ignore draft delete failures.
    }
  }

  // ---------------- SUPPLIERS ----------------

  static List<SupplierModel> suppliers = [
    SupplierModel(name: "Trans Asia Cellular", keywords: [
      "screen", "display", "oled", "lcd", "battery", "charging", "camera",
      "fingerprint", "speaker", "microphone", "vibration", "antenna", "sim",
      "charger", "cable", "tempered", "cover", "bluetooth", "power bank",
      "earphone", "earphones", "headphone", "headphones", "3.5mm",
      "audio jack", "aux", "usb", "type c", "usb-c", "otg",
      "adapter", "case", "back cover", "screen protector", "glass"
    ]),
    SupplierModel(name: "Asia Cellular", keywords: [
      "screen", "battery", "charging", "camera", "speaker", "sim", "charger",
      "earphone", "headphone", "3.5mm", "audio jack", "cable", "adapter"
    ]),
    SupplierModel(name: "Star Cellular", keywords: [
      "screen", "battery", "charging", "camera", "speaker", "microphone",
      "earpiece", "earphone", "audio jack", "usb"
    ]),
    SupplierModel(name: "Global Cellular", keywords: [
      "screen", "battery", "charging", "camera", "sim", "accessory",
      "headphone", "earphone", "power bank", "cable", "adapter"
    ]),
    SupplierModel(name: "Prime Cellular", keywords: [
      "screen", "battery", "charging", "charger", "cable",
      "power bank", "type c", "usb-c", "adapter", "car charger"
    ]),
    SupplierModel(name: "Pettah Cellular", keywords: [
      "screen", "battery", "charging", "camera", "frame", "fingerprint",
      "power bank", "back cover", "tempered", "screen protector"
    ]),
    SupplierModel(name: "Pettah Accessories Hub", keywords: [
      "power bank", "charger", "adapter", "car charger", "cable",
      "type c", "usb-c", "lightning", "earphone", "earphones",
      "headphone", "headphones", "3.5mm", "audio jack", "aux",
      "case", "cover", "back cover", "tempered", "screen protector"
    ]),
    SupplierModel(name: "Pettah Display Center", keywords: [
      "screen", "display", "oled", "lcd", "touch", "glass",
      "screen glass", "digitizer", "frame"
    ]),
    SupplierModel(name: "Pettah Charging & Flex", keywords: [
      "charging port", "usb port", "connector", "charging flex",
      "usb flex", "flex cable", "sub board", "battery flex"
    ]),
    SupplierModel(name: "Pettah Audio Parts", keywords: [
      "speaker", "loudspeaker", "earpiece", "microphone", "mic",
      "audio ic", "headphone", "earphone", "audio jack"
    ]),
    SupplierModel(name: "Pettah IC & Board", keywords: [
      "ic", "chip", "pmic", "cpu", "emmc", "eprom", "board",
      "main board", "motherboard", "logic board", "bga", "reball"
    ]),
    SupplierModel(name: "Pettah Tools & Repair", keywords: [
      "tool", "tools", "screw", "screwdriver", "tweezer", "spudger",
      "adhesive", "glue", "tape", "solder", "flux", "rework", "hot air"
    ]),
    SupplierModel(name: "Lanka Mobile Parts", keywords: [
      "screen", "battery", "charging", "camera", "speaker", "microphone",
      "power bank", "vibration", "earpiece", "audio jack"
    ]),
    SupplierModel(name: "Mobile Parts Hub", keywords: [
      "screen", "battery", "charging", "camera", "tools",
      "screw", "tweezer", "spudger", "adhesive", "glue"
    ]),
    SupplierModel(name: "Smart Tech Parts", keywords: [
      "screen", "battery", "ic", "camera", "smd",
      "pmic", "charging ic", "audio ic", "connector"
    ]),
    SupplierModel(name: "Tech Parts Lanka", keywords: [
      "screen", "battery", "charging", "camera", "ic",
      "charging port", "usb port", "connector", "flex"
    ]),
    SupplierModel(name: "City Spare Parts", keywords: [
      "screen", "battery", "charging", "camera", "tools",
      "tempered", "case", "cover", "earphone", "power bank"
    ]),
    SupplierModel(name: "IC Tech Lanka", keywords: [
      "ic", "smd", "chip", "resistor", "capacitor",
      "inductor", "diode", "mosfet", "transistor"
    ]),
    SupplierModel(name: "Mobile Chip Center", keywords: [
      "ic", "cpu", "board", "chip", "emmc", "eprom"
    ]),
    SupplierModel(name: "Micro Electronics", keywords: [
      "ic", "smd", "solder", "flux", "rework", "hot air"
    ]),
    SupplierModel(name: "Smart IC Solutions", keywords: [
      "ic", "repair", "solder", "reball", "bga"
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

  static Future<void> saveShopContact(String shopName, String phone) async {
    shopContacts[shopName] = phone;
    try {
      await _db.collection("shopContacts").doc(shopName).set({
        "phone": phone,
        "updatedAt": DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Keep local data even if cloud write fails.
    }
  }

  static Future<void> loadOrders() async {
    try {
      final snapshot = await _db.collection("orders").get();
      orders = snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data(), id: doc.id))
          .toList();
    } catch (_) {
      // Ignore load errors and keep existing in-memory list.
    }
  }

  static Future<void> loadShopContacts() async {
    try {
      final snapshot = await _db.collection("shopContacts").get();
      shopContacts = {
        for (final doc in snapshot.docs)
          doc.id: (doc.data()["phone"] ?? "") as String,
      };
    } catch (_) {
      // Ignore load errors and keep existing in-memory map.
    }
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

  // ---------------- REPORTING ----------------

  static List<OrderModel> getOrdersInRange(DateTime from, DateTime to) {
    return orders
        .where((o) => !o.createdAt.isBefore(from) && o.createdAt.isBefore(to))
        .toList();
  }

  static Map<String, int> getMostRequestedItemsInRange(
    DateTime from,
    DateTime to,
  ) {
    Map<String, int> count = {};

    for (var order in getOrdersInRange(from, to)) {
      count[order.itemName] =
          (count[order.itemName] ?? 0) + order.quantity;
    }

    var sorted = Map.fromEntries(
      count.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    return sorted;
  }

  static List<String> getStockSuggestions({
    required DateTime from,
    required DateTime to,
    int topN = 3,
    int minCount = 3,
  }) {
    final items = getMostRequestedItemsInRange(from, to);
    final suggestions = <String>[];

    for (final entry in items.entries) {
      if (entry.value < minCount) continue;
      suggestions.add(entry.key);
      if (suggestions.length >= topN) break;
    }

    return suggestions;
  }
}