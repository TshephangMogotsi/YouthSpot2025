import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthspot/config/theme_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeManager', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('should initialize with system theme mode by default', () {
      final themeManager = ThemeManager();
      expect(themeManager.themeMode.value, ThemeMode.system);
    });

    test('should set theme mode to light', () async {
      final themeManager = ThemeManager();
      await themeManager.setThemeMode(ThemeMode.light);
      expect(themeManager.themeMode.value, ThemeMode.light);
    });

    test('should set theme mode to dark', () async {
      final themeManager = ThemeManager();
      await themeManager.setThemeMode(ThemeMode.dark);
      expect(themeManager.themeMode.value, ThemeMode.dark);
    });

    test('should set theme mode to system', () async {
      final themeManager = ThemeManager();
      await themeManager.setThemeMode(ThemeMode.system);
      expect(themeManager.themeMode.value, ThemeMode.system);
    });

    test('should persist theme preference to light', () async {
      final themeManager = ThemeManager();
      await themeManager.setThemeMode(ThemeMode.light);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode_preference'), 'light');
    });

    test('should persist theme preference to dark', () async {
      final themeManager = ThemeManager();
      await themeManager.setThemeMode(ThemeMode.dark);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode_preference'), 'dark');
    });

    test('should persist theme preference to system', () async {
      final themeManager = ThemeManager();
      await themeManager.setThemeMode(ThemeMode.system);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode_preference'), 'system');
    });

    test('should load saved theme preference (light)', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode_preference': 'light',
      });
      
      final themeManager = ThemeManager();
      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));
      expect(themeManager.themeMode.value, ThemeMode.light);
    });

    test('should load saved theme preference (dark)', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode_preference': 'dark',
      });
      
      final themeManager = ThemeManager();
      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));
      expect(themeManager.themeMode.value, ThemeMode.dark);
    });

    test('should load saved theme preference (system)', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode_preference': 'system',
      });
      
      final themeManager = ThemeManager();
      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));
      expect(themeManager.themeMode.value, ThemeMode.system);
    });

    test('legacy toggleTheme method should work for backward compatibility', () async {
      final themeManager = ThemeManager();
      
      // Toggle to dark
      themeManager.toggleTheme(true);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(themeManager.themeMode.value, ThemeMode.dark);
      
      // Toggle to light
      themeManager.toggleTheme(false);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(themeManager.themeMode.value, ThemeMode.light);
    });

    test('should notify listeners when theme changes', () async {
      final themeManager = ThemeManager();
      var notificationCount = 0;
      
      themeManager.addListener(() {
        notificationCount++;
      });
      
      await themeManager.setThemeMode(ThemeMode.dark);
      expect(notificationCount, greaterThan(0));
    });
  });
}
