import 'package:flutter/material.dart';

class ThemeManager {
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
