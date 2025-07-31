import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/main.dart';

void main() {
  group('App initialization', () {
    testWidgets('MyApp should initialize with proper navigator key', (WidgetTester tester) async {
      // Test that the app can be created and has a navigator key
      expect(MyApp.navigatorKey, isA<GlobalKey<NavigatorState>>());
    });

    testWidgets('MyApp should build without errors', (WidgetTester tester) async {
      // This test will fail if there are any issues with the notification initialization
      // or other startup processes that cause exceptions
      await tester.pumpWidget(const MyApp());
      
      // If we get here without an exception, the basic initialization worked
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}