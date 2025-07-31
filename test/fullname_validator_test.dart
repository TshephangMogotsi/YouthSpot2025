import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/auth/fullname_validator.dart';

void main() {
  group('FullNameValidator Tests', () {
    test('should return null for valid full names', () {
      expect(FullNameValidator.validate('John Doe'), null);
      expect(FullNameValidator.validate('Mary Jane Smith'), null);
      expect(FullNameValidator.validate("O'Connor McKenna"), null);
      expect(FullNameValidator.validate('Jean-Pierre Dubois'), null);
    });

    test('should return error for empty or null names', () {
      expect(FullNameValidator.validate(null), 'Please enter your full name');
      expect(FullNameValidator.validate(''), 'Please enter your full name');
      expect(FullNameValidator.validate('   '), 'Please enter your full name');
    });

    test('should return error for single names', () {
      expect(FullNameValidator.validate('John'), 'Please enter both first and last name');
    });

    test('should return error for short name parts', () {
      expect(FullNameValidator.validate('A B'), 'Each name must be at least 2 characters long');
    });

    test('should return error for invalid characters', () {
      expect(FullNameValidator.validate('John123 Doe'), 'Name can only contain letters, spaces, hyphens, and apostrophes');
      expect(FullNameValidator.validate('John@Doe'), 'Name can only contain letters, spaces, hyphens, and apostrophes');
    });
  });
}