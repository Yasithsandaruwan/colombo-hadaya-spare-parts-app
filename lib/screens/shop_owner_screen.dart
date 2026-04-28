import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import '../services/suggestion_service.dart';

class ShopOwnerScreen extends StatefulWidget {
  final String shopName;

  const ShopOwnerScreen({super.key, required this.shopName});

  @override
  State<ShopOwnerScreen> createState() => _ShopOwnerScreenState();
}

class _ShopOwnerScreenState extends State<ShopOwnerScreen> {
  final itemController = TextEditingController();
  final qtyController = TextEditingController();
  String? suggestion;

  void checkSuggestion(String value) {
    if (value.trim().isEmpty) {
      setState(() => suggestion = null);
      return;
    }

    final result = SuggestionService.getSuggestion(value);

    setState(() {
      suggestion =
          (result != null && result.toLowerCase() != value.toLowerCase())
          ? result
          : null;
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
      appBar: AppBar(title: Text(widget.shopName)),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: itemController,
                      decoration: const InputDecoration(labelText: "Item Name"),
                      onChanged: checkSuggestion,
                    ),

                    if (suggestion != null)
                      ListTile(
                        title: Text("Did you mean: $suggestion"),
                        onTap: () {
                          itemController.text = suggestion!;
                          setState(() => suggestion = null);
                        },
                      ),

                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Quantity"),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: addOrder,
                      child: const Text("Add Item"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
