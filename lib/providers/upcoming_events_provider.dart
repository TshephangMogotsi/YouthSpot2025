import 'package:flutter/material.dart';

import '../models/upcoming_event.dart';

class UpcomingEventsProvider extends ChangeNotifier {
  List<UpcomingEvent> _upcomingEvents = [];
  Set<String> _attendingEvents = {};

  List<UpcomingEvent> get upcomingEvents => _upcomingEvents;
  Set<String> get attendingEvents => _attendingEvents;

  bool isAttending(String eventId) => _attendingEvents.contains(eventId);

  void toggleAttendance(String eventId) {
    if (_attendingEvents.contains(eventId)) {
      _attendingEvents.remove(eventId);
    } else {
      _attendingEvents.add(eventId);
    }
    notifyListeners();
  }

  void loadSampleEvents() {
    _upcomingEvents = [
      UpcomingEvent(
        id: '1',
        title: 'Youth Leadership Workshop',
        description: 'Learn essential leadership skills and build your confidence as a young leader in your community.',
        date: DateTime.now().add(const Duration(days: 3)),
        location: 'Community Center, Main Street',
        imageUrl: 'assets/image_assets/workshop.jpg',
        organizer: 'Youth Development Foundation',
      ),
      UpcomingEvent(
        id: '2',
        title: 'Mental Health Awareness Seminar',
        description: 'Important discussion about mental health, coping strategies, and support resources available for young people.',
        date: DateTime.now().add(const Duration(days: 7)),
        location: 'City Hall Auditorium',
        imageUrl: 'assets/image_assets/mental_health.jpg',
        organizer: 'Health & Wellness Center',
      ),
      UpcomingEvent(
        id: '3',
        title: 'Career Guidance Fair',
        description: 'Meet professionals from various industries and get guidance on career paths, education opportunities, and skill development.',
        date: DateTime.now().add(const Duration(days: 10)),
        location: 'Convention Center',
        imageUrl: 'assets/image_assets/career_fair.jpg',
        organizer: 'Career Development Network',
      ),
      UpcomingEvent(
        id: '4',
        title: 'Tech Skills Bootcamp',
        description: 'Hands-on workshop covering basic programming, digital literacy, and technology skills for the modern world.',
        date: DateTime.now().add(const Duration(days: 14)),
        location: 'Tech Hub, Innovation District',
        imageUrl: 'assets/image_assets/tech_bootcamp.jpg',
        organizer: 'Digital Skills Initiative',
      ),
      UpcomingEvent(
        id: '5',
        title: 'Community Service Day',
        description: 'Join fellow youth in making a positive impact in our community through various volunteer activities.',
        date: DateTime.now().add(const Duration(days: 21)),
        location: 'Various locations across the city',
        imageUrl: 'assets/image_assets/community_service.jpg',
        organizer: 'YouthSpot Community',
      ),
    ];
    notifyListeners();
  }
}