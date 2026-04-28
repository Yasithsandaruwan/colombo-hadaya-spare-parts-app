import 'package:flutter/material.dart';
import '../services/order_service.dart';

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
      appBar: AppBar(title: const Text("Delivery")),
      body: ListView(
        children: grouped.entries.map((entry) {
          double total = entry.value
              .where((o) => o.purchasePrice != null)
              .fold(0, (sum, o) => sum + o.purchasePrice!);

          return Card(
            margin: const EdgeInsets.all(10),
            child: ExpansionTile(
              title: Text(entry.key),
              subtitle: Text("Rs. ${total.toStringAsFixed(2)}"),
              children: entry.value.map((o) {
                return CheckboxListTile(
                  value: o.isDelivered,
                  title: Text(o.itemName),
                  onChanged: (v) => setState(() => o.isDelivered = v!),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
