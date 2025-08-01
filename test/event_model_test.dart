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

    test('Event toJson should include ID fields when notificationId is not null', () {
      final now = DateTime.now();
      final event = Event(
        title: 'Test Event',
        description: 'Test Description',
        from: now,
        to: now.add(const Duration(hours: 1)),
        isAllDay: false,
        notificationId: 12345,
      );

      final json = event.toJson();

      expect(json[EventFields.id], equals(12345));
      expect(json[EventFields.notificationId], equals(12345));
      expect(json[EventFields.title], equals('Test Event'));
      expect(json[EventFields.description], equals('Test Description'));
      expect(json[EventFields.isAllDay], equals(0)); // false = 0
    });

    test('Event toJson should exclude ID fields when notificationId is null', () {
      final now = DateTime.now();
      final event = Event(
        title: 'Test Event',
        description: 'Test Description',
        from: now,
        to: now.add(const Duration(hours: 1)),
        isAllDay: false,
        // notificationId is null by default
      );

      final json = event.toJson();

      expect(json.containsKey(EventFields.id), false, 
        reason: '_id should not be included for new events');
      expect(json[EventFields.notificationId], equals(0),
        reason: 'notificationId should have placeholder value for new events');
      expect(json[EventFields.title], equals('Test Event'));
      expect(json[EventFields.description], equals('Test Description'));
      expect(json[EventFields.isAllDay], equals(0)); // false = 0
    });
  });
}