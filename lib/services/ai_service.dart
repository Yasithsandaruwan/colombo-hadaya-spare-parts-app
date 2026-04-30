import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey = "8888888888888888888888888888888888888888888888888888888888888888888";
  // ⚠️ SECURITY WARNING: Never commit your real API key to GitHub. 
  // Use a .env file in the future.

  static Future<Map<String, String>> classifyItem(String input) async {
    final url = "https://api.groq.com/openai/v1/chat/completions";

    final prompt = """
Fix the user input into clean spare part order format.

Rules:
- Keep item name clear
- Keep quantity if exists (x number)git add .
- Correct spelling
- Do NOT explain

Input: "$input"

Output example:
Samsung Galaxy S24 Ultra Battery x 2

Return ONLY plain text.
""";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile",
        "messages": [
          {"role": "user", "content": prompt},
        ],
        "temperature": 0.2,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data["choices"][0]["message"]["content"];

      return {"name": text.trim()};
    } else {
      throw Exception("AI failed: ${response.body}");
    }
  }
}
