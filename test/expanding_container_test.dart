import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/screens/services/expanding_container.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:youthspot/config/theme_manager.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('ExpandingContainer', () {
    late ThemeManager mockThemeManager;

    setUp(() {
      // Clear any existing registrations
      if (GetIt.instance.isRegistered<ThemeManager>()) {
        GetIt.instance.unregister<ThemeManager>();
      }

      // Create a mock ThemeManager
      mockThemeManager = ThemeManager();
      GetIt.instance.registerSingleton<ThemeManager>(mockThemeManager);
    });

    tearDown(() {
      GetIt.instance.reset();
    });

    testWidgets('hasLocationData returns true when URL is provided', (WidgetTester tester) async {
      final isExpanded = ValueNotifier<bool>(false);
      
      const widget = ExpandingContainer(
        isExpanded: ValueNotifier<bool>(false),
        location: 'Test Location',
        latitude: 0.0,
        longitude: 0.0,
        locationUrl: 'https://www.google.com/maps/place/test',
        contact: 'Test Contact',
      );

      expect(widget.hasLocationData, isTrue);
    });

    testWidgets('hasLocationData returns true when coordinates are provided', (WidgetTester tester) async {
      const widget = ExpandingContainer(
        isExpanded: ValueNotifier<bool>(false),
        location: 'Test Location',
        latitude: 25.7479,
        longitude: 28.2293,
        contact: 'Test Contact',
      );

      expect(widget.hasLocationData, isTrue);
    });

    testWidgets('hasLocationData returns true when both URL and coordinates are provided', (WidgetTester tester) async {
      const widget = ExpandingContainer(
        isExpanded: ValueNotifier<bool>(false),
        location: 'Test Location',
        latitude: 25.7479,
        longitude: 28.2293,
        locationUrl: 'https://www.google.com/maps/place/test',
        contact: 'Test Contact',
      );

      expect(widget.hasLocationData, isTrue);
    });

    testWidgets('hasLocationData returns false when neither URL nor coordinates are provided', (WidgetTester tester) async {
      const widget = ExpandingContainer(
        isExpanded: ValueNotifier<bool>(false),
        location: 'Test Location',
        latitude: 0.0,
        longitude: 0.0,
        contact: 'Test Contact',
      );

      expect(widget.hasLocationData, isFalse);
    });

    testWidgets('hasLocationData returns false when URL is empty', (WidgetTester tester) async {
      const widget = ExpandingContainer(
        isExpanded: ValueNotifier<bool>(false),
        location: 'Test Location',
        latitude: 0.0,
        longitude: 0.0,
        locationUrl: '',
        contact: 'Test Contact',
      );

      expect(widget.hasLocationData, isFalse);
    });

    testWidgets('displays correct button text when location data is available', (WidgetTester tester) async {
      final isExpanded = ValueNotifier<bool>(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandingContainer(
              isExpanded: isExpanded,
              location: 'Test Location',
              latitude: 25.7479,
              longitude: 28.2293,
              locationUrl: 'https://www.google.com/maps/place/test',
              contact: 'Test Contact',
            ),
          ),
        ),
      );

      expect(find.text('Open Maps'), findsOneWidget);
    });

    testWidgets('displays "No Location" when no location data is available', (WidgetTester tester) async {
      final isExpanded = ValueNotifier<bool>(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandingContainer(
              isExpanded: isExpanded,
              location: 'Test Location',
              latitude: 0.0,
              longitude: 0.0,
              contact: 'Test Contact',
            ),
          ),
        ),
      );

      expect(find.text('No Location'), findsOneWidget);
    });
  });
}