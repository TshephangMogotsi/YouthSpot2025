import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/community_event.dart';
import '../db/models/event_model.dart';
import '../providers/event_provider.dart';
import '../main.dart';

class CommunityEventsProvider extends ChangeNotifier {
  List<CommunityEvent> _events = [];
  bool _isLoading = false;
  String? _error;

  List<CommunityEvent> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<CommunityEvent> get upcomingEvents {
    return _events.where((event) => event.isUpcoming && event.isActive).toList()
      ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
  }

  Future<void> loadCommunityEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get current user ID
      final currentUserId = supabase.auth.currentUser?.id;

      // First, test database connectivity
      if (kDebugMode) {
        print('Testing database connectivity...');
        try {
          await supabase.from('community_events').select('count').limit(1);
          print('Database connection successful');
        } catch (connectivityError) {
          print('Database connectivity issue: $connectivityError');
          throw Exception('Unable to connect to database: ${connectivityError.toString()}');
        }
      }

      // First, get all active events
      if (kDebugMode) {
        print('Loading community events...');
        print('Current time: ${DateTime.now().toIso8601String()}');
      }
      
      final eventsResponse = await supabase
          .from('community_events')
          .select('*')
          .eq('is_active', true)
          .gte('event_date', DateTime.now().toIso8601String())
          .order('event_date');

      if (kDebugMode) {
        print('Events response type: ${eventsResponse.runtimeType}');
        print('Events response: $eventsResponse');
        if (eventsResponse is List) {
          print('Number of events: ${eventsResponse.length}');
          if (eventsResponse.isEmpty) {
            // Try to get any events without date filter to see if table has data
            print('No upcoming events found, checking if table has any data...');
            final allEventsResponse = await supabase
                .from('community_events')
                .select('*')
                .limit(5);
            print('Total events in table: ${(allEventsResponse as List).length}');
            if ((allEventsResponse as List).isNotEmpty) {
              print('Sample event: ${allEventsResponse.first}');
            } else {
              print('Table appears to be empty - no events found');
            }
          }
        }
      }

      // Validate response format
      if (eventsResponse is! List) {
        throw Exception('Unexpected response format: ${eventsResponse.runtimeType}');
      }

      final eventsList = eventsResponse as List;

      // Handle empty results gracefully
      if (eventsList.isEmpty) {
        _events = [];
        if (kDebugMode) {
          print('No upcoming events found');
        }
        return; // Early return for empty results
      }

      // Then, get user's attendances if user is logged in
      List<String> userEventIds = [];
      if (currentUserId != null) {
        final attendanceResponse = await supabase
            .from('event_attendees')
            .select('event_id')
            .eq('user_id', currentUserId);
        
        if (attendanceResponse is List) {
          userEventIds = attendanceResponse
              .map((attendance) => attendance['event_id'] as String?)
              .where((id) => id != null)
              .cast<String>()
              .toList();
        }
      }

      _events = eventsList.map<CommunityEvent>((eventData) {
        try {
          // Validate eventData is a Map
          if (eventData is! Map<String, dynamic>) {
            throw ArgumentError('Event data is not a valid Map: ${eventData.runtimeType}');
          }

          // Check if current user is attending this event
          final eventId = eventData['id'] as String?;
          final isUserAttending = eventId != null && userEventIds.contains(eventId);

          // Add the user attending flag
          final eventMap = Map<String, dynamic>.from(eventData);
          eventMap['is_user_attending'] = isUserAttending;

          return CommunityEvent.fromJson(eventMap);
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing event data: $e');
            print('Event data: $eventData');
          }
          rethrow;
        }
      }).toList();

      if (kDebugMode) {
        print('Successfully loaded ${_events.length} events');
      }

    } catch (e) {
      _error = 'Error loading community events: ${e.toString()}';
      if (kDebugMode) {
        print('Error loading community events: $e');
        if (e is ArgumentError) {
          print('Data validation error: ${e.message}');
        } else if (e.toString().contains('connection')) {
          print('Network/database connection error');
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinEvent(String eventId, EventProvider eventProvider) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        _error = 'User not authenticated';
        notifyListeners();
        return false;
      }

      // Add user to event_attendees table
      await supabase
          .from('event_attendees')
          .insert({
            'event_id': eventId,
            'user_id': currentUserId,
          });

      // Update the current attendees count by incrementing
      final currentEvent = _events.firstWhere((event) => event.id == eventId);
      await supabase
          .from('community_events')
          .update({
            'current_attendees': currentEvent.currentAttendees + 1,
          })
          .eq('id', eventId);

      // Find the event and add it to personal calendar
      final communityEvent = _events.firstWhere((event) => event.id == eventId);
      
      // Create a personal calendar event
      final personalEvent = Event(
        title: communityEvent.title,
        description: '${communityEvent.description}\n\nLocation: ${communityEvent.location ?? 'TBD'}\nOrganizer: ${communityEvent.organizer ?? 'Unknown'}',
        from: communityEvent.eventDate,
        to: communityEvent.endDate ?? communityEvent.eventDate.add(const Duration(hours: 2)),
        backgroundColor: const Color(0xFF4CAF50), // Green for community events
        isAllDay: false,
      );

      // Add to personal calendar
      await eventProvider.addEvent(personalEvent);

      // Update local state
      final eventIndex = _events.indexWhere((event) => event.id == eventId);
      if (eventIndex != -1) {
        _events[eventIndex] = _events[eventIndex].copyWith(
          isUserAttending: true,
          currentAttendees: _events[eventIndex].currentAttendees + 1,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = 'Failed to join event: ${e.toString()}';
      if (kDebugMode) {
        print('Error joining event: $e');
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> leaveEvent(String eventId, EventProvider eventProvider) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        _error = 'User not authenticated';
        notifyListeners();
        return false;
      }

      // Remove user from event_attendees table
      await supabase
          .from('event_attendees')
          .delete()
          .eq('event_id', eventId)
          .eq('user_id', currentUserId);

      // Update the current attendees count by decrementing
      final currentEvent = _events.firstWhere((event) => event.id == eventId);
      await supabase
          .from('community_events')
          .update({
            'current_attendees': currentEvent.currentAttendees - 1,
          })
          .eq('id', eventId);

      // Find and remove the corresponding personal calendar event
      final communityEvent = _events.firstWhere((event) => event.id == eventId);
      final personalEvents = eventProvider.events
          .where((event) => 
              event.title == communityEvent.title &&
              event.from == communityEvent.eventDate)
          .toList();

      for (final personalEvent in personalEvents) {
        await eventProvider.deleteEvent(personalEvent);
      }

      // Update local state
      final eventIndex = _events.indexWhere((event) => event.id == eventId);
      if (eventIndex != -1) {
        _events[eventIndex] = _events[eventIndex].copyWith(
          isUserAttending: false,
          currentAttendees: _events[eventIndex].currentAttendees - 1,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = 'Failed to leave event: ${e.toString()}';
      if (kDebugMode) {
        print('Error leaving event: $e');
      }
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Synchronizes user's attended events to personal calendar
  /// This should be called on app initialization to ensure calendar is up-to-date
  Future<void> syncAttendedEventsToCalendar(EventProvider eventProvider) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        if (kDebugMode) {
          print('User not authenticated, skipping event sync');
        }
        return;
      }

      if (kDebugMode) {
        print('Starting sync of attended events to personal calendar...');
      }

      // Get user's event attendances
      final attendanceResponse = await supabase
          .from('event_attendees')
          .select('event_id')
          .eq('user_id', currentUserId);

      if (attendanceResponse is! List || attendanceResponse.isEmpty) {
        if (kDebugMode) {
          print('No event attendances found for user');
        }
        return;
      }

      final userEventIds = attendanceResponse
          .map((attendance) => attendance['event_id'] as String?)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      if (userEventIds.isEmpty) {
        if (kDebugMode) {
          print('No valid event IDs found in user attendances');
        }
        return;
      }

      // Get community events that user is attending
      final attendedEventsResponse = await supabase
          .from('community_events')
          .select('*')
          .inFilter('id', userEventIds)
          .eq('is_active', true);

      if (attendedEventsResponse is! List) {
        throw Exception('Unexpected response format for attended events');
      }

      final attendedEventsList = attendedEventsResponse as List;
      if (attendedEventsList.isEmpty) {
        if (kDebugMode) {
          print('No active attended events found');
        }
        return;
      }

      // Get existing personal calendar events to avoid duplicates
      final existingEvents = eventProvider.events;
      
      int syncedCount = 0;
      for (final eventData in attendedEventsList) {
        try {
          final communityEvent = CommunityEvent.fromJson(eventData);
          
          // Check if this event already exists in personal calendar
          final existsInCalendar = existingEvents.any((personalEvent) =>
              personalEvent.title == communityEvent.title &&
              personalEvent.from == communityEvent.eventDate);

          if (!existsInCalendar) {
            // Create personal calendar event for this attended community event
            final personalEvent = Event(
              title: communityEvent.title,
              description: '${communityEvent.description}\n\nLocation: ${communityEvent.location ?? 'TBD'}\nOrganizer: ${communityEvent.organizer ?? 'Unknown'}',
              from: communityEvent.eventDate,
              to: communityEvent.endDate ?? communityEvent.eventDate.add(const Duration(hours: 2)),
              backgroundColor: const Color(0xFF4CAF50), // Green for community events
              isAllDay: false,
            );

            await eventProvider.addEvent(personalEvent);
            syncedCount++;
            
            if (kDebugMode) {
              print('Synced event to calendar: ${communityEvent.title}');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error syncing individual event: $e');
          }
          // Continue with other events
        }
      }

      if (kDebugMode) {
        print('Event sync completed. Synced $syncedCount new events to calendar.');
      }

    } catch (e) {
      if (kDebugMode) {
        print('Error syncing attended events to calendar: $e');
      }
      // Don't set _error here as this is a background sync operation
      // and shouldn't interfere with normal UI functionality
    }
  }
}