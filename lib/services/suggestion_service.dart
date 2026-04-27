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

  static String? getSuggestion(String input) {
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