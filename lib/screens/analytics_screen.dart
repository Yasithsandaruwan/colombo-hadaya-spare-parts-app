import 'package:flutter/material.dart';
import '../services/order_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderService.orders;

    final failedItems =
        orders.where((o) => o.status == "not_available").toList();

    Map<String, int> count = {};
    for (var o in orders) {
      count[o.itemName] = (count[o.itemName] ?? 0) + o.quantity;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("End of Day Report")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("❌ Failed Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Expanded(
              child: ListView(
                children: failedItems.map((o) {
                  return ListTile(
                    title: Text(o.itemName,
                        style: const TextStyle(color: Colors.red)),
                    subtitle: Text("Shop: ${o.shopName}"),
                  );
                }).toList(),
              ),
            ),

            const Divider(),

            const Text("📊 Most Requested Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Expanded(
              child: ListView(
                children: count.entries.map((e) {
                  return ListTile(
                    title: Text(e.key),
                    trailing: Text(e.value.toString()),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}