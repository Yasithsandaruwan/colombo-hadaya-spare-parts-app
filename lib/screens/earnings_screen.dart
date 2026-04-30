import 'package:flutter/material.dart';
import '../services/order_service.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayNetRevenue = OrderService.getNetRevenueForDate(today);
    final todaySuccessRate = OrderService.getSuccessRateForDate(today);
    final monthStart = today.subtract(const Duration(days: 29));
    final monthlyNetRevenue = _sumNetRevenue(monthStart, today);
    final averageSuccessRate = _averageSuccessRate(monthStart, today);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Earnings"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF263238),
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF3F5F8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daily Net Revenue (${today.day}/${today.month}/${today.year})",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Updates at 11:59 PM each day",
              style: TextStyle(fontSize: 12, color: Color(0xFF607D8B)),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text("Today Net Revenue"),
                trailing: Text("Rs. $todayNetRevenue"),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text("Delivery Success Rate"),
                trailing: Text("${todaySuccessRate.toStringAsFixed(0)}%"),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Last 30 Days",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text("Monthly Net Revenue"),
                trailing: Text("Rs. $monthlyNetRevenue"),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text("Average Delivery Success Rate"),
                trailing: Text("${averageSuccessRate.toStringAsFixed(0)}%"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _sumNetRevenue(DateTime from, DateTime to) {
    int total = 0;
    for (var i = 0; i <= _daysBetween(from, to); i++) {
      total += OrderService.getNetRevenueForDate(from.add(Duration(days: i)));
    }
    return total;
  }

  double _averageSuccessRate(DateTime from, DateTime to) {
    final days = _daysBetween(from, to);
    if (days < 0) return 0;

    double total = 0;
    for (var i = 0; i <= days; i++) {
      total += OrderService.getSuccessRateForDate(from.add(Duration(days: i)));
    }
    return total / (days + 1);
  }

  int _daysBetween(DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    return end.difference(start).inDays;
  }
}
