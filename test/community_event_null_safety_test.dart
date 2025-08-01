import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/models/community_event.dart';

void main() {
  group('CommunityEvent null safety improvements', () {
    test('should handle missing created_at and updated_at fields', () {
      final json = {
        'id': 'test-id-123',
        'title': 'Test Event',
        'description': 'Test Description',
        'event_date': '2025-02-15T10:00:00.000Z',
        // missing created_at and updated_at
        'is_active': true,
      };

      final event = CommunityEvent.fromJson(json);
      
      expect(event.id, 'test-id-123');
      expect(event.title, 'Test Event');
      expect(event.description, 'Test Description');
      // createdAt and updatedAt should be current time
      expect(event.createdAt, isA<DateTime>());
      expect(event.updatedAt, isA<DateTime>());
    });

    test('should throw ArgumentError for null id', () {
      final json = {
        'id': null,
        'title': 'Test Event',
        'event_date': '2025-02-15T10:00:00.000Z',
      };

      expect(
        () => CommunityEvent.fromJson(json),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Event ID cannot be null or empty'),
        )),
      );
    });

    test('should throw ArgumentError for empty id', () {
      final json = {
        'id': '',
        'title': 'Test Event',
        'event_date': '2025-02-15T10:00:00.000Z',
      };

      expect(
        () => CommunityEvent.fromJson(json),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Event ID cannot be null or empty'),
        )),
      );
    });

    test('should throw ArgumentError for null title', () {
      final json = {
        'id': 'test-id',
        'title': null,
        'event_date': '2025-02-15T10:00:00.000Z',
      };

      expect(
        () => CommunityEvent.fromJson(json),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Event title cannot be null or empty'),
        )),
      );
    });

    test('should throw ArgumentError for null event_date', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Event',
        'event_date': null,
      };

      expect(
        () => CommunityEvent.fromJson(json),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Event date cannot be null or empty'),
        )),
      );
    });

    test('should handle empty string timestamps', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Event',
        'event_date': '2025-02-15T10:00:00.000Z',
        'created_at': '',
        'updated_at': '',
      };

      final event = CommunityEvent.fromJson(json);
      
      expect(event.id, 'test-id');
      expect(event.title, 'Test Event');
      // Should use current time for empty timestamps
      expect(event.createdAt, isA<DateTime>());
      expect(event.updatedAt, isA<DateTime>());
    });

    test('should handle realistic database response', () {
      // This simulates what Supabase would return
      final json = {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'title': 'Youth Wellness Workshop',
        'description': 'Interactive workshop focusing on mental health and wellness strategies for young adults.',
        'event_date': '2025-02-15T10:00:00+00:00',
        'end_date': '2025-02-15T16:00:00+00:00',
        'location': 'Community Center Hall A',
        'organizer': 'YouthSpot Team',
        'image_url': null,
        'max_attendees': 50,
        'current_attendees': 0,
        'is_active': true,
        'created_at': '2025-01-15T10:30:00+00:00',
        'updated_at': '2025-01-15T10:30:00+00:00',
        'is_user_attending': false,
      };

      final event = CommunityEvent.fromJson(json);
      
      expect(event.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(event.title, 'Youth Wellness Workshop');
      expect(event.location, 'Community Center Hall A');
      expect(event.organizer, 'YouthSpot Team');
      expect(event.maxAttendees, 50);
      expect(event.currentAttendees, 0);
      expect(event.isActive, true);
      expect(event.isUserAttending, false);
      expect(event.imageUrl, null);
    });
  });
}