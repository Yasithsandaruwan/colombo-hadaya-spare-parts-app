import 'package:flutter/material.dart';
import 'supplier_screen.dart';
import 'delivery_screen.dart';
import 'analytics_screen.dart';
import 'earnings_screen.dart';
import 'contact_screen.dart';
import 'today_orders_screen.dart'; // <-- New import
import 'most_wanted_screen.dart';  // <-- New import
import '../services/order_service.dart';

class DealerDashboard extends StatelessWidget {
  const DealerDashboard({super.key});

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF263238),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget buildCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accentColor.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: accentColor),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF263238),
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
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF25D366),
              child: Icon(Icons.tag_faces, color: Colors.white, size: 16),
            ),
            SizedBox(width: 8),
            Text(
              "Colombo Hadaya",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF263238),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Welcome back",
              style: TextStyle(fontSize: 14, color: Color(0xFF607D8B)),
            ),
            const Text(
              "Dealer Dashboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 14),

            const SizedBox(height: 10),

            // ---------------- PURCHASE ----------------
            buildSectionTitle("Purchase"),
            Row(
              children: [
                buildCard(
                  title: "Today's Orders",
                  icon: Icons.list_alt,
                  accentColor: const Color(0xFF1E88E5),
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
                  accentColor: const Color(0xFFF57C00),
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
                  accentColor: const Color(0xFF2E7D32),
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
                  accentColor: const Color(0xFF00897B),
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
                  accentColor: const Color(0xFF3949AB),
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
                  accentColor: const Color(0xFF1565C0),
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
            Row(
              children: [
                buildCard(
                  title: "Earnings",
                  icon: Icons.auto_graph,
                  accentColor: const Color(0xFF2E7D32),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EarningsScreen(),
                      ),
                    );
                  },
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}