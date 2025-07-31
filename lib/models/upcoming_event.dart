import 'package:flutter/material.dart';

import '../db/models/event_model.dart';

class UpcomingEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String imageUrl;
  final String organizer;

  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.organizer,
  });

  // Convert to Event model for calendar integration
  Event toCalendarEvent() {
    return Event(
      title: title,
      description: '$description\n\nLocation: $location\nOrganizer: $organizer',
      from: date,
      to: date.add(const Duration(hours: 2)), // Default 2-hour duration
      backgroundColor: const Color(0xFF4CAF50), // Green color for upcoming events
      isAllDay: false,
    );
  }
}