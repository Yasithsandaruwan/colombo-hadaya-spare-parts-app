import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import 'delivery_screen.dart';

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
    final matchingOrders = OrderService.orders.where((o) {
      return _normalizeItem(o.itemName) == _normalizeItem(order.itemName);
    }).toList();
    final selected = <OrderModel, bool>{
      for (final o in matchingOrders) o: false,
    };

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          int selectedQty = 0;
          for (final entry in selected.entries) {
            if (entry.value) {
              selectedQty += entry.key.remainingQuantity;
            }
          }

          if (selectedQty > 0) {
            qtyController.text = selectedQty.toString();
          }

          return AlertDialog(
            title: Text("Buy from $supplierName"),
            content: SingleChildScrollView(
              child: Column(
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
                    readOnly: selectedQty > 0,
                    decoration: const InputDecoration(labelText: "Quantity"),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Shop orders",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...matchingOrders.map((o) {
                    final label = o.isCompleted
                        ? "Completed x ${o.quantity}"
                        : o.purchasedQuantity > 0
                            ? "Buy ${o.remainingQuantity} more"
                            : "Buy ${o.remainingQuantity}";
                    return CheckboxListTile(
                      value: selected[o] ?? false,
                      onChanged: (val) {
                        setDialogState(() {
                          selected[o] = val ?? false;
                        });
                      },
                      title: Text(o.shopName),
                      subtitle: Text(label),
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  final price =
                      double.tryParse(priceController.text) ?? 0;
                  if (selectedQty > 0) {
                    setState(() {
                      for (final entry in selected.entries) {
                        if (!entry.value) continue;
                        final targetOrder = entry.key;
                        final qty = targetOrder.remainingQuantity;
                        if (qty <= 0) continue;
                        targetOrder.addPurchase(
                          supplierName: supplierName,
                          qty: qty,
                          unitPrice: price,
                        );
                        OrderService.saveOrder(targetOrder);
                      }
                    });
                    Navigator.pop(context);
                    return;
                  }

                  final qty = int.tryParse(qtyController.text) ?? 0;
                  if (qty <= 0) return;

                  setState(() {
                    order.addPurchase(
                      supplierName: supplierName,
                      qty: qty,
                      unitPrice: price,
                    );
                  });

                  OrderService.saveOrder(order);
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
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
    OrderService.saveOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = OrderService.getGroupedBySupplier();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Supplier Management"),
        actions: [
          TextButton(
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Done Purchasing?"),
                  content: const Text("Are you sure you finished purchasing?"),
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
                    builder: (_) => const DeliveryScreen(),
                  ),
                );
              }
            },
            child: const Text("Done Purchasing?"),
          ),
        ],
      ),
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
                      ..._groupOrdersByItem(entry.value).map((group) {
                        final representative = group.orders.first;
                        final purchasedHere = group.orders.any(
                          (o) => o.purchases.any(
                            (p) => p.supplierName == supplierName,
                          ),
                        );
                        final isCompleted = group.totalRemaining <= 0;
                        final label = isCompleted
                            ? "Completed x ${group.totalOrdered}"
                            : group.totalPurchased > 0
                                ? "Buy ${group.totalRemaining} more"
                                : "Buy ${group.totalRemaining}";

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      representative.itemName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isCompleted
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // BUY BUTTON
                              Expanded(
                                child: Checkbox(
                                  value: purchasedHere,
                                  onChanged: (_) =>
                                      markAsPurchased(representative, supplierName),
                                ),
                              ),

                              // UNDO BUTTON
                              Expanded(
                                child: Checkbox(
                                  value: false,
                                  onChanged: (_) =>
                                      undoPurchase(representative, supplierName),
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

  String _normalizeItem(String value) {
    return value.toLowerCase().replaceAll(RegExp(r"\s+"), " ").trim();
  }

  List<_ItemGroup> _groupOrdersByItem(List<OrderModel> orders) {
    final groups = <String, List<OrderModel>>{};
    for (final order in orders) {
      final key = _normalizeItem(order.itemName);
      groups.putIfAbsent(key, () => []).add(order);
    }

    return groups.values.map((items) {
      final totalOrdered = items.fold<int>(0, (sum, o) => sum + o.quantity);
      final totalRemaining =
          items.fold<int>(0, (sum, o) => sum + o.remainingQuantity);
      final totalPurchased =
          items.fold<int>(0, (sum, o) => sum + o.purchasedQuantity);
      return _ItemGroup(
        orders: items,
        totalOrdered: totalOrdered,
        totalRemaining: totalRemaining,
        totalPurchased: totalPurchased,
      );
    }).toList();
  }
}

class _ItemGroup {
  final List<OrderModel> orders;
  final int totalOrdered;
  final int totalRemaining;
  final int totalPurchased;

  const _ItemGroup({
    required this.orders,
    required this.totalOrdered,
    required this.totalRemaining,
    required this.totalPurchased,
  });
}