import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
  static const String _themePreferenceKey = 'theme_mode_preference';

  ThemeManager() {
    // Listen to the value notifier and notify listeners when it changes
    themeMode.addListener(() {
      notifyListeners();
    });
    // Load saved theme preference
    _loadThemePreference();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePreferenceKey);
      
      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            themeMode.value = ThemeMode.light;
            break;
          case 'dark':
            themeMode.value = ThemeMode.dark;
            break;
          case 'system':
            themeMode.value = ThemeMode.system;
            break;
        }
      }
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeString;
      
      switch (mode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }
      
      await prefs.setString(_themePreferenceKey, themeString);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _saveThemePreference(mode);
  }

  // Legacy method for backward compatibility
  void toggleTheme(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  void dispose() {
    themeMode.dispose();
    super.dispose();
  }
}
