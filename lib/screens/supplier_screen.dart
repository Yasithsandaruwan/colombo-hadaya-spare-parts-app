import 'package:flutter/material.dart';
import '../services/order_service.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  @override
  Widget build(BuildContext context) {
    final grouped = OrderService.getGroupedBySupplier();

    return Scaffold(
      appBar: AppBar(title: const Text("Supplier Purchase List")),
      body: ListView(
        children: grouped.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key),
            children: entry.value.map((order) {
              return ListTile(
                title: Text(
                  order.itemName,
                  style: TextStyle(
                    color: order.status == "purchased"
                        ? Colors.green
                        : order.status == "not_available"
                            ? Colors.red
                            : Colors.black,
                  ),
                ),
                subtitle: Text(order.shopName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("x${order.quantity}"),
                    const SizedBox(width: 10),

                    // ✅ Purchased
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          order.status = "purchased";
                        });
                      },
                    ),

                    // ❌ Not Available
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          order.status = "not_available";
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}