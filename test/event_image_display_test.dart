import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/models/community_event.dart';
import 'package:youthspot/screens/events_screen.dart';
import 'package:youthspot/config/constants.dart';

void main() {
  group('Event Image Display', () {
    test('CommunityEvent should handle image_url in JSON parsing', () {
      final jsonWithImage = {
        'id': 'test-id',
        'title': 'Test Event',
        'description': 'Test Description',
        'event_date': '2025-02-15T10:00:00.000Z',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
        'image_url': 'https://example.com/image.jpg',
      };

      final event = CommunityEvent.fromJson(jsonWithImage);
      expect(event.imageUrl, 'https://example.com/image.jpg');
    });

    test('CommunityEvent should handle null image_url in JSON parsing', () {
      final jsonWithoutImage = {
        'id': 'test-id',
        'title': 'Test Event',
        'description': 'Test Description',
        'event_date': '2025-02-15T10:00:00.000Z',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
        'image_url': null,
      };

      final event = CommunityEvent.fromJson(jsonWithoutImage);
      expect(event.imageUrl, null);
    });

    test('CommunityEvent should handle empty image_url in JSON parsing', () {
      final jsonWithEmptyImage = {
        'id': 'test-id',
        'title': 'Test Event',
        'description': 'Test Description',
        'event_date': '2025-02-15T10:00:00.000Z',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
        'image_url': '',
      };

      final event = CommunityEvent.fromJson(jsonWithEmptyImage);
      expect(event.imageUrl, '');
    });

    test('CommunityEvent should include image_url in JSON serialization', () {
      final event = CommunityEvent(
        id: 'test-id',
        title: 'Test Event',
        description: 'Test Description',
        eventDate: DateTime.parse('2025-02-15T10:00:00.000Z'),
        imageUrl: 'https://example.com/image.jpg',
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
      );

      final json = event.toJson();
      expect(json['image_url'], 'https://example.com/image.jpg');
    });

    test('CommunityEvent copyWith should handle imageUrl changes', () {
      final originalEvent = CommunityEvent(
        id: 'test-id',
        title: 'Test Event',
        description: 'Test Description',
        eventDate: DateTime.parse('2025-02-15T10:00:00.000Z'),
        imageUrl: null,
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
      );

      final eventWithImage = originalEvent.copyWith(
        imageUrl: 'https://example.com/new-image.jpg',
      );

      expect(originalEvent.imageUrl, null);
      expect(eventWithImage.imageUrl, 'https://example.com/new-image.jpg');
      expect(eventWithImage.id, originalEvent.id); // Other fields unchanged
      expect(eventWithImage.title, originalEvent.title);
    });

    testWidgets('EventCard should display placeholder when no image URL', (WidgetTester tester) async {
      final event = CommunityEvent(
        id: 'test-id',
        title: 'Test Event',
        description: 'Test Description',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        imageUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventCard(event: event, theme: ThemeMode.light),
          ),
        ),
      );

      // Should find the placeholder icon and text
      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.text('Event Image'), findsOneWidget);
    });

    testWidgets('EventCard should display placeholder when empty image URL', (WidgetTester tester) async {
      final event = CommunityEvent(
        id: 'test-id',
        title: 'Test Event',
        description: 'Test Description',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        imageUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventCard(event: event, theme: ThemeMode.light),
          ),
        ),
      );

      // Should find the placeholder icon and text
      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.text('Event Image'), findsOneWidget);
    });
  });
}