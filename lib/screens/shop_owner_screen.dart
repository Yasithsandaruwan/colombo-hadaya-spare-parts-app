import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import '../services/suggestion_service.dart';
import '../services/ai_service.dart';
import '../widgets/footer_strip.dart';

class ShopOwnerScreen extends StatefulWidget {
  final String shopName;

  const ShopOwnerScreen({super.key, required this.shopName});

  @override
  State<ShopOwnerScreen> createState() => _ShopOwnerScreenState();
}

class _ShopOwnerScreenState extends State<ShopOwnerScreen> {
  final itemController = TextEditingController();
  final qtyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();

  String? suggestion;
  bool isAnalyzing = false;

  List<OrderModel> tempOrders = [];

  void checkSuggestion(String value) async {
    if (value.trim().isEmpty) {
      setState(() => suggestion = null);
      return;
    }

    final result = await SuggestionService.getSuggestion(value);

    setState(() {
      suggestion =
          (result != null && result.toLowerCase() != value.toLowerCase())
              ? result
              : null;
    });
  }

  // 🔵 AI ANALYSIS
  Future<void> analyzeItem() async {
    if (itemController.text.isEmpty) return;

    setState(() {
      isAnalyzing = true;
    });

    try {
      final result =
          await AIService.classifyItem(itemController.text);

      itemController.text = result["name"] ?? itemController.text;

      print("AI Category: ${result["category"]}");

    } catch (e) {
      print("AI error: $e");
    }

    setState(() {
      isAnalyzing = false;
    });
  }

  void addItem() async {
    if (itemController.text.isEmpty || qtyController.text.isEmpty) return;

    // Run Ai before adding
    await analyzeItem();

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

  void removeItem(int index) {
    setState(() {
      tempOrders.removeAt(index);
    });
  }

  Future<void> submitOrder() async {
    if (tempOrders.isEmpty) return;

    await OrderService.saveShopContact(
      shopNameController.text,
      phoneController.text,
    );

    for (var order in tempOrders) {
      await OrderService.addOrder(order);
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
                      decoration: const InputDecoration(
                        labelText: "Item Name",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: checkSuggestion,
                      onSubmitted: (value) {
                        analyzeItem();
                      },
                    ),

                    //  Loading Indicator
                    if (isAnalyzing)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text("Analyzing item..."),
                          ],
                        ),
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

                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
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
      bottomNavigationBar: const FooterStrip(),
    );
  }
}
