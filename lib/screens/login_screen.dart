import 'package:flutter/material.dart';
import 'dealer_dashboard.dart';
import 'chat_order_screen.dart';
import '../services/order_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String role = "Dealer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Center(
                  child: Text(
                    "Colombo Hadaya",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "* Use this temporary option to replicate WhatsApp API demonstration.\nReal WhatsApp API will be integrated later.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField(
                  value: role,
                  items: const [
                    DropdownMenuItem(value: "Dealer", child: Text("Dealer")),
                    DropdownMenuItem(value: "Shop Owner", child: Text("Shop Owner")),
                  ],
                  onChanged: (val) {
                    setState(() {
                      role = val.toString();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Select Role",
                  ),
                ),

                const SizedBox(height: 20),

                if (role == "Shop Owner") ...[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Shop Name",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Mobile Number",
                    ),
                  ),

                  const SizedBox(height: 20),
                ],

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      if (role == "Dealer") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DealerDashboard(),
                          ),
                        );
                      } else {

                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter all details"),
                            ),
                          );
                          return;
                        }

                        // SAVE CONTACT
                        OrderService.saveShopContact(
                          nameController.text,
                          phoneController.text,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatOrderScreen(
                              shopName: nameController.text,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      role == "Dealer"
                          ? "Enter Dashboard"
                          : "Start Ordering",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}