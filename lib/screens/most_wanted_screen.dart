import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../widgets/footer_strip.dart';

class MostWantedScreen extends StatefulWidget {
  const MostWantedScreen({super.key});

  @override
  State<MostWantedScreen> createState() => _MostWantedScreenState();
}

class _MostWantedScreenState extends State<MostWantedScreen> {
  String selectedRange = "Weekly";

  Map<String, int> getItems(DateTime from, DateTime to) {
    return OrderService.getMostRequestedItemsInRange(from, to);
  }

  List<String> getSuggestions(DateTime from, DateTime to) {
    if (selectedRange == "Weekly") {
      return OrderService.getStockSuggestions(
        from: from,
        to: to,
        topN: 3,
        minCount: 3,
      );
    }

    return OrderService.getStockSuggestions(
      from: from,
      to: to,
      topN: 5,
      minCount: 5,
    );
  }

  Widget buildItemList(BuildContext context, Map<String, int> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "No data available.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
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
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.primary,
              ),
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
    );
  }

  Widget buildSuggestions(BuildContext context, List<String> suggestions) {
    if (suggestions.isEmpty) {
      return const Card(
        child: ListTile(
          title: Text("No suggestions yet."),
        ),
      );
    }

    return Column(
      children: suggestions.map((item) {
        return Card(
          child: ListTile(
            leading: Icon(
              Icons.trending_up,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(item),
            subtitle: const Text("Consider stocking for bulk profit"),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final from = selectedRange == "Weekly"
        ? now.subtract(const Duration(days: 7))
        : now.subtract(const Duration(days: 30));
    final items = getItems(from, now);
    final suggestions = getSuggestions(from, now);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Most Wanted Items & Older Reports"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedRange,
                items: const [
                  DropdownMenuItem(value: "Weekly", child: Text("Weekly report")),
                  DropdownMenuItem(value: "Monthly", child: Text("Monthly report")),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedRange = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            selectedRange == "Weekly"
                ? "Fast-selling items (last 7 days)"
                : "Fast-selling items (last 30 days)",
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 8),
          buildItemList(context, items),
          const SizedBox(height: 16),
          Text(
            "Stock suggestions",
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 8),
          buildSuggestions(context, suggestions),
        ],
      ),
      bottomNavigationBar: const FooterStrip(),
    );
  }
}