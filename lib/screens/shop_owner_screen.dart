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

  // 🆕 Temporary list (cart)
  List<OrderModel> tempOrders = [];

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

  // 🟡 Add to TEMP list (not service)
  void addItem() {
    if (itemController.text.isEmpty || qtyController.text.isEmpty) return;

    setState(() {
      tempOrders.add(
        OrderModel(
          itemName: itemController.text,
          quantity: int.parse(qtyController.text),
          shopName: widget.shopName,
        ),
      );
    });

    itemController.clear();
    qtyController.clear();
    suggestion = null;
  }

  // 🔴 Delete item
  void removeItem(int index) {
    setState(() {
      tempOrders.removeAt(index);
    });
  }

  // ✅ Submit all items
  void submitOrder() {
    if (tempOrders.isEmpty) return;

    for (var order in tempOrders) {
      OrderService.addOrder(order);
    }

    setState(() {
      tempOrders.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Your order has been placed"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopName),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Input Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: itemController,
                      decoration: const InputDecoration(
                        labelText: "Item Name",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: checkSuggestion,
                    ),

                    if (suggestion != null)
                      ListTile(
                        title: Text("Did you mean: $suggestion"),
                        leading: const Icon(Icons.lightbulb_outline),
                        onTap: () {
                          itemController.text = suggestion!;
                          setState(() => suggestion = null);
                        },
                      ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantity",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: addItem,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Item"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Item List
            Expanded(
              child: tempOrders.isEmpty
                  ? const Center(child: Text("No items added yet"))
                  : ListView.builder(
                      itemCount: tempOrders.length,
                      itemBuilder: (context, index) {
                        final item = tempOrders[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(item.itemName),
                            subtitle: Text("Qty: ${item.quantity}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeItem(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // 🔹 Submit Button
            ElevatedButton(
              onPressed: submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Submit Order",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}