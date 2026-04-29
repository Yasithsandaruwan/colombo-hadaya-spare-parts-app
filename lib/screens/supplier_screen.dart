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
    TextEditingController priceController = TextEditingController();
    TextEditingController qtyController =
        TextEditingController(text: order.quantity.toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Purchase Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Unit Price",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Bought Quantity",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              double price =
                  double.tryParse(priceController.text) ?? 0;
              int qty =
                  int.tryParse(qtyController.text) ?? order.quantity;

              setState(() {
                order.purchasePrice = price;
                order.quantity = qty;
                order.status = "purchased";
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void markNotAvailable(OrderModel order) async {
    if (order.status == "purchased") {
      final confirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Warning"),
          content: const Text(
              "This item is already purchased. Mark as not available?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No")),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Yes")),
          ],
        ),
      );

      if (confirm != true) return;
    }

    setState(() {
      order.status = "not_available";
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = OrderService.getGroupedBySupplier();

    return Scaffold(
      appBar: AppBar(title: const Text("Supplier Management")),
      backgroundColor: Colors.grey[100],

      body: ListView(
        children: grouped.entries.map((entry) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ExpansionTile(
              title: Text(entry.key),
              children: [

                // Table Header
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: Row(
                    children: const [
                      Expanded(flex: 3, child: Text("Item")),
                      Expanded(child: Text("Buy")),
                      Expanded(child: Text("NA")),
                    ],
                  ),
                ),

                // Items
                ...entry.value.map((o) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(o.itemName)),

                        Expanded(
                          child: Checkbox(
                            value: o.status == "purchased",
                            onChanged: (_) => markAsPurchased(o),
                          ),
                        ),

                        Expanded(
                          child: Checkbox(
                            value: o.status == "not_available",
                            onChanged: (_) => markNotAvailable(o),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}