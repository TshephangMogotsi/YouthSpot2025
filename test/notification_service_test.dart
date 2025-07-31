import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/screens/homepage/my_spot/config/utils.dart';

void main() {
  group('NotificationUtils', () {
    test('formatEventTime should format same day events correctly', () {
      final from = DateTime(2025, 1, 15, 9, 0);
      final to = DateTime(2025, 1, 15, 17, 30);
      
      final result = NotificationUtils.formatEventTime(from, to);
      
      expect(result, equals('9:00 AM - 5:30 PM'));
    });

    test('formatEventTime should format multi-day events correctly', () {
      final from = DateTime(2025, 1, 15, 9, 0);
      final to = DateTime(2025, 1, 16, 17, 30);
      
      final result = NotificationUtils.formatEventTime(from, to);
      
      expect(result, equals('Jan 15, 9:00 AM - Jan 16, 5:30 PM'));
    });

    test('formatEventTime should handle midnight times correctly', () {
      final from = DateTime(2025, 1, 15, 0, 0);
      final to = DateTime(2025, 1, 15, 23, 59);
      
      final result = NotificationUtils.formatEventTime(from, to);
      
      expect(result, equals('12:00 AM - 11:59 PM'));
    });
  });
}