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
      body: ListView(
        children: grouped.entries.map((entry) {

          double total = 0;
          for (var o in entry.value) {
            if (o.status == "purchased" && o.purchasePrice != null) {
              total += o.purchasePrice!;
            }
          }

          return ExpansionTile(
            title: Text(entry.key),
            subtitle: Text("Total: Rs. ${total.toStringAsFixed(2)}"),
            children: entry.value.map((order) {
              return ListTile(
                title: Text(order.itemName),
                trailing: Checkbox(
                  value: order.isDelivered,
                  onChanged: (value) {
                    setState(() {
                      order.isDelivered = value ?? false;
                    });
                  },
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}