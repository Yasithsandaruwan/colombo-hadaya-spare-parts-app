import '../models/order.dart';

class OrderService {
  static List<OrderModel> orders = [];

  // Add order (used by UI)
  static void addOrder(OrderModel order) {
    orders.add(order);
  }

  // Clear all orders (useful after submit or testing)
  static void clearOrders() {
    orders.clear();
  }

  // Group orders by supplier
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

  // Supplier detection logic
  static String getSupplier(String item) {
    String lowerItem = item.toLowerCase();

    if (lowerItem.contains("display") || lowerItem.contains("screen")) {
      return "Display Supplier";
    } else if (lowerItem.contains("battery")) {
      return "Battery Supplier";
    } else if (lowerItem.contains("charging")) {
      return "Charging Parts Supplier";
    } else if (lowerItem.contains("ic")) {
      return "IC Supplier";
    } else {
      return "Other Supplier";
    }
  }

  // Total cost of purchased items
  static double getTotalCost() {
    double total = 0;

    for (var order in orders) {
      if (order.status == "purchased" && order.purchasePrice != null) {
        total += order.purchasePrice!;
      }
    }

    return total;
  }

  // Total cost per shop
  static Map<String, double> getTotalPerShop() {
    Map<String, double> totals = {};

    for (var order in orders) {
      if (order.status == "purchased" && order.purchasePrice != null) {
        totals[order.shopName] =
            (totals[order.shopName] ?? 0) + order.purchasePrice!;
      }
    }

    return totals;
  }

  // Group orders by shop
  static Map<String, List<OrderModel>> getOrdersByShop() {
    Map<String, List<OrderModel>> grouped = {};

    for (var order in orders) {
      if (!grouped.containsKey(order.shopName)) {
        grouped[order.shopName] = [];
      }

      grouped[order.shopName]!.add(order);
    }

    return grouped;
  }

  // Update order status
  static void updateOrderStatus(OrderModel order, String status) {
    order.status = status;
  }

  // Mark as delivered
  static void markAsDelivered(OrderModel order) {
    order.isDelivered = true;
  }

  // Set purchase price and mark purchased
  static void setPurchase(OrderModel order, double price) {
    order.purchasePrice = price;
    order.status = "purchased";
  }
}