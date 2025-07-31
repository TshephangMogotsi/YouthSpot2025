import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/models/community_event.dart';

void main() {
  group('CommunityEvent', () {
    test('should create CommunityEvent from JSON', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Event',
        'description': 'Test Description',
        'event_date': '2025-02-15T10:00:00.000Z',
        'end_date': '2025-02-15T16:00:00.000Z',
        'location': 'Test Location',
        'organizer': 'Test Organizer',
        'max_attendees': 50,
        'current_attendees': 10,
        'is_active': true,
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
        'is_user_attending': false,
      };

      final event = CommunityEvent.fromJson(json);

      expect(event.id, 'test-id');
      expect(event.title, 'Test Event');
      expect(event.description, 'Test Description');
      expect(event.location, 'Test Location');
      expect(event.organizer, 'Test Organizer');
      expect(event.maxAttendees, 50);
      expect(event.currentAttendees, 10);
      expect(event.isActive, true);
      expect(event.isUserAttending, false);
    });

    test('should convert CommunityEvent to JSON', () {
      final event = CommunityEvent(
        id: 'test-id',
        title: 'Test Event',
        description: 'Test Description',
        eventDate: DateTime.parse('2025-02-15T10:00:00.000Z'),
        endDate: DateTime.parse('2025-02-15T16:00:00.000Z'),
        location: 'Test Location',
        organizer: 'Test Organizer',
        maxAttendees: 50,
        currentAttendees: 10,
        isActive: true,
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        isUserAttending: false,
      );

      final json = event.toJson();

      expect(json['id'], 'test-id');
      expect(json['title'], 'Test Event');
      expect(json['description'], 'Test Description');
      expect(json['location'], 'Test Location');
      expect(json['organizer'], 'Test Organizer');
      expect(json['max_attendees'], 50);
      expect(json['current_attendees'], 10);
      expect(json['is_active'], true);
    });

    test('should determine if event is upcoming', () {
      final futureEvent = CommunityEvent(
        id: 'test-id',
        title: 'Future Event',
        description: 'Test Description',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final pastEvent = CommunityEvent(
        id: 'test-id',
        title: 'Past Event',
        description: 'Test Description',
        eventDate: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(futureEvent.isUpcoming, true);
      expect(futureEvent.isPastEvent, false);
      expect(pastEvent.isUpcoming, false);
      expect(pastEvent.isPastEvent, true);
    });

    test('should determine if event is full', () {
      final fullEvent = CommunityEvent(
        id: 'test-id',
        title: 'Full Event',
        description: 'Test Description',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        maxAttendees: 10,
        currentAttendees: 10,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final availableEvent = CommunityEvent(
        id: 'test-id',
        title: 'Available Event',
        description: 'Test Description',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        maxAttendees: 10,
        currentAttendees: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(fullEvent.isFull, true);
      expect(availableEvent.isFull, false);
    });

    test('should copy with new values', () {
      final originalEvent = CommunityEvent(
        id: 'test-id',
        title: 'Original Event',
        description: 'Original Description',
        eventDate: DateTime.parse('2025-02-15T10:00:00.000Z'),
        currentAttendees: 5,
        isUserAttending: false,
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
      );

      final updatedEvent = originalEvent.copyWith(
        title: 'Updated Event',
        currentAttendees: 10,
        isUserAttending: true,
      );

      expect(updatedEvent.id, 'test-id'); // unchanged
      expect(updatedEvent.title, 'Updated Event'); // changed
      expect(updatedEvent.description, 'Original Description'); // unchanged
      expect(updatedEvent.currentAttendees, 10); // changed
      expect(updatedEvent.isUserAttending, true); // changed
    });
  });
}