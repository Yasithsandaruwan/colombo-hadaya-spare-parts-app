import 'package:flutter/material.dart';
import '../services/order_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderService.orders;

    final failedItems =
        orders.where((o) => o.status != "purchased").toList();

    final shopTotals = OrderService.getTotalPerShop();

    return Scaffold(
      appBar: AppBar(title: const Text("End of Day Report")),
      backgroundColor: Colors.grey[100],

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [

          const Text("Failed Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          ...failedItems.map((o) {
            return Card(
              child: ListTile(
                title: Text(o.itemName),
                subtitle: Text(o.shopName),
              ),
            );
          }),

          const SizedBox(height: 20),

          const Text("Shop Billing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          ...shopTotals.entries.map((e) {
            return Card(
              child: ListTile(
                title: Text(e.key),
                trailing:
                    Text("Rs. ${e.value.toStringAsFixed(2)}"),
              ),
            );
          }),
        ],
      ),
    );
  }
}