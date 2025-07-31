import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/db/models/event_model.dart';

void main() {
  group('Event Model', () {
    test('Event should be created with notification ID', () {
      final now = DateTime.now();
      final event = Event(
        title: 'Test Event',
        description: 'Test Description',
        from: now,
        to: now.add(const Duration(hours: 1)),
        isAllDay: false,
        notificationId: 12345,
      );

      expect(event.title, equals('Test Event'));
      expect(event.description, equals('Test Description'));
      expect(event.notificationId, equals(12345));
      expect(event.isAllDay, equals(false));
      expect(event.from, equals(now));
      expect(event.to, equals(now.add(const Duration(hours: 1))));
    });

    test('Event should handle all-day events', () {
      final today = DateTime.now();
      final event = Event(
        title: 'All Day Event',
        description: 'All day description',
        from: today,
        to: today,
        isAllDay: true,
        notificationId: 67890,
      );

      expect(event.isAllDay, equals(true));
      expect(event.notificationId, equals(67890));
    });
  });
}