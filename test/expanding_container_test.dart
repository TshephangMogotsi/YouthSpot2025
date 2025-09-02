import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    testWidgets('shows copy icon for valid phone numbers', (WidgetTester tester) async {
      final isExpanded = ValueNotifier<bool>(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandingContainer(
              isExpanded: isExpanded,
              location: 'Test Location',
              latitude: 0.0,
              longitude: 0.0,
              contact: '1234567890',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.content_copy), findsOneWidget);
    });

    testWidgets('shows disabled phone icon for "no contact" cases', (WidgetTester tester) async {
      final isExpanded = ValueNotifier<bool>(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandingContainer(
              isExpanded: isExpanded,
              location: 'Test Location',
              latitude: 0.0,
              longitude: 0.0,
              contact: 'No contact available',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.phone_disabled), findsOneWidget);
    });

    testWidgets('clipboard functionality works correctly', (WidgetTester tester) async {
      // Mock the clipboard
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') {
          // Expect the dialable format (+267 prefix added for 7-digit numbers)
          expect(call.arguments['text'], '+2671234567');
          return;
        }
        return null;
      });

      final isExpanded = ValueNotifier<bool>(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandingContainer(
              isExpanded: isExpanded,
              location: 'Test Location',
              latitude: 0.0,
              longitude: 0.0,
              contact: '1234567',
            ),
          ),
        ),
      );

      // Tap the copy icon to copy the number
      await tester.tap(find.byType(Image).last); // Copy icon is the last Image widget
      await tester.pump();

      // Cleanup
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets('displays formatted phone number correctly', (WidgetTester tester) async {
      final isExpanded = ValueNotifier<bool>(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandingContainer(
              isExpanded: isExpanded,
              location: 'Test Location',
              latitude: 0.0,
              longitude: 0.0,
              contact: '6843242', // 7-digit number should be formatted as "684 3242"
            ),
          ),
        ),
      );

      // Check that the formatted number is displayed
      expect(find.text('684 3242'), findsOneWidget);
    });

    testWidgets('removes +267 prefix from displayed number', (WidgetTester tester) async {
      final isExpanded = ValueNotifier<bool>(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandingContainer(
              isExpanded: isExpanded,
              location: 'Test Location',
              latitude: 0.0,
              longitude: 0.0,
              contact: '+2676843242', // Should display as "684 3242"
            ),
          ),
        ),
      );

      // Check that the formatted number is displayed without +267
      expect(find.text('684 3242'), findsOneWidget);
      expect(find.text('+2676843242'), findsNothing);
    });
  });
}