import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'analytics_screen.dart';
import '../widgets/footer_strip.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final grouped = OrderService.getDueUndeliveredByShop(today);
    final overdueShops = OrderService.getOverdueShopSet(today);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Summary"),
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

      body: grouped.isEmpty
          ? const Center(child: Text("No Orders Yet"))
          : ListView(
              children: grouped.entries.map((entry) {

                //  TOTAL CALCULATION
                double total = entry.value.fold(
                  0,
                  (sum, o) => sum + o.totalPrice,
                );
                total += 1000;

                final isOverdue = overdueShops.contains(entry.key);
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              color: isOverdue ? Colors.red : null,
                              fontWeight: isOverdue ? FontWeight.w600 : null,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: false,
                          onChanged: (_) async {
                            final confirm = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Confirm Delivery"),
                                content: Text(
                                  "Are you sure delivered to ${entry.key}?",
                                ),
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

                            if (confirm == true) {
                              for (final order in entry.value) {
                                order.markDelivered();
                                await OrderService.saveOrder(order);
                              }
                              if (context.mounted) {
                                setState(() {});
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "Total: Rs. ${total.toStringAsFixed(2)}",
                    ),

                    children: entry.value.map((o) {
                      return ListTile(
                        title: Text(o.itemName),

                        subtitle: Text(
                          o.remainingQuantity > 0
                              ? "Ordered: ${o.quantity} | Buy ${o.remainingQuantity} more"
                              : "Ordered: ${o.quantity} | Fulfilled",
                          style: o.remainingQuantity > 0
                              ? null
                              : const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
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
      bottomNavigationBar: const FooterStrip(),
    );
  }
}