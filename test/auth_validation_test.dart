import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/auth/fullname_validator.dart';

void main() {
  group('Authentication Validation Tests', () {
    group('Email Validation', () {
      test('should accept valid email addresses', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.za',
          'user+tag@domain.org',
          'firstname.lastname@subdomain.domain.com',
        ];

        for (final email in validEmails) {
          final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          expect(emailRegex.hasMatch(email.trim()), true, reason: 'Email $email should be valid');
        }
      });

      test('should reject invalid email addresses', () {
        final invalidEmails = [
          'invalid-email',
          'user@',
          '@domain.com',
          'user@domain',
          'user@.com',
          'user space@domain.com',
          '',
          '  ',
        ];

        for (final email in invalidEmails) {
          final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          expect(emailRegex.hasMatch(email.trim()), false, reason: 'Email $email should be invalid');
        }
      });
    });

    group('Password Validation', () {
      test('should accept valid passwords', () {
        final validPasswords = [
          'password1',
          'Hello123',
          'Test@123',
          'StrongPass1',
          'MyP@ssw0rd',
        ];

        for (final password in validPasswords) {
          // Password must be at least 6 characters and contain at least one letter and one number
          final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
          expect(password.trim().length >= 6, true, reason: 'Password $password should be at least 6 characters');
          expect(passwordRegex.hasMatch(password.trim()), true, reason: 'Password $password should contain letters and numbers');
        }
      });

      test('should reject invalid passwords', () {
        final invalidPasswords = [
          'short', // Too short
          '12345', // No letters
          'password', // No numbers
          'ABCDEF', // No numbers
          '', // Empty
          '  ', // Whitespace only
        ];

        for (final password in invalidPasswords) {
          final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
          final isValidLength = password.trim().length >= 6;
          final hasLettersAndNumbers = passwordRegex.hasMatch(password.trim());
          
          expect(isValidLength && hasLettersAndNumbers, false, 
              reason: 'Password $password should be invalid (length: ${password.length}, has letters+numbers: $hasLettersAndNumbers)');
        }
      });
    });

    group('Username Validation', () {
      test('should accept valid usernames', () {
        final validUsernames = [
          'user123',
          'test_user',
          'UserName',
          'user_123',
          'TestUser1',
        ];

        for (final username in validUsernames) {
          final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
          expect(username.trim().length >= 3, true, reason: 'Username $username should be at least 3 characters');
          expect(usernameRegex.hasMatch(username.trim()), true, reason: 'Username $username should contain only valid characters');
        }
      });

      test('should reject invalid usernames', () {
        final invalidUsernames = [
          'us', // Too short
          'user name', // Contains space
          'user-name', // Contains hyphen
          'user@name', // Contains special character
          '', // Empty
          '  ', // Whitespace only
        ];

        for (final username in invalidUsernames) {
          final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
          final isValidLength = username.trim().length >= 3;
          final hasValidChars = usernameRegex.hasMatch(username.trim());
          
          expect(isValidLength && hasValidChars, false, 
              reason: 'Username $username should be invalid (length: ${username.length}, valid chars: $hasValidChars)');
        }
      });
    });

    group('Full Name Validation', () {
      test('should accept valid full names', () {
        final validNames = [
          'John Doe',
          'Mary Jane Smith',
          'Jean-Pierre van der Berg',
          'O\'Connor McBride',
        ];

        for (final name in validNames) {
          final result = FullNameValidator.validate(name);
          expect(result, null, reason: 'Name $name should be valid');
        }
      });

      test('should reject invalid full names', () {
        final invalidNames = [
          '', // Empty
          '  ', // Whitespace only
          'John', // Only first name
          'a', // Too short
          '123', // Numbers only
        ];

        for (final name in invalidNames) {
          final result = FullNameValidator.validate(name);
          expect(result, isNotNull, reason: 'Name $name should be invalid');
        }
      });
    });
  });

  group('Form Validation Integration', () {
    test('should validate complete registration form data', () {
      final validFormData = {
        'email': 'test@example.com',
        'password': 'TestPass123',
        'confirmPassword': 'TestPass123',
        'username': 'testuser123',
        'fullName': 'Test User Name',
      };

      // Email validation
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      expect(emailRegex.hasMatch(validFormData['email']!.trim()), true);

      // Password validation
      final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
      expect(validFormData['password']!.trim().length >= 6, true);
      expect(passwordRegex.hasMatch(validFormData['password']!.trim()), true);

      // Password confirmation
      expect(validFormData['password']!.trim(), validFormData['confirmPassword']!.trim());

      // Username validation
      final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
      expect(validFormData['username']!.trim().length >= 3, true);
      expect(usernameRegex.hasMatch(validFormData['username']!.trim()), true);

      // Full name validation
      expect(FullNameValidator.validate(validFormData['fullName']!), null);
    });
  });
}