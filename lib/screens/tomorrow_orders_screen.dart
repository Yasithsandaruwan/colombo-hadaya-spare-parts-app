import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../widgets/footer_strip.dart';

class TomorrowOrdersScreen extends StatelessWidget {
  const TomorrowOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final grouped = OrderService.getOrdersByShopForDate(tomorrow);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tomorrow's Orders"),
      ),
      body: grouped.isEmpty
          ? const Center(
              child: Text(
                "No orders for tomorrow yet.\nCheck after 2:00 PM.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: ExpansionTile(
                    title: Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    children: entry.value.map((o) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(o.itemName),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "x${o.quantity}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
      bottomNavigationBar: const FooterStrip(),
    );
  }
}
