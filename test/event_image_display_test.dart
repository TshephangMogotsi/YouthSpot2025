import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youthspot/models/community_event.dart';
import 'package:youthspot/screens/events_screen.dart';

void main() {
  group('Event Image Display', () {
    testWidgets('EventCard displays cached network image when imageUrl is provided', (WidgetTester tester) async {
      final eventWithImage = CommunityEvent(
        id: 'test-id',
        title: 'Test Event',
        description: 'Test Description',
        eventDate: DateTime.now().add(const Duration(days: 1)),
        imageUrl: 'https://example.com/event-image.jpg',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: EventCard(
              event: eventWithImage,
              theme: ThemeMode.light,
            ),
          ),
        ),
      );

      // Verify that CachedNetworkImage is used when imageUrl is provided
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.byIcon(Icons.event), findsNothing); // Should not show placeholder icon
    });

    testWidgets('EventCard displays placeholder when imageUrl is null', (WidgetTester tester) async {
      final eventWithoutImage = CommunityEvent(
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
          home: Material(
            child: EventCard(
              event: eventWithoutImage,
              theme: ThemeMode.light,
            ),
          ),
        ),
      );

      // Verify that placeholder is shown when imageUrl is null
      expect(find.byType(CachedNetworkImage), findsNothing);
      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.text('Event Image'), findsOneWidget);
    });

    testWidgets('EventCard displays placeholder when imageUrl is empty', (WidgetTester tester) async {
      final eventWithEmptyImage = CommunityEvent(
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
          home: Material(
            child: EventCard(
              event: eventWithEmptyImage,
              theme: ThemeMode.light,
            ),
          ),
        ),
      );

      // Verify that placeholder is shown when imageUrl is empty
      expect(find.byType(CachedNetworkImage), findsNothing);
      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.text('Event Image'), findsOneWidget);
    });
  });
}