import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference { light, dark, system }

class ThemeManager extends ChangeNotifier {
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
  ThemePreference _themePreference = ThemePreference.system;

  ThemeManager() {
    // Listen to the value notifier and notify listeners when it changes
    themeMode.addListener(() {
      notifyListeners();
    });
    _loadThemePreference();
  }

  ThemePreference get themePreference => _themePreference;

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('theme_preference') ?? 'system';
      
      switch (savedTheme) {
        case 'light':
          _themePreference = ThemePreference.light;
          themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          _themePreference = ThemePreference.dark;
          themeMode.value = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themePreference = ThemePreference.system;
          themeMode.value = ThemeMode.system;
          break;
      }
      notifyListeners();
    } catch (e) {
      // If loading fails, default to system
      _themePreference = ThemePreference.system;
      themeMode.value = ThemeMode.system;
    }
  }

  Future<void> setThemePreference(ThemePreference preference) async {
    _themePreference = preference;
    
    switch (preference) {
      case ThemePreference.light:
        themeMode.value = ThemeMode.light;
        break;
      case ThemePreference.dark:
        themeMode.value = ThemeMode.dark;
        break;
      case ThemePreference.system:
        themeMode.value = ThemeMode.system;
        break;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_preference', preference.name);
    } catch (e) {
      // Handle error silently - theme still works without persistence
    }
    
    notifyListeners();
  }

  // Kept for backward compatibility
  toggleTheme(bool isDark) {
    setThemePreference(isDark ? ThemePreference.dark : ThemePreference.light);
  }

  @override
  void dispose() {
    themeMode.dispose();
    super.dispose();
  }
}
