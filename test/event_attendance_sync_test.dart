import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:youthspot/db/models/event_model.dart';
import 'package:youthspot/models/community_event.dart';

void main() {
  group('Event Attendance Synchronization Tests', () {
    test('Personal calendar event should be created from community event correctly', () {
      // Test data - simulating a community event the user is attending
      final communityEvent = CommunityEvent(
        id: 'test-event-123',
        title: 'Youth Wellness Workshop',
        description: 'Interactive workshop focusing on mental health and wellness strategies for young adults.',
        eventDate: DateTime.parse('2025-02-15T10:00:00.000Z'),
        endDate: DateTime.parse('2025-02-15T16:00:00.000Z'),
        location: 'Community Center Hall A',
        organizer: 'YouthSpot Team',
        maxAttendees: 50,
        currentAttendees: 25,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
      );

      // Create a personal calendar event as would be done in sync
      final personalEvent = Event(
        title: communityEvent.title,
        description: '${communityEvent.description}\n\nLocation: ${communityEvent.location ?? 'TBD'}\nOrganizer: ${communityEvent.organizer ?? 'Unknown'}',
        from: communityEvent.eventDate,
        to: communityEvent.endDate ?? communityEvent.eventDate.add(const Duration(hours: 2)),
        backgroundColor: const Color(0xFF4CAF50), // Green for community events
        isAllDay: false,
      );

      // Verify the personal event was created correctly
      expect(personalEvent.title, equals(communityEvent.title));
      expect(personalEvent.from, equals(communityEvent.eventDate));
      expect(personalEvent.to, equals(communityEvent.endDate));
      expect(personalEvent.backgroundColor, equals(const Color(0xFF4CAF50)));
      expect(personalEvent.isAllDay, isFalse);
      
      // Verify description includes community event details
      expect(personalEvent.description, contains(communityEvent.description));
      expect(personalEvent.description, contains('Location: ${communityEvent.location}'));
      expect(personalEvent.description, contains('Organizer: ${communityEvent.organizer}'));
    });

    test('Personal calendar event should handle null end date correctly', () {
      final communityEvent = CommunityEvent(
        id: 'test-event-456',
        title: 'Career Development Seminar',
        description: 'Learn about career opportunities, resume building, and interview skills.',
        eventDate: DateTime.parse('2025-02-20T14:00:00.000Z'),
        endDate: null, // No end date specified
        location: 'Business Center Conference Room',
        organizer: 'Career Guidance Counselors',
        maxAttendees: 30,
        currentAttendees: 15,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
      );

      // Create personal event with default 2-hour duration
      final personalEvent = Event(
        title: communityEvent.title,
        description: '${communityEvent.description}\n\nLocation: ${communityEvent.location ?? 'TBD'}\nOrganizer: ${communityEvent.organizer ?? 'Unknown'}',
        from: communityEvent.eventDate,
        to: communityEvent.endDate ?? communityEvent.eventDate.add(const Duration(hours: 2)),
        backgroundColor: const Color(0xFF4CAF50),
        isAllDay: false,
      );

      // Verify default 2-hour duration is applied when endDate is null
      expect(personalEvent.from, equals(communityEvent.eventDate));
      expect(personalEvent.to, equals(communityEvent.eventDate.add(const Duration(hours: 2))));
      expect(personalEvent.to.difference(personalEvent.from).inHours, equals(2));
    });

    test('Personal calendar event should handle null location and organizer', () {
      final communityEvent = CommunityEvent(
        id: 'test-event-789',
        title: 'Online Peer Support Meeting',
        description: 'Virtual support group session.',
        eventDate: DateTime.parse('2025-03-01T18:00:00.000Z'),
        endDate: DateTime.parse('2025-03-01T20:00:00.000Z'),
        location: null, // Online event
        organizer: null, // No specific organizer
        maxAttendees: null, // Unlimited
        currentAttendees: 10,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
      );

      final personalEvent = Event(
        title: communityEvent.title,
        description: '${communityEvent.description}\n\nLocation: ${communityEvent.location ?? 'TBD'}\nOrganizer: ${communityEvent.organizer ?? 'Unknown'}',
        from: communityEvent.eventDate,
        to: communityEvent.endDate ?? communityEvent.eventDate.add(const Duration(hours: 2)),
        backgroundColor: const Color(0xFF4CAF50),
        isAllDay: false,
      );

      // Verify default values are used for null fields
      expect(personalEvent.description, contains('Location: TBD'));
      expect(personalEvent.description, contains('Organizer: Unknown'));
    });

    test('Event duplication check should work correctly', () {
      // Simulate existing personal calendar events
      final existingEvents = [
        Event(
          title: 'Youth Wellness Workshop',
          description: 'Some existing event',
          from: DateTime.parse('2025-02-15T10:00:00.000Z'),
          to: DateTime.parse('2025-02-15T16:00:00.000Z'),
          backgroundColor: Colors.blue,
          isAllDay: false,
        ),
        Event(
          title: 'Different Event',
          description: 'Another event',
          from: DateTime.parse('2025-02-16T10:00:00.000Z'),
          to: DateTime.parse('2025-02-16T16:00:00.000Z'),
          backgroundColor: Colors.red,
          isAllDay: false,
        ),
      ];

      final communityEvent = CommunityEvent(
        id: 'test-event-duplicate',
        title: 'Youth Wellness Workshop',
        description: 'Interactive workshop focusing on mental health',
        eventDate: DateTime.parse('2025-02-15T10:00:00.000Z'),
        endDate: DateTime.parse('2025-02-15T16:00:00.000Z'),
        location: 'Community Center',
        organizer: 'YouthSpot Team',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
      );

      // Check if event already exists (this logic would be used in syncAttendedEventsToCalendar)
      final existsInCalendar = existingEvents.any((personalEvent) =>
          personalEvent.title == communityEvent.title &&
          personalEvent.from == communityEvent.eventDate);

      // Should detect that this event already exists
      expect(existsInCalendar, isTrue);

      // Test with a different event that doesn't exist
      final newCommunityEvent = CommunityEvent(
        id: 'test-event-new',
        title: 'New Event',
        description: 'A brand new event',
        eventDate: DateTime.parse('2025-02-17T10:00:00.000Z'),
        endDate: DateTime.parse('2025-02-17T16:00:00.000Z'),
        location: 'New Location',
        organizer: 'New Organizer',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
      );

      final newEventExists = existingEvents.any((personalEvent) =>
          personalEvent.title == newCommunityEvent.title &&
          personalEvent.from == newCommunityEvent.eventDate);

      // Should detect that this is a new event
      expect(newEventExists, isFalse);
    });
  });
}