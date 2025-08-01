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

      // First, get all active events
      final eventsResponse = await supabase
          .from('community_events')
          .select('*')
          .eq('is_active', true)
          .gte('event_date', DateTime.now().toIso8601String())
          .order('event_date');

      // Then, get user's attendances if user is logged in
      List<String> userEventIds = [];
      if (currentUserId != null) {
        final attendanceResponse = await supabase
            .from('event_attendees')
            .select('event_id')
            .eq('user_id', currentUserId);
        
        userEventIds = (attendanceResponse as List)
            .map((attendance) => attendance['event_id'] as String)
            .toList();
      }

      _events = (eventsResponse as List).map((eventData) {
        // Check if current user is attending this event
        final isUserAttending = userEventIds.contains(eventData['id']);

        // Add the user attending flag
        final eventMap = Map<String, dynamic>.from(eventData);
        eventMap['is_user_attending'] = isUserAttending;

        return CommunityEvent.fromJson(eventMap);
      }).toList();

    } catch (e) {
      _error = 'Failed to load events: ${e.toString()}';
      if (kDebugMode) {
        print('Error loading community events: $e');
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
}