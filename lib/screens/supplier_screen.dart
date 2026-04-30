import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {

  // 🔥 BUY FROM SUPPLIER
  void markAsPurchased(OrderModel order, String supplierName) async {

    TextEditingController priceController = TextEditingController();
    TextEditingController qtyController =
        TextEditingController(text: order.remainingQuantity.toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Buy from $supplierName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Unit Price"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantity"),
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
                  int.tryParse(qtyController.text) ?? 0;

              if (qty <= 0) return;

              setState(() {
                order.addPurchase(
                  supplierName: supplierName,
                  qty: qty,
                  unitPrice: price,
                );
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // 🔥 UNDO ONLY THIS SUPPLIER
  void undoPurchase(OrderModel order, String supplierName) async {

    final hasPurchase = order.purchases
        .any((p) => p.supplierName == supplierName);

    if (!hasPurchase) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No purchase from this supplier")),
      );
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Undo Purchase"),
        content: Text("Remove items bought from $supplierName?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes")),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      order.removePurchaseFromSupplier(supplierName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = OrderService.getGroupedBySupplier();

    return Scaffold(
      appBar: AppBar(title: const Text("Supplier Management")),
      backgroundColor: const Color(0xFFF5F7FB),

      body: grouped.isEmpty
          ? const Center(child: Text("No Orders Yet"))
          : ListView(
              children: grouped.entries.map((entry) {
                final supplierName = entry.key;

                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ExpansionTile(
                    title: Text(
                      supplierName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    children: [

                      // HEADER
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: Text("Item")),
                            Expanded(child: Text("Buy")),
                            Expanded(child: Text("Undo")),
                          ],
                        ),
                      ),

                      // ITEMS
                      ...entry.value.map((o) {

                        final purchasedHere = o.purchases
                            .any((p) => p.supplierName == supplierName);

                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [

                              // ITEM
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      o.itemName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    Text(
                                      "Remaining: ${o.remainingQuantity}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),

                                    if (o.isCompleted)
                                      const Text(
                                        "Completed",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12),
                                      ),
                                  ],
                                ),
                              ),

                              // BUY BUTTON
                              Expanded(
                                child: Checkbox(
                                  value: purchasedHere,
                                  onChanged: (_) =>
                                      markAsPurchased(o, supplierName),
                                ),
                              ),

                              // UNDO BUTTON
                              Expanded(
                                child: Checkbox(
                                  value: false,
                                  onChanged: (_) =>
                                      undoPurchase(o, supplierName),
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