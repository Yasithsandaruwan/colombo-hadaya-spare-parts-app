import 'package:flutter/material.dart';
import 'supplier_screen.dart';
import 'delivery_screen.dart';
import 'analytics_screen.dart';
import 'contact_screen.dart';
import 'today_orders_screen.dart'; // <-- New import
import 'most_wanted_screen.dart';  // <-- New import
import '../services/order_service.dart';

class DealerDashboard extends StatelessWidget {
  const DealerDashboard({super.key});

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget buildCard({
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 38, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.sentiment_satisfied_alt, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text(
              "Colombo Hadaya",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Welcome Back,",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Text(
              "Dealer Dashboard",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 25),

            // ---------------- PURCHASE ----------------
            buildSectionTitle("Purchase"),
            Row(
              children: [
                buildCard(
                  title: "Today's Orders",
                  icon: Icons.list_alt,
                  gradientColors: [Colors.blue.shade400, Colors.blue.shade700],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TodayOrdersScreen(),
                      ),
                    );
                  },
                ),
                buildCard(
                  title: "Go Purchase",
                  icon: Icons.shopping_cart,
                  gradientColors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SupplierScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ---------------- DELIVERY ----------------
            buildSectionTitle("Deliver"),
            Row(
              children: [
                buildCard(
                  title: "Go Delivery",
                  icon: Icons.local_shipping,
                  gradientColors: [Colors.green.shade400, Colors.green.shade700],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DeliveryScreen(),
                      ),
                    );
                  },
                ),
                buildCard(
                  title: "Contact Shops",
                  icon: Icons.phone,
                  gradientColors: [Colors.teal.shade400, Colors.teal.shade700],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ContactScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ---------------- ANALYTICS ----------------
            buildSectionTitle("Analytics"),
            Row(
              children: [
                buildCard(
                  title: "Daily Report",
                  icon: Icons.bar_chart,
                  gradientColors: [Colors.purple.shade400, Colors.purple.shade700],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AnalyticsScreen(),
                      ),
                    );
                  },
                ),
                buildCard(
                  title: "Most Wanted",
                  icon: Icons.trending_up,
                  gradientColors: [Colors.indigo.shade400, Colors.indigo.shade700],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MostWantedScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}