import 'package:flutter/material.dart';
import '../services/order_service.dart';

class MostWantedScreen extends StatelessWidget {
  const MostWantedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = OrderService.getMostRequestedItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Most Wanted Items"),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F7FB),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "No data available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: items.entries.map((e) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Icon(Icons.trending_up, color: Colors.indigo.shade700),
                    ),
                    title: Text(
                      e.key,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    trailing: Text(
                      "${e.value} ordered",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}