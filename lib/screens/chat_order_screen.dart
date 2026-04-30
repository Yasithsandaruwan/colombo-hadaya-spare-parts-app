import 'package:flutter/material.dart';
import 'dart:async';
import '../models/order.dart';
import '../services/order_service.dart';
import '../services/suggestion_service.dart';

class ChatOrderScreen extends StatefulWidget {
  final String shopName;

  const ChatOrderScreen({super.key, required this.shopName});

  @override
  State<ChatOrderScreen> createState() => _ChatOrderScreenState();
}

class _ChatOrderScreenState extends State<ChatOrderScreen> {

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  List<OrderModel> tempOrders = [];

  @override
  void initState() {
    super.initState();

    messages.add({
      "text":
          "Welcome to Colombo Hadaya.\n\nThis is an automated ordering system.\n\nDo not use chat to contact us.\nCall: 0712345678\n\nInstructions:\n\n• Add item:\nGalaxy M02 display x 2\n\n• Delete item:\nDel Galaxy M02 display\n\n• Submit order:\nSubmit",
      "isUser": false,
    });
  }

  // AUTO SCROLL
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // SEND MESSAGE
  Future<void> sendMessage() async {
    String input = messageController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      messages.add({"text": input, "isUser": true});
    });

    messageController.clear();
    scrollToBottom();

    // 🔥 AI Correction (SAFE)
    String corrected = input;
    try {
      final suggestion =
          await SuggestionService.getSuggestion(input);
      if (suggestion != null && suggestion.isNotEmpty) {
        corrected = suggestion;
      }
    } catch (_) {
      corrected = input;
    }

    processMessage(corrected);
  }

  // PROCESS MESSAGE
  void processMessage(String input) {
    String lower = input.toLowerCase();

    // -------- SUBMIT --------
    if (lower == "submit") {

      if (tempOrders.isEmpty) {
        addBotMessage("No items to submit.");
        return;
      }

      for (var o in tempOrders) {
        OrderService.addOrder(o);
      }

      addBotMessage(
          "Order placed successfully.\n\n${buildOrderSummary()}");

      setState(() {
        tempOrders.clear();
      });

      return;
    }

    // -------- DELETE --------
    if (lower.startsWith("del ")) {
      String itemName = input.substring(4).trim();

      tempOrders.removeWhere(
          (o) => o.itemName.toLowerCase() == itemName.toLowerCase());

      addBotMessage("Removed: $itemName\n\n${buildOrderSummary()}");
      return;
    }

    // -------- ADD ITEM --------
    RegExp regex = RegExp(r"(.+?)\s*x\s*(\d+)", caseSensitive: false);
    var match = regex.firstMatch(input);

    if (match != null) {
      String itemName = match.group(1)!.trim();
      int qty = int.tryParse(match.group(2)!) ?? 1;

      tempOrders.add(
        OrderModel(
          itemName: itemName,
          quantity: qty,
          shopName: widget.shopName,
        ),
      );

      addBotMessage("Added: $itemName x$qty\n\n${buildOrderSummary()}");
    } else {
      addBotMessage("Invalid format.\nUse: item x quantity");
    }
  }

  void addBotMessage(String text) {
    setState(() {
      messages.add({"text": text, "isUser": false});
    });
    scrollToBottom();
  }

  String buildOrderSummary() {
    if (tempOrders.isEmpty) return "No items.";

    String summary = "Current Order:\n";

    for (var o in tempOrders) {
      summary += "- ${o.itemName} x${o.quantity}\n";
    }

    return summary;
  }

  // CHAT BUBBLE
  Widget buildMessage(Map msg) {
    bool isUser = msg["isUser"];

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 260),
          decoration: BoxDecoration(
            color: isUser ? Colors.green[300] : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  isUser ? const Radius.circular(12) : Radius.zero,
              bottomRight:
                  isUser ? Radius.zero : const Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
              )
            ],
          ),
          child: Text(msg["text"]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),

      appBar: AppBar(
        title: Text(widget.shopName),
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [

          // CHAT
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (_, i) => buildMessage(messages[i]),
            ),
          ),

          // INPUT BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    onSubmitted: (_) => sendMessage(),
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () => sendMessage(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}