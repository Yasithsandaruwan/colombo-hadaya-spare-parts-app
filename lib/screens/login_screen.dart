import 'package:flutter/material.dart';
import 'shop_owner_screen.dart';
import 'dealer_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String role = "Shop Owner";
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Colombo Hadaya", style: TextStyle(fontSize: 28)),
            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            DropdownButton<String>(
              value: role,
              items: ["Shop Owner", "Dealer"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => role = value!),
            ),

            ElevatedButton(
              onPressed: () {
                if (role == "Shop Owner") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ShopOwnerScreen(shopName: nameController.text),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DealerDashboard(),
                    ),
                  );
                }
              },
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}