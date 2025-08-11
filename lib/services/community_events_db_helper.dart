// Database helper utility for troubleshooting community events
// This file provides debugging utilities and sample data setup

// ignore_for_file: unnecessary_type_check

import '../main.dart';

class CommunityEventsDbHelper {
  /// Check if the community_events table has any data
  static Future<bool> hasEventsData() async {
    try {
      final response = await supabase
          .from('community_events')
          .select('count')
          .limit(1);
      
      return response is List && response.isNotEmpty;
    } catch (e) {
      print('Error checking events data: $e');
      return false;
    }
  }

  /// Get sample event data for testing
  static Map<String, dynamic> getSampleEventData() {
    return {
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
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'is_user_attending': false,
    };
  }

  /// Test the database connection and table access
  static Future<Map<String, dynamic>> runDatabaseDiagnostics() async {
    final diagnostics = <String, dynamic>{};
    
    try {
      // Test basic connection
      diagnostics['connection'] = 'OK';
      
      // Check if table exists and has data
      final allEvents = await supabase
          .from('community_events')
          .select('*')
          .limit(5);
      
      diagnostics['table_exists'] = true;
      diagnostics['total_events'] = (allEvents as List).length;
      
      if ((allEvents as List).isNotEmpty) {
        diagnostics['sample_event'] = allEvents.first;
        
        // Check for required fields
        final firstEvent = allEvents.first;
        diagnostics['has_id'] = firstEvent.containsKey('id');
        diagnostics['has_title'] = firstEvent.containsKey('title');
        diagnostics['has_event_date'] = firstEvent.containsKey('event_date');
        diagnostics['has_created_at'] = firstEvent.containsKey('created_at');
        diagnostics['has_updated_at'] = firstEvent.containsKey('updated_at');
      }
      
      // Check upcoming events specifically
      final upcomingEvents = await supabase
          .from('community_events')
          .select('*')
          .eq('is_active', true)
          .gte('event_date', DateTime.now().toIso8601String())
          .limit(5);
      
      diagnostics['upcoming_events'] = (upcomingEvents as List).length;
      
    } catch (e) {
      diagnostics['error'] = e.toString();
      diagnostics['connection'] = 'FAILED';
    }
    
    return diagnostics;
  }

  /// Create sample events for testing (use with caution in production)
  static Future<bool> createSampleEvents() async {
    try {
      final sampleEvents = [
        {
          'title': 'Youth Wellness Workshop',
          'description': 'Interactive workshop focusing on mental health and wellness strategies for young adults.',
          'event_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
          'end_date': DateTime.now().add(const Duration(days: 7, hours: 6)).toIso8601String(),
          'location': 'Community Center Hall A',
          'organizer': 'YouthSpot Team',
          'max_attendees': 50,
        },
        {
          'title': 'Career Development Seminar',
          'description': 'Learn about career opportunities, resume building, and interview skills.',
          'event_date': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
          'end_date': DateTime.now().add(const Duration(days: 14, hours: 4)).toIso8601String(),
          'location': 'Business Center Conference Room',
          'organizer': 'Career Guidance Counselors',
          'max_attendees': 30,
        },
      ];

      for (final event in sampleEvents) {
        await supabase.from('community_events').insert(event);
      }
      
      return true;
    } catch (e) {
      print('Error creating sample events: $e');
      return false;
    }
  }
}