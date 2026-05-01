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
          "Welcome to Colombo Hadaya.\nYour one and only reliable mobile spare parts and accessories provider.\n\nThis is an automated ordering system.\nFor urgent support, call: 0712345678\n\nHow to order:\n\n1) Add item\nGalaxy M02 Display x 2\n\n2) Delete item\nDel Galaxy M02 Display\n\n3) Submit order\nSubmit.\n\nif you go back without submitting, your order will be saved as a draft.",
      "isUser": false,
    });

    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final draftItems = await OrderService.loadDraft(widget.shopName);
    if (draftItems.isEmpty) return;

    setState(() {
      tempOrders = draftItems;
      messages.add({
        "text": "Draft loaded.\n\n${buildOrderSummary()}",
        "isUser": false,
      });
    });
    scrollToBottom();
  }

  @override
  void dispose() {
    if (tempOrders.isNotEmpty) {
      OrderService.saveDraft(widget.shopName, tempOrders);
    }
    super.dispose();
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

    final lower = input.toLowerCase();
    final isCommand = lower == "submit" || lower.startsWith("del ") || lower.startsWith("delete ");

    setState(() {
      messages.add({"text": input, "isUser": true});
    });

    messageController.clear();
    scrollToBottom();

    if (isCommand) {
      await processMessage(input);
      return;
    }

    //  AI Correction
    String corrected = input;
    try {
      final suggestion = await SuggestionService.getSuggestion(input);
      if (suggestion != null && suggestion.isNotEmpty) {
        corrected = suggestion;
      }
    } catch (_) {
      corrected = input;
    }

    await processMessage(corrected);
  }

  // PROCESS MESSAGE
  Future<void> processMessage(String input) async {
    String lower = input.toLowerCase();

    // SUBMIT
    if (lower == "submit") {

      if (tempOrders.isEmpty) {
        addBotMessage("No items to submit.");
        return;
      }

      for (var o in tempOrders) {
        await OrderService.addOrder(o);
      }

      await OrderService.clearDraft(widget.shopName);

      addBotMessage(
          "Order placed successfully.\n\n${buildOrderSummary()}");

      setState(() {
        tempOrders.clear();
      });

      return;
    }

    //  DELETE 
    if (lower.startsWith("del ") || lower.startsWith("delete ")) {
      final itemName = lower.startsWith("delete ")
          ? input.substring(7).trim()
          : input.substring(4).trim();
        final target = _normalizeItem(itemName);
        final beforeCount = tempOrders.length;

        tempOrders.removeWhere((o) {
          final current = _normalizeItem(o.itemName);
          return current == target || current.contains(target);
        });

        if (tempOrders.length == beforeCount) {
          addBotMessage("Item not found: $itemName\n\n${buildOrderSummary()}");
          return;
        }

        addBotMessage("Removed: $itemName\n\n${buildOrderSummary()}");
      return;
    }

    //  ADD ITEM 
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

  String _normalizeItem(String value) {
    final cleaned = value.toLowerCase().replaceAll(RegExp(r"\s+"), " ").trim();
    return cleaned;
  }

  // CHAT BUBBLE
  Widget buildMessage(Map msg) {
    bool isUser = msg["isUser"];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userBubble = isDark ? const Color(0xFF005C4B) : const Color(0xFFDCF8C6);
    final botBubble = isDark ? const Color(0xFF1F2C34) : Colors.white;

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: isUser ? userBubble : botBubble,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft:
                  isUser ? const Radius.circular(14) : const Radius.circular(2),
              bottomRight:
                  isUser ? const Radius.circular(2) : const Radius.circular(14),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
              )
            ],
          ),
          child: Text(
            msg["text"],
            style: TextStyle(
              fontSize: 15,
              height: 1.35,
              color: isUser
                  ? (isDark ? Colors.white : Colors.black)
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAvatar() {
    return const CircleAvatar(
      radius: 18,
      backgroundColor: Color(0xFFFFD166),
      child: Icon(
        Icons.tag_faces,
        color: Colors.black87,
        size: 22,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chatBackground =
        isDark ? const Color(0xFF0B141A) : const Color(0xFFECE5DD);
    final appBarColor =
        isDark ? const Color(0xFF202C33) : const Color(0xFF075E54);

    return Scaffold(
      backgroundColor: chatBackground,

      appBar: AppBar(
        backgroundColor: appBarColor,
        titleSpacing: 0,
        title: Row(
          children: [
            buildAvatar(),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Colombo Hadaya",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "online",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam_outlined),
          SizedBox(width: 16),
          Icon(Icons.call_outlined),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [

          // CHAT
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (_, i) => buildMessage(messages[i]),
            ),
          ),

          // INPUT BAR
          Container(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
            color: chatBackground,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (_) => sendMessage(),
                      decoration: const InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                        icon: Icon(Icons.emoji_emotions_outlined),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF25D366),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}