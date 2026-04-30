import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey =
      "api_key_here";

  static const Map<String, List<String>> _typeKeywords = {
    "Battery": ["battery"],
    "Display": ["screen", "display", "oled", "lcd"],
    "Charging Port": ["charging port", "usb port", "type c", "usb-c", "connector"],
    "Camera": ["camera"],
    "Speaker": ["speaker", "loudspeaker", "earpiece"],
    "Microphone": ["microphone", "mic"],
    "FingerPrint": ["fingerprint", "touch id"],
    "Power Bank": ["power bank"],
    "Headphones": ["headphone", "headphones", "earphone", "earphones", "3.5mm", "audio jack"],
    "Charger": ["charger", "adapter", "car charger"],
    "Cable": ["cable", "data cable"],
    "Tempered Glass": ["tempered", "screen protector", "glass"],
    "Cover": ["cover", "case", "back cover"],
    "IC": ["ic", "chip", "pmic", "cpu", "emmc"],
    "Bluetooth Speaker": ["bluetooth speaker", "portable speaker", "bt speaker"],
    "Charging Flex": ["charging flex", "usb flex", "flex cable", "sub board"],
    "Speaker Flex": ["speaker flex"],
    "Battery Flex": ["battery flex"],
    "Main Board": ["main board", "motherboard", "logic board", "board"],
    "Frame": ["frame", "mid frame", "middle frame", "chassis"],
    "Back Glass": ["back glass", "rear glass", "glass back"],
    "Housing": ["housing", "body", "back housing"],
    "SIM Tray": ["sim tray", "sim holder"],
    "SIM Reader": ["sim reader", "sim slot"],
    "Vibration Motor": ["vibration", "vibrator", "motor"],
    "Power Button": ["power button", "power key", "side key"],
    "Volume Button": ["volume button", "volume key"],
    "Home Button": ["home button"],
    "Proximity Sensor": ["proximity", "sensor"],
    "Face ID": ["face id", "face sensor"],
    "Flash": ["flash", "torch"],
    "Camera Lens": ["camera lens", "lens"],
    "Antenna": ["antenna", "signal", "network"],
    "WiFi Antenna": ["wifi", "wi-fi"],
    "Bluetooth IC": ["bluetooth ic"],
    "WiFi IC": ["wifi ic", "wi-fi ic"],
    "Audio IC": ["audio ic", "sound ic"],
    "Charging IC": ["charging ic"],
    "Touch IC": ["touch ic"],
    "Backlight IC": ["backlight ic"],
    "PMIC": ["pmic", "power ic"],
    "Connector": ["connector", "socket"],
    "Camera Flex": ["camera flex"],
    "Display Flex": ["display flex", "lcd flex"],
    "Fingerprint Flex": ["fingerprint flex"],
    "Earpiece": ["earpiece"],
    "Loudspeaker": ["loudspeaker", "ringer"],
    "Rear Camera": ["rear camera", "back camera"],
    "Front Camera": ["front camera", "selfie camera"],
    "Memory IC": ["emmc", "eprom", "nand"],
    "Charging Cable": ["charging cable", "usb cable", "type c cable", "lightning cable"],
    "OTG": ["otg"],
    "Screen Glass": ["screen glass"],
    "Adhesive": ["adhesive", "glue", "tape"],
    "Tool Kit": ["tool", "tools", "screw", "screwdriver", "tweezer", "spudger"],
  };

  static Future<Map<String, String>> classifyItem(String input) async {
    final url = "https://api.groq.com/openai/v1/chat/completions";

    final prompt =
        """
Fix the user input into clean spare part order format.

Rules:
- Keep item name clear
- Keep quantity if exists (x number)
- Correct spelling
- If possible, append the most likely item type at the end of the item name
  (examples: Battery, Display, Charging Port, Speaker, Bluetooth Speaker,
  Headphones, Power Bank, Tempered Glass, Cover, IC).
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
      final normalized = _ensureTypeSuffix(text.trim());

      return {"name": normalized};
    } else {
      throw Exception("AI failed: ${response.body}");
    }
  }

  static String _ensureTypeSuffix(String value) {
    final lower = value.toLowerCase();
    String? selectedType;

    for (final entry in _typeKeywords.entries) {
      for (final keyword in entry.value) {
        if (lower.contains(keyword)) {
          selectedType = entry.key;
          break;
        }
      }
      if (selectedType != null) break;
    }

    if (selectedType == null) return value;

    final typeLower = selectedType.toLowerCase();
    if (lower.contains(typeLower)) return value;

    return "$value $selectedType";
  }
}
