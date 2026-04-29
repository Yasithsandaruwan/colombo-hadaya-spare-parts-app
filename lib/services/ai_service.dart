import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // Remember to revoke and replace this key in a production environment
  static const String apiKey = "GROQ_API_KEY"; 

  static Future<Map<String, String>> classifyItem(String input) async {
    final url = "https://api.groq.com/openai/v1/chat/completions";

    final prompt = """
You are a mobile spare parts expert.

Input: "$input"

Tasks:
1. Convert model codes to proper names (e.g., SM-S948B → Samsung Galaxy S24 Ultra)
2. Identify category from:
Battery, Screen, Charging, IC, Repair Tool, Accessory

Respond ONLY in JSON:
{
  "name": "...",
  "category": "..."
}
""";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile", // Updated to current active model
        "messages": [
          {"role": "user", "content": prompt}
        ],
        "response_format": {"type": "json_object"}, 
        "temperature": 0.2 
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final text = data["choices"][0]["message"]["content"];

      final jsonStart = text.indexOf("{");
      final jsonEnd = text.lastIndexOf("}") + 1;
      final jsonString = text.substring(jsonStart, jsonEnd);

      return Map<String, String>.from(jsonDecode(jsonString));
    } else {
      throw Exception("AI failed: ${response.body}");
    }
  }
}