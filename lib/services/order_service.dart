import '../models/order.dart';

class OrderService {
  static List<OrderModel> orders = [];

  static void addOrder(OrderModel order) {
    orders.add(order);
  }

  // 🔥 GROUP BY SUPPLIER (basic logic)
  static Map<String, List<OrderModel>> getGroupedBySupplier() {
    Map<String, List<OrderModel>> grouped = {};

    for (var order in orders) {
      String supplier = getSupplier(order.itemName);

      if (!grouped.containsKey(supplier)) {
        grouped[supplier] = [];
      }

      grouped[supplier]!.add(order);
    }

    return grouped;
  }

  // 🔥 SIMPLE CATEGORY LOGIC
  static String getSupplier(String item) {
    item = item.toLowerCase();

    if (item.contains("display") || item.contains("screen")) {
      return "Display Supplier";
    } else if (item.contains("battery")) {
      return "Battery Supplier";
    } else if (item.contains("charging")) {
      return "Charging Parts Supplier";
    } else if (item.contains("ic")) {
      return "IC Supplier";
    } else {
      return "Other Supplier";
    }
  }
}