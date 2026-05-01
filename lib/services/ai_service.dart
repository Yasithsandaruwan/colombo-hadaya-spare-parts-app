import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey =
  "####################################################################";

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
      final withModel = _ensureModelPrefix(input, normalized);

      return {"name": withModel};
    } else {
      throw Exception("AI failed: ${response.body}");
    }
  }

  static String _ensureModelPrefix(String rawInput, String value) {
    final model = _extractModelPrefix(rawInput);
    if (model.isEmpty) return value;

    final lowerValue = value.toLowerCase();
    final lowerModel = model.toLowerCase();
    if (lowerValue.contains(lowerModel)) return value;

    return "$model $value";
  }

  static String _extractModelPrefix(String input) {
    final lower = input.toLowerCase();

    final samsungM = RegExp(r"\bm\s?(\d{1,3})\b");
    final samsungA = RegExp(r"\ba\s?(\d{1,3})\b");
    final samsungS = RegExp(r"\bs\s?(\d{1,3})\b");
    final samsungNote = RegExp(r"\bnote\s?(\d{1,3})\b");
    final samsungGalaxy = RegExp(r"\bgalaxy\s?([a-z]*\d{1,3})\b");

    final iphone = RegExp(r"\biphone\s?(\d{1,2}|x|xr|xs|xs max|se)\b");
    final pixel = RegExp(r"\bpixel\s?(\d{1,2})\b");
    final redmi = RegExp(r"\bredmi\s?(\w+)?\b");
    final mi = RegExp(r"\bmi\s?(\d{1,2})\b");
    final poco = RegExp(r"\bpoco\s?(\w+)?\b");
    final oneplus = RegExp(r"\boneplus\s?(\w+)?\b");
    final realme = RegExp(r"\brealme\s?(\w+)?\b");
    final oppo = RegExp(r"\boppo\s?(\w+)?\b");
    final vivo = RegExp(r"\bvivo\s?(\w+)?\b");
    final huawei = RegExp(r"\bhuawei\s?(\w+)?\b");
    final honor = RegExp(r"\bhonor\s?(\w+)?\b");
    final motorola = RegExp(r"\bmoto\s?(\w+)?\b|\bmotorola\s?(\w+)?\b");
    final nokia = RegExp(r"\bnokia\s?(\w+)?\b");
    final sony = RegExp(r"\bsony\s?(xperia\s?\w+)?\b");
    final lg = RegExp(r"\blg\s?(\w+)?\b");
    final tecno = RegExp(r"\btecno\s?(\w+)?\b");
    final infinix = RegExp(r"\binfinix\s?(\w+)?\b");
    final itel = RegExp(r"\bitel\s?(\w+)?\b");
    final asus = RegExp(r"\basus\s?(zenfone\s?\w+)?\b");
    final zte = RegExp(r"\bzte\s?(\w+)?\b");
    final alcatel = RegExp(r"\balcatel\s?(\w+)?\b");
    final lenovo = RegExp(r"\blenovo\s?(\w+)?\b");
    final blackview = RegExp(r"\bblackview\s?(\w+)?\b");

    Match? match;

    match = samsungM.firstMatch(lower);
    if (match != null) return "Samsung Galaxy M${match.group(1)}";

    match = samsungA.firstMatch(lower);
    if (match != null) return "Samsung Galaxy A${match.group(1)}";

    match = samsungS.firstMatch(lower);
    if (match != null) return "Samsung Galaxy S${match.group(1)}";

    match = samsungNote.firstMatch(lower);
    if (match != null) return "Samsung Galaxy Note ${match.group(1)}";

    match = samsungGalaxy.firstMatch(lower);
    if (match != null) return "Samsung Galaxy ${match.group(1)}";

    match = iphone.firstMatch(lower);
    if (match != null) {
      final model = match.group(1) ?? "";
      return "Apple iPhone ${model.toUpperCase()}".trim();
    }

    match = pixel.firstMatch(lower);
    if (match != null) return "Google Pixel ${match.group(1)}";

    match = redmi.firstMatch(lower);
    if (match != null) return "Xiaomi Redmi";

    match = mi.firstMatch(lower);
    if (match != null) return "Xiaomi Mi ${match.group(1)}";

    match = poco.firstMatch(lower);
    if (match != null) return "Xiaomi Poco";

    match = oneplus.firstMatch(lower);
    if (match != null) return "OnePlus";

    match = realme.firstMatch(lower);
    if (match != null) return "Realme";

    match = oppo.firstMatch(lower);
    if (match != null) return "Oppo";

    match = vivo.firstMatch(lower);
    if (match != null) return "Vivo";

    match = huawei.firstMatch(lower);
    if (match != null) return "Huawei";

    match = honor.firstMatch(lower);
    if (match != null) return "Honor";

    match = motorola.firstMatch(lower);
    if (match != null) return "Motorola";

    match = nokia.firstMatch(lower);
    if (match != null) return "Nokia";

    match = sony.firstMatch(lower);
    if (match != null) return "Sony Xperia";

    match = lg.firstMatch(lower);
    if (match != null) return "LG";

    match = tecno.firstMatch(lower);
    if (match != null) return "Tecno";

    match = infinix.firstMatch(lower);
    if (match != null) return "Infinix";

    match = itel.firstMatch(lower);
    if (match != null) return "Itel";

    match = asus.firstMatch(lower);
    if (match != null) return "Asus";

    match = zte.firstMatch(lower);
    if (match != null) return "ZTE";

    match = alcatel.firstMatch(lower);
    if (match != null) return "Alcatel";

    match = lenovo.firstMatch(lower);
    if (match != null) return "Lenovo";

    match = blackview.firstMatch(lower);
    if (match != null) return "Blackview";

    return "";
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
