import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  ThemeManager() {
    // Listen to the value notifier and notify listeners when it changes
    themeMode.addListener(() {
      notifyListeners();
    });
  }

  toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void dispose() {
    themeMode.dispose();
    super.dispose();
  }
}
