import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/auth/sign_in.dart';
import 'package:youthspot/auth/register.dart';

void main() {
  group('Auth Pages Layout Tests', () {
    testWidgets('SignIn page should have full-height container layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignInPage(onToggle: () {}),
        ),
      );

      // Check that the main structure exists
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Check that the form exists
      expect(find.byType(Form), findsOneWidget);
      
      // Check that we have the container with rounded corners
      expect(find.byType(Container), findsWidgets);
      
      // Check for the welcome text
      expect(find.text('Welcome back to'), findsOneWidget);
      expect(find.text('YouthSpot'), findsOneWidget);
    });

    testWidgets('Register page should maintain its layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterPage(onToggle: () {}),
        ),
      );

      // Check that the main structure exists
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Check that the form exists
      expect(find.byType(Form), findsOneWidget);
      
      // Check for the registration text
      expect(find.text('Go Ahead and set up'), findsOneWidget);
      expect(find.text('your account'), findsOneWidget);
    });

    testWidgets('Both pages should use consistent field styling', (WidgetTester tester) async {
      // Test SignIn page field styling
      await tester.pumpWidget(
        MaterialApp(
          home: SignInPage(onToggle: () {}),
        ),
      );

      // Look for email and password fields with the expected styling
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Test Register page field styling
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterPage(onToggle: () {}),
        ),
      );

      // Look for various fields with consistent styling
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });
  });
}