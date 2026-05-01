import 'package:flutter/material.dart';

class ThemeService {
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static void toggle(Brightness currentBrightness) {
    final isDark = mode.value == ThemeMode.dark ||
        (mode.value == ThemeMode.system &&
            currentBrightness == Brightness.dark);
    mode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}
