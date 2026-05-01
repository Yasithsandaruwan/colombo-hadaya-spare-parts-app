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

  // MAIN ENTRY
  static Future<String?> getSuggestion(String input) async {

    // 1️TRY AI 
    try {
      final result = await AIService.classifyItem(input);

      if (result.containsKey("name")) {
        return result["name"];
      }
    } catch (_) {
      // AI failed 
    }

    // LOCAL FALLBACK
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