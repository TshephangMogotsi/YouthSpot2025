import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/db/models/event_model.dart';
import 'package:flutter/material.dart';

void main() {
  group('Event Join Fix Tests', () {
    test('Event with null notificationId should produce valid JSON for database insertion', () {
      // This test simulates the scenario when joining a community event
      // where a new Event is created with null notificationId
      final communityEvent = Event(
        title: 'Youth Coding Bootcamp',
        description: 'A free coding workshop for teens and young adults....',
        from: DateTime.parse('2025-08-15T10:00:00.000Z'),
        to: DateTime.parse('2025-08-15T12:00:00.000Z'),
        backgroundColor: const Color(0xFF4CAF50),
        isAllDay: false,
        // notificationId is null (default)
      );

      final json = communityEvent.toJson();

      // Verify that _id field is not included for new events (let database auto-generate)
      expect(json.containsKey(EventFields.id), false, 
        reason: '_id field should not be included for new events to allow auto-increment');
      
      // Verify that notificationId gets a placeholder value to satisfy NOT NULL constraint
      expect(json[EventFields.notificationId], equals(0),
        reason: 'notificationId should have placeholder value for new events');
      
      // Verify other fields are properly included
      expect(json[EventFields.title], equals('Youth Coding Bootcamp'));
      expect(json[EventFields.description], equals('A free coding workshop for teens and young adults....'));
      expect(json[EventFields.from], equals('2025-08-15T10:00:00.000Z'));
      expect(json[EventFields.to], equals('2025-08-15T12:00:00.000Z'));
      expect(json[EventFields.backgroundColor], equals(0xFF4CAF50));
      expect(json[EventFields.isAllDay], equals(0)); // false = 0
    });

    test('Event with notificationId should include ID fields in JSON', () {
      // This test ensures existing functionality still works
      final existingEvent = Event(
        title: 'Existing Event',
        description: 'An existing event with ID',
        from: DateTime.now(),
        to: DateTime.now().add(const Duration(hours: 2)),
        backgroundColor: Colors.blue,
        isAllDay: false,
        notificationId: 12345,
      );

      final json = existingEvent.toJson();

      // Verify that ID fields are included for existing events
      expect(json[EventFields.id], equals(12345));
      expect(json[EventFields.notificationId], equals(12345));
      
      // Verify other fields are properly included
      expect(json[EventFields.title], equals('Existing Event'));
      expect(json[EventFields.description], equals('An existing event with ID'));
    });

    test('Event roundtrip (toJson -> fromJson) should preserve data correctly', () {
      final originalEvent = Event(
        title: 'Roundtrip Test Event',
        description: 'Testing data preservation',
        from: DateTime.parse('2025-08-15T10:00:00.000Z'),
        to: DateTime.parse('2025-08-15T12:00:00.000Z'),
        backgroundColor: const Color(0xFF4CAF50),
        isAllDay: true,
        notificationId: 54321,
      );

      final json = originalEvent.toJson();
      final recreatedEvent = Event.fromJson(json);

      expect(recreatedEvent.title, equals(originalEvent.title));
      expect(recreatedEvent.description, equals(originalEvent.description));
      expect(recreatedEvent.from, equals(originalEvent.from));
      expect(recreatedEvent.to, equals(originalEvent.to));
      expect(recreatedEvent.backgroundColor, equals(originalEvent.backgroundColor));
      expect(recreatedEvent.isAllDay, equals(originalEvent.isAllDay));
      expect(recreatedEvent.notificationId, equals(originalEvent.notificationId));
    });

    test('Event roundtrip with null notificationId should work correctly', () {
      final originalEvent = Event(
        title: 'New Event Test',
        description: 'Testing null ID handling',
        from: DateTime.parse('2025-08-15T10:00:00.000Z'),
        to: DateTime.parse('2025-08-15T12:00:00.000Z'),
        backgroundColor: const Color(0xFF4CAF50),
        isAllDay: false,
        // notificationId is null
      );

      final json = originalEvent.toJson();
      
      // The toJson should set notificationId to 0 for new events
      expect(json[EventFields.notificationId], equals(0));
      expect(json.containsKey(EventFields.id), false);
      
      // Manually add _id field to simulate what the database would do after insertion
      final jsonWithId = Map<String, Object?>.from(json);
      jsonWithId[EventFields.id] = 123; // Simulated auto-generated _id
      
      final recreatedEvent = Event.fromJson(jsonWithId);

      expect(recreatedEvent.title, equals(originalEvent.title));
      expect(recreatedEvent.description, equals(originalEvent.description));
      expect(recreatedEvent.from, equals(originalEvent.from));
      expect(recreatedEvent.to, equals(originalEvent.to));
      expect(recreatedEvent.backgroundColor, equals(originalEvent.backgroundColor));
      expect(recreatedEvent.isAllDay, equals(originalEvent.isAllDay));
      expect(recreatedEvent.notificationId, equals(123)); // Should have the generated _id
    });
  });
}