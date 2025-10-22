import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthspot/config/theme_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeManager', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('ThemeManager should initialize with system theme by default', () {
      final themeManager = ThemeManager();
      
      expect(themeManager.themeMode.value, equals(ThemeMode.system));
      expect(themeManager.themePreference, equals(ThemePreference.system));
    });

    test('ThemeManager should set theme preference to light', () async {
      final themeManager = ThemeManager();
      
      await themeManager.setThemePreference(ThemePreference.light);
      
      expect(themeManager.themeMode.value, equals(ThemeMode.light));
      expect(themeManager.themePreference, equals(ThemePreference.light));
    });

    test('ThemeManager should set theme preference to dark', () async {
      final themeManager = ThemeManager();
      
      await themeManager.setThemePreference(ThemePreference.dark);
      
      expect(themeManager.themeMode.value, equals(ThemeMode.dark));
      expect(themeManager.themePreference, equals(ThemePreference.dark));
    });

    test('ThemeManager should set theme preference to system', () async {
      final themeManager = ThemeManager();
      
      await themeManager.setThemePreference(ThemePreference.system);
      
      expect(themeManager.themeMode.value, equals(ThemeMode.system));
      expect(themeManager.themePreference, equals(ThemePreference.system));
    });

    test('ThemeManager should persist theme preference', () async {
      SharedPreferences.setMockInitialValues({});
      final themeManager = ThemeManager();
      
      await themeManager.setThemePreference(ThemePreference.dark);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_preference'), equals('dark'));
    });

    test('ThemeManager should load saved theme preference on initialization', () async {
      SharedPreferences.setMockInitialValues({'theme_preference': 'light'});
      
      final themeManager = ThemeManager();
      
      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(themeManager.themePreference, equals(ThemePreference.light));
      expect(themeManager.themeMode.value, equals(ThemeMode.light));
    });

    test('ThemeManager toggleTheme should work for backward compatibility', () async {
      final themeManager = ThemeManager();
      
      themeManager.toggleTheme(true); // true = dark
      
      expect(themeManager.themeMode.value, equals(ThemeMode.dark));
      expect(themeManager.themePreference, equals(ThemePreference.dark));
      
      themeManager.toggleTheme(false); // false = light
      
      expect(themeManager.themeMode.value, equals(ThemeMode.light));
      expect(themeManager.themePreference, equals(ThemePreference.light));
    });
  });
}
