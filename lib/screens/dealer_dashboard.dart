import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'supplier_screen.dart';
import 'analytics_screen.dart';
import 'delivery_screen.dart';

class DealerDashboard extends StatelessWidget {
  const DealerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderService.orders;

    return Scaffold(
      appBar: AppBar(title: const Text("Colombo Hadaya"), centerTitle: true),
      backgroundColor: Colors.grey[100],

      body: Column(
        children: [
          // 🔷 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dealer Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Manage today's orders efficiently",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📦 ORDERS TITLE
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.inventory, color: Colors.black),
                SizedBox(width: 6),
                Text(
                  "Today's Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 📦 ORDER LIST (CARD STYLE)
          Expanded(
            child: orders.isEmpty
                ? const Center(child: Text("No orders yet"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: orders.length,
                    itemBuilder: (_, i) {
                      final o = orders[i];

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(Icons.build, color: Colors.white),
                          ),
                          title: Text(
                            o.itemName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(o.shopName),
                          trailing: Text(
                            "x${o.quantity}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 10),

          // 🔘 ACTION BUTTONS (MODERN STYLE)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                // Supplier
                _buildButton(
                  context,
                  text: "Supplier List",
                  icon: Icons.store,
                  color: Colors.blue,
                  screen: const SupplierScreen(),
                ),

                // Delivery
                _buildButton(
                  context,
                  text: "Delivery View",
                  icon: Icons.local_shipping,
                  color: Colors.orange,
                  screen: const DeliveryScreen(),
                ),

                // Finish Day
                _buildButton(
                  context,
                  text: "Finish Day",
                  icon: Icons.check_circle,
                  color: Colors.green,
                  screen: const AnalyticsScreen(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // 🔧 REUSABLE BUTTON
  Widget _buildButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }
}
