import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/global_widgets/field_with_live_validation.dart';

void main() {
  group('FieldWithLiveValidation Widget Tests', () {
    testWidgets('should display title and hint text correctly', (WidgetTester tester) async {
      final controller = TextEditingController();
      String? validationResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldWithLiveValidation(
              title: "Test Title",
              hintText: "Test Hint",
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Field is required";
                }
                return null;
              },
            ),
          ),
        ),
      );

      // Check if title is displayed
      expect(find.text('Test Title'), findsOneWidget);
      
      // Check if hint text is displayed
      expect(find.text('Test Hint'), findsOneWidget);
    });

    testWidgets('should show error text when provided', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldWithLiveValidation(
              title: "Test Title",
              hintText: "Test Hint",
              controller: controller,
              errorText: "This field has an error",
              validator: (value) => null,
            ),
          ),
        ),
      );

      // Check if error text is displayed
      expect(find.text('This field has an error'), findsOneWidget);
    });

    testWidgets('should toggle password visibility when trailing icon is pressed', (WidgetTester tester) async {
      final controller = TextEditingController();
      bool isObscured = true;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: FieldWithLiveValidation(
                  title: "Password",
                  hintText: "Enter password",
                  controller: controller,
                  isPassword: isObscured,
                  trailingIcon: isObscured ? Icons.visibility_off : Icons.visibility,
                  onTrailingPressed: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                  validator: (value) => null,
                ),
              ),
            );
          },
        ),
      );

      // Check if the visibility off icon is initially displayed
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      
      // Tap the icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Check if the visibility icon is now displayed
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should call onChanged when text is entered', (WidgetTester tester) async {
      final controller = TextEditingController();
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldWithLiveValidation(
              title: "Test Title",
              hintText: "Test Hint",
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
              validator: (value) => null,
            ),
          ),
        ),
      );

      // Enter text in the field
      await tester.enterText(find.byType(TextFormField), 'test input');
      
      // Verify onChanged was called with the correct value
      expect(changedValue, 'test input');
      expect(controller.text, 'test input');
    });
  });

  group('DropdownWithLiveValidation Widget Tests', () {
    testWidgets('should display title and dropdown correctly', (WidgetTester tester) async {
      final items = ['Option 1', 'Option 2', 'Option 3'];
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownWithLiveValidation(
              title: "Dropdown Title",
              hintText: "Select an option",
              value: selectedValue,
              items: items,
              onChanged: (value) {
                selectedValue = value;
              },
            ),
          ),
        ),
      );

      // Check if title is displayed
      expect(find.text('Dropdown Title'), findsOneWidget);
      
      // Check if hint text is displayed
      expect(find.text('Select an option'), findsOneWidget);
    });

    testWidgets('should show error text when provided', (WidgetTester tester) async {
      final items = ['Option 1', 'Option 2', 'Option 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownWithLiveValidation(
              title: "Dropdown Title",
              hintText: "Select an option",
              value: null,
              items: items,
              errorText: "Please select an option",
            ),
          ),
        ),
      );

      // Check if error text is displayed
      expect(find.text('Please select an option'), findsOneWidget);
    });
  });
}