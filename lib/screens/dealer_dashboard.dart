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
      appBar: AppBar(title: const Text("Dealer Dashboard")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Today's Orders",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final o = orders[i];
                return ListTile(
                  title: Text(o.itemName),
                  subtitle: Text(o.shopName),
                  trailing: Text("x${o.quantity}"),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SupplierScreen(),
                  ),
                );
              },
              child: const Text("Supplier List"),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeliveryScreen(),
                  ),
                );
              },
              child: const Text("Delivery View"),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnalyticsScreen(),
                  ),
                );
              },
              child: const Text("Finish Day"),
            ),
          ),
        ],
      ),
    );
  }
}