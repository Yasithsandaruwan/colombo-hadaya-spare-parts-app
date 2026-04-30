import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';

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
      appBar: AppBar(title: const Text("Delivery Summary")),
      backgroundColor: Colors.grey[100],

      body: grouped.isEmpty
          ? const Center(child: Text("No Orders Yet"))
          : ListView(
              children: grouped.entries.map((entry) {

                // ✅ FIXED TOTAL CALCULATION
                double total = entry.value.fold(
                  0,
                  (sum, o) => sum + o.totalPrice,
                );

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
                          "Ordered: ${o.quantity} | Remaining: ${o.remainingQuantity}",
                        ),

                        trailing: Text(
                          "Rs. ${o.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}