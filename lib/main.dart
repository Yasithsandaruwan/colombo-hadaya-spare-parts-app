import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ---------------- APP ROOT ----------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// ---------------- LOGIN SCREEN ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Shop Owner';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Colombo Hadaya",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Icon(Icons.sentiment_satisfied_alt, size: 70, color: Colors.orange),
              const SizedBox(height: 40),

              TextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Shop Owner', 'Dealer']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (selectedRole == 'Shop Owner') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ShopOwnerScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DealerDashboard()),
                      );
                    }
                  },
                  child: const Text("Login", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- SHOP OWNER SCREEN ----------------
class ShopOwnerScreen extends StatefulWidget {
  const ShopOwnerScreen({super.key});

  @override
  State<ShopOwnerScreen> createState() => _ShopOwnerScreenState();
}

class _ShopOwnerScreenState extends State<ShopOwnerScreen> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  List<Map<String, String>> orders = [];

  void addItem() {
    if (itemController.text.isEmpty || qtyController.text.isEmpty) return;

    setState(() {
      orders.add({
        "item": itemController.text,
        "qty": qtyController.text,
      });
      itemController.clear();
      qtyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Order"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: itemController,
              decoration: const InputDecoration(
                labelText: "Item name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: addItem, child: const Text("Add")),
              ],
            ),

            const SizedBox(height: 20),

            const Text("Order List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(orders[index]["item"]!),
                    trailing: Text("x${orders[index]["qty"]}"),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SupplierScreen(orders: orders)),
                );
              },
              child: const Text("Submit Order"),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- DEALER DASHBOARD ----------------
class DealerDashboard extends StatelessWidget {
  const DealerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dealer Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                );
              },
              child: const Text("View Analytics"),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- SUPPLIER SCREEN ----------------
class SupplierScreen extends StatelessWidget {
  final List<Map<String, String>> orders;

  const SupplierScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, String>>> grouped = {
      "Screen Supplier": [],
      "IC Supplier": [],
      "Accessories": [],
    };

    for (var order in orders) {
      if (order["item"]!.toLowerCase().contains("display")) {
        grouped["Screen Supplier"]!.add(order);
      } else if (order["item"]!.toLowerCase().contains("ic")) {
        grouped["IC Supplier"]!.add(order);
      } else {
        grouped["Accessories"]!.add(order);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Supplier Purchase List")),
      body: ListView(
        children: grouped.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key),
            children: entry.value.map((item) {
              return ListTile(
                title: Text(item["item"]!),
                trailing: Text("x${item["qty"]}"),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------- ANALYTICS SCREEN ----------------
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: const Center(
        child: Text(
          "Top Items:\nCharging Board - 10\nDisplay - 5",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}