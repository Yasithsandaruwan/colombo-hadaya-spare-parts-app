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
  final TextEditingController itemController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  String? suggestion;
  List<OrderModel> tempOrders = [];

  Future<bool> confirmExit() async {
    if (tempOrders.isEmpty) return true;

    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Discard Order?"),
            content: const Text(
                "You have unsent items. Do you want to discard them?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("No")),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Yes")),
            ],
          ),
        ) ??
        false;
  }

  void checkSuggestion(String value) {
    if (value.trim().isEmpty) {
      setState(() => suggestion = null);
      return;
    }

    final result = SuggestionService.getSuggestion(value);

    setState(() {
      suggestion = (result != null &&
              result.toLowerCase() != value.toLowerCase())
          ? result
          : null;
    });
  }

  void addTempOrder() {
    if (itemController.text.isEmpty || qtyController.text.isEmpty) return;

    setState(() {
      tempOrders.add(OrderModel(
        itemName: itemController.text,
        quantity: int.parse(qtyController.text),
        shopName: widget.shopName,
      ));

      itemController.clear();
      qtyController.clear();
      suggestion = null;
    });
  }

  void removeItem(int index) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Remove Item"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes")),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => tempOrders.removeAt(index));
    }
  }

  void submitOrder() {
    for (var order in tempOrders) {
      OrderService.addOrder(order);
    }

    setState(() => tempOrders.clear());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Your order has been placed"),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmExit,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.shopName)),
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: itemController,
                        decoration:
                            const InputDecoration(labelText: "Item Name"),
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
                        decoration:
                            const InputDecoration(labelText: "Quantity"),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: addTempOrder,
                        child: const Text("Add Item"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: tempOrders.isEmpty
                    ? const Center(child: Text("No items added"))
                    : ListView.builder(
                        itemCount: tempOrders.length,
                        itemBuilder: (_, i) {
                          final o = tempOrders[i];

                          return Card(
                            child: ListTile(
                              title: Text(o.itemName),
                              subtitle: Text("Qty: ${o.quantity}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => removeItem(i),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      tempOrders.isEmpty ? null : submitOrder,
                  child: const Text("Submit Order"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}