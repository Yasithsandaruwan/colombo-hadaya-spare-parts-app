import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  void markAsPurchased(OrderModel order) async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Price"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                order.status = "purchased";
                order.purchasePrice = double.tryParse(controller.text) ?? 0;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = OrderService.getGroupedBySupplier();

    return Scaffold(
      appBar: AppBar(title: const Text("Suppliers")),
      body: ListView(
        children: grouped.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key),
            children: entry.value.map((o) {
              return Card(
                margin: const EdgeInsets.all(6),
                child: ListTile(
                  title: Text(o.itemName),
                  subtitle: Text(o.shopName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => markAsPurchased(o),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() => o.status = "not_available");
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
