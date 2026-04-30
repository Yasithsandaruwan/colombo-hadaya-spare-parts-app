import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import 'analytics_screen.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  @override
  Widget build(BuildContext context) {
    final grouped = OrderService.getOrdersByShop();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Summary"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF263238),
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Done Delivering?"),
                  content: const Text("Are you sure deliveries are complete?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnalyticsScreen(),
                  ),
                );
              }
            },
            child: const Text("Done Delivering?"),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF3F5F8),

      body: grouped.isEmpty
          ? const Center(child: Text("No Orders Yet"))
          : ListView(
              children: grouped.entries.map((entry) {

                // ✅ FIXED TOTAL CALCULATION
                double total = entry.value.fold(
                  0,
                  (sum, o) => sum + o.totalPrice,
                );
                total += 1000;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(entry.key),
                    subtitle: Text(
                      "Total: Rs. ${total.toStringAsFixed(2)}",
                    ),

                    children: entry.value.map((o) {
                      return ListTile(
                        title: Text(o.itemName),

                        subtitle: Text(
                          o.remainingQuantity > 0
                              ? "Ordered: ${o.quantity} | Buy ${o.remainingQuantity} more"
                              : "Ordered: ${o.quantity} | fulfilled",
                        ),

                        trailing: Text(
                          "Rs. ${o.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList()
                      ..add(
                        const ListTile(
                          title: Text("Delivery Charge"),
                          trailing: Text(
                            "Rs. 1000.00",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}