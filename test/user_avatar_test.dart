import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/global_widgets/user_avatar.dart';

void main() {
  group('UserAvatar', () {
    test('getInitials should extract correct initials from full name', () {
      // Test with full name
      expect(UserAvatar.getInitials('John Doe'), equals('JD'));
      
      // Test with single name
      expect(UserAvatar.getInitials('John'), equals('J'));
      
      // Test with empty string
      expect(UserAvatar.getInitials(''), equals('?'));
      
      // Test with whitespace only
      expect(UserAvatar.getInitials('   '), equals('?'));
      
      // Test with multiple names
      expect(UserAvatar.getInitials('John Michael Doe'), equals('JD'));
      
      // Test with lowercase
      expect(UserAvatar.getInitials('john doe'), equals('JD'));
      
      // Test with extra whitespace
      expect(UserAvatar.getInitials('  John   Doe  '), equals('JD'));
    });
  });
}