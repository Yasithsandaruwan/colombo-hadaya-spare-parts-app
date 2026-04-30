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
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Color(0xFF25D366),
                        child: Icon(
                          Icons.tag_faces,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Colombo Hadaya",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Order parts faster via chat",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "* Demo only: WhatsApp API is paid, so this is a simple replication. Real WhatsApp Business API will be used later.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F6EC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFE8CC)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Color(0xFF075E54)),
                          SizedBox(width: 6),
                          Text(
                            "Quick tips",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF075E54),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle, size: 16, color: Color(0xFF25D366)),
                          SizedBox(width: 6),
                          Expanded(child: Text("First login as shop owner and make some orders")),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle, size: 16, color: Color(0xFF25D366)),
                          SizedBox(width: 6),
                          Expanded(child: Text("Use 'item x qty' to add parts")),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.check_circle, size: 16, color: Color(0xFF25D366)),
                          SizedBox(width: 6),
                          Expanded(child: Text("Type 'submit' to place the order")),
                        ],
                      ),
                    ],
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