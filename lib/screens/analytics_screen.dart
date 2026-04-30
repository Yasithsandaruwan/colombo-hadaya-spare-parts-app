import 'package:flutter/material.dart';
import '../services/order_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderService.orders;
    final today = DateTime.now();

    final failedItems =
      orders.where((o) => o.remainingQuantity > 0).toList();

    final shopTotals = OrderService.getTotalPerShop();
    final deliveredShopSet = OrderService.getDeliveredShopSet(today);
    final deliveredShops = OrderService.getDeliveredShopCount(today);
    final totalShops = OrderService.getTotalShopCount(today);
    final totalSpent = OrderService.getTotalSpentForDate(today);
    final totalGain = OrderService.getTotalGainForDate(today);
    final netRevenue = deliveredShops * 1000;
    final successRate = totalShops == 0
        ? 0
        : ((deliveredShops / totalShops) * 100).toStringAsFixed(0);
    final outstanding = OrderService.getOutstandingAmount(today);

    return Scaffold(
      appBar: AppBar(title: const Text("End of Day Report")),
      backgroundColor: Colors.grey[100],

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [

          buildSectionTitle("Failed Items"),

          ...failedItems.map((o) {
            return Card(
              child: ListTile(
                title: Text(o.itemName),
                subtitle: Text("${o.shopName} • Remaining: ${o.remainingQuantity}"),
              ),
            );
          }),

          buildSectionTitle("Shop Billing"),

          ...shopTotals.entries.map((e) {
            final isDelivered = deliveredShopSet.contains(e.key);
            return Card(
              child: ListTile(
                title: Text(
                  e.key,
                  style: TextStyle(
                    color: isDelivered ? null : Colors.red,
                    fontWeight: isDelivered ? null : FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  "Rs. ${e.value.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: isDelivered ? null : Colors.red,
                    fontWeight: isDelivered ? null : FontWeight.w600,
                  ),
                ),
              ),
            );
          }),

          buildSectionTitle("Delivery Summary"),

          Card(
            child: ListTile(
              title: const Text("My Net Revenue"),
              trailing: Text("Rs. $netRevenue"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Delivery Success Rate"),
              trailing: Text("$successRate%"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Total Spent"),
              trailing: Text("Rs. ${totalSpent.toStringAsFixed(2)}"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Total Gain"),
              trailing: Text("Rs. ${totalGain.toStringAsFixed(2)}"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Outstanding Amount"),
              trailing: Text("Rs. ${outstanding.toStringAsFixed(2)}"),
            ),
          ),
        ],
      ),
    );
  }
}