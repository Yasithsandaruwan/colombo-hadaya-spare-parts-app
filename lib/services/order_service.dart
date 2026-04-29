import '../models/order.dart';

class OrderService {
  static List<OrderModel> orders = [];

  static void addOrder(OrderModel order) {
    orders.add(order);
  }

  static Map<String, List<OrderModel>> getGroupedBySupplier() {
    Map<String, List<OrderModel>> grouped = {};

    for (var order in orders) {
      String supplier = getSupplier(order.itemName);

      grouped.putIfAbsent(supplier, () => []);
      grouped[supplier]!.add(order);
    }

    return grouped;
  }

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

  static double getTotalCost() {
    double total = 0;

    for (var o in orders) {
      if (o.status == "purchased" && o.purchasePrice != null) {
        total += o.purchasePrice! * o.quantity;
      }
    }

    return total;
  }

  static Map<String, double> getTotalPerShop() {
    Map<String, double> totals = {};

    for (var o in orders) {
      if (o.status == "purchased" && o.purchasePrice != null) {
        totals[o.shopName] =
            (totals[o.shopName] ?? 0) +
                (o.purchasePrice! * o.quantity);
      }
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
}