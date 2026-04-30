import 'ai_service.dart';

class SuggestionService {

  static List<String> knownItems = [
    "Samsung Display",
    "iPhone Display",
    "Charging Port",
    "Battery",
    "IC Chip",
    "SMD Resistor",
    "SMD Capacitor",
    "Mic",
  ];

  // 🔥 MAIN ENTRY
  static Future<String?> getSuggestion(String input) async {

    // 1️⃣ TRY AI FIRST
    try {
      final result = await AIService.classifyItem(input);

      if (result.containsKey("name")) {
        return result["name"];
      }
    } catch (_) {
      // AI failed → fallback
    }

    // 2️⃣ LOCAL FALLBACK
    input = input.toLowerCase();

    for (var item in knownItems) {
      if (item.toLowerCase().contains(input) ||
          input.contains(item.toLowerCase())) {
        return item;
      }
    }

    return null;
  }
}