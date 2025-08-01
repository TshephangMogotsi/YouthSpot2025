import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:youthspot/db/models/event_model.dart';
import 'package:youthspot/models/community_event.dart';

void main() {
  group('Event Cancel Attendance Tests', () {
    test('Cancel attendance should properly identify matching personal calendar events', () {
      // Test the logic used in leaveEvent method to find matching personal calendar events
      
      // Create a community event that user is attending
      final communityEvent = CommunityEvent(
        id: 'community-event-123',
        title: 'Youth Wellness Workshop',
        description: 'Interactive workshop focusing on mental health and wellness strategies.',
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

      // Create personal calendar events (simulating existing calendar)
      final personalEvents = [
        Event(
          notificationId: 1,
          title: 'Youth Wellness Workshop', // Matches community event
          description: 'Personal calendar event for community event',
          from: DateTime.parse('2025-02-15T10:00:00.000Z'), // Matches community event
          to: DateTime.parse('2025-02-15T16:00:00.000Z'),
          backgroundColor: const Color(0xFF4CAF50),
          isAllDay: false,
        ),
        Event(
          notificationId: 2,
          title: 'Different Event',
          description: 'Another personal event',
          from: DateTime.parse('2025-02-16T10:00:00.000Z'),
          to: DateTime.parse('2025-02-16T16:00:00.000Z'),
          backgroundColor: Colors.blue,
          isAllDay: false,
        ),
        Event(
          notificationId: 3,
          title: 'Youth Wellness Workshop', // Same title but different date
          description: 'Different instance of similar event',
          from: DateTime.parse('2025-02-22T10:00:00.000Z'), // Different date
          to: DateTime.parse('2025-02-22T16:00:00.000Z'),
          backgroundColor: Colors.red,
          isAllDay: false,
        ),
      ];

      // Test the matching logic used in leaveEvent
      final matchingEvents = personalEvents
          .where((event) => 
              event.title == communityEvent.title &&
              event.from == communityEvent.eventDate)
          .toList();

      // Should find exactly one matching event
      expect(matchingEvents.length, equals(1));
      expect(matchingEvents.first.notificationId, equals(1));
      expect(matchingEvents.first.title, equals('Youth Wellness Workshop'));
      expect(matchingEvents.first.from, equals(DateTime.parse('2025-02-15T10:00:00.000Z')));
    });

    test('Cancel attendance should handle case where no matching personal calendar event exists', () {
      // Test scenario where user is marked as attending but no personal calendar event exists
      // This could happen if calendar was manually cleared or corrupted
      
      final communityEvent = CommunityEvent(
        id: 'community-event-456',
        title: 'Career Development Seminar',
        description: 'Learn about career opportunities and interview skills.',
        eventDate: DateTime.parse('2025-02-20T14:00:00.000Z'),
        endDate: DateTime.parse('2025-02-20T18:00:00.000Z'),
        location: 'Business Center',
        organizer: 'Career Counselors',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
      );

      // Personal calendar with no matching events
      final personalEvents = [
        Event(
          notificationId: 1,
          title: 'Different Event',
          description: 'Some other event',
          from: DateTime.parse('2025-02-16T10:00:00.000Z'),
          to: DateTime.parse('2025-02-16T16:00:00.000Z'),
          backgroundColor: Colors.blue,
          isAllDay: false,
        ),
      ];

      // Test the matching logic
      final matchingEvents = personalEvents
          .where((event) => 
              event.title == communityEvent.title &&
              event.from == communityEvent.eventDate)
          .toList();

      // Should find no matching events
      expect(matchingEvents.length, equals(0));
    });

    test('Cancel attendance should handle multiple matching events gracefully', () {
      // Test edge case where there might be duplicate personal calendar events
      
      final communityEvent = CommunityEvent(
        id: 'community-event-789',
        title: 'Mental Health Support Group',
        description: 'Safe space for youth to share experiences.',
        eventDate: DateTime.parse('2025-02-25T18:00:00.000Z'),
        endDate: DateTime.parse('2025-02-25T20:00:00.000Z'),
        location: 'Wellness Center',
        organizer: 'Licensed Therapists',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
      );

      // Personal calendar with duplicate events (edge case)
      final personalEvents = [
        Event(
          notificationId: 1,
          title: 'Mental Health Support Group',
          description: 'First instance',
          from: DateTime.parse('2025-02-25T18:00:00.000Z'),
          to: DateTime.parse('2025-02-25T20:00:00.000Z'),
          backgroundColor: const Color(0xFF4CAF50),
          isAllDay: false,
        ),
        Event(
          notificationId: 2,
          title: 'Mental Health Support Group',
          description: 'Duplicate instance',
          from: DateTime.parse('2025-02-25T18:00:00.000Z'),
          to: DateTime.parse('2025-02-25T20:00:00.000Z'),
          backgroundColor: const Color(0xFF4CAF50),
          isAllDay: false,
        ),
      ];

      // Test the matching logic
      final matchingEvents = personalEvents
          .where((event) => 
              event.title == communityEvent.title &&
              event.from == communityEvent.eventDate)
          .toList();

      // Should find both matching events (the leaveEvent method handles this by iterating through all matches)
      expect(matchingEvents.length, equals(2));
      expect(matchingEvents.every((e) => e.title == 'Mental Health Support Group'), isTrue);
      expect(matchingEvents.every((e) => e.from == DateTime.parse('2025-02-25T18:00:00.000Z')), isTrue);
    });

    test('Event state updates should be correct after canceling attendance', () {
      // Test the state changes that happen when canceling attendance
      
      final originalEvent = CommunityEvent(
        id: 'test-event-state',
        title: 'Technology Skills Bootcamp',
        description: 'Hands-on training in digital literacy.',
        eventDate: DateTime.parse('2025-03-01T09:00:00.000Z'),
        endDate: DateTime.parse('2025-03-01T17:00:00.000Z'),
        location: 'Tech Hub',
        organizer: 'IT Professionals',
        maxAttendees: 25,
        currentAttendees: 15,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
      );

      // Simulate the state changes that happen in leaveEvent
      final updatedEvent = originalEvent.copyWith(
        isUserAttending: false,
        currentAttendees: originalEvent.currentAttendees - 1,
      );

      // Verify the state changes
      expect(updatedEvent.isUserAttending, isFalse);
      expect(updatedEvent.currentAttendees, equals(14)); // Decremented from 15
      expect(updatedEvent.title, equals(originalEvent.title)); // Other fields unchanged
      expect(updatedEvent.eventDate, equals(originalEvent.eventDate));
      expect(updatedEvent.maxAttendees, equals(originalEvent.maxAttendees));
    });

    test('UI button states should be correct for different event attendance states', () {
      // Test the UI logic for button text and colors
      
      // User is attending event
      final attendingEvent = CommunityEvent(
        id: 'attending-event',
        title: 'Event I\'m Attending',
        description: 'Test event',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: true,
        maxAttendees: 30,
        currentAttendees: 15,
      );

      // User is not attending event (space available)
      final availableEvent = CommunityEvent(
        id: 'available-event',
        title: 'Available Event',
        description: 'Test event',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: false,
        maxAttendees: 30,
        currentAttendees: 15,
      );

      // Event is full (user not attending)
      final fullEvent = CommunityEvent(
        id: 'full-event',
        title: 'Full Event',
        description: 'Test event',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUserAttending: false,
        maxAttendees: 30,
        currentAttendees: 30, // Full
      );

      // Test button text logic
      expect(attendingEvent.isUserAttending ? 'Cancel' : (attendingEvent.isFull ? 'Full' : 'Join'), equals('Cancel'));
      expect(availableEvent.isUserAttending ? 'Cancel' : (availableEvent.isFull ? 'Full' : 'Join'), equals('Join'));
      expect(fullEvent.isUserAttending ? 'Cancel' : (fullEvent.isFull ? 'Full' : 'Join'), equals('Full'));

      // Test button enabled state logic
      expect(attendingEvent.isFull && !attendingEvent.isUserAttending, isFalse); // Should be enabled (user attending)
      expect(availableEvent.isFull && !availableEvent.isUserAttending, isFalse); // Should be enabled (space available)
      expect(fullEvent.isFull && !fullEvent.isUserAttending, isTrue); // Should be disabled (full and not attending)
    });
  });
}