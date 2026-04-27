import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import '../services/suggestion_service.dart';


class ShopOwnerScreen extends StatefulWidget {
  final String shopName;

  const ShopOwnerScreen({super.key, required this.shopName});

  @override
  State<ShopOwnerScreen> createState() => _ShopOwnerScreenState();
}

class _ShopOwnerScreenState extends State<ShopOwnerScreen> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  String? suggestion;

  void checkSuggestion(String value) {
    setState(() {
      suggestion = SuggestionService.getSuggestion(value);
    });
  }

  void addOrder() {
    if (itemController.text.isEmpty || qtyController.text.isEmpty) return;

    OrderService.addOrder(
  OrderModel(
    itemName: itemController.text,
    quantity: int.parse(qtyController.text),
    shopName: widget.shopName,
  ),
);

    itemController.clear();
    qtyController.clear();
    setState(() => suggestion = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders - ${widget.shopName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ITEM INPUT
            TextField(
              controller: itemController,
              decoration: const InputDecoration(labelText: "Item"),
              onChanged: checkSuggestion,
            ),

            // 🔥 AI SUGGESTION
            if (suggestion != null &&
                suggestion!.toLowerCase() != itemController.text.toLowerCase())
              GestureDetector(
                onTap: () {
                  itemController.text = suggestion!;
                  setState(() => suggestion = null);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[300],
                  child: Text("Did you mean: $suggestion ?"),
                ),
              ),

            const SizedBox(height: 10),

            // QUANTITY INPUT
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantity"),
            ),

            const SizedBox(height: 20),

            // ADD BUTTON
            ElevatedButton(
              onPressed: addOrder,
              child: const Text("Add Order"),
            ),
          ],
        ),
      ),
    );
  }
}