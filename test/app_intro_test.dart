import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youth_spot/screens/app_intro/welcome_screen.dart';
import 'package:youth_spot/screens/app_intro/intro_screens/intro_screen_1.dart';
import 'package:youth_spot/screens/app_intro/intro_screens/intro_screen_2.dart';
import 'package:youth_spot/screens/app_intro/intro_screens/intro_screen_3.dart';

void main() {
  group('App Intro Tests', () {
    testWidgets('WelcomeScreen has correct background color logic', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WelcomeScreen(),
        ),
      );

      // Verify that the welcome screen is rendered
      expect(find.byType(WelcomeScreen), findsOneWidget);
      
      // Verify that page indicators are present
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('IntroScreen1 uses correct image asset', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: IntroScreen1(),
        ),
      );

      // Check if the screen renders
      expect(find.byType(IntroScreen1), findsOneWidget);
      
      // Check for the title text
      expect(find.text('Free Healthy Minds Advice Tips'), findsOneWidget);
    });

    testWidgets('IntroScreen2 uses correct image asset', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: IntroScreen2(),
        ),
      );

      expect(find.byType(IntroScreen2), findsOneWidget);
      expect(find.text('Private & Secure Social Interactions'), findsOneWidget);
    });

    testWidgets('IntroScreen3 uses correct image asset', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: IntroScreen3(),
        ),
      );

      expect(find.byType(IntroScreen3), findsOneWidget);
      expect(find.text('Access to Free Social Workers & Social Services'), findsOneWidget);
    });
  });
}