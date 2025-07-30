import 'package:flutter/material.dart';


import '../db/app_db.dart';
import '../db/models/event_model.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();
  DateTime get selected => _selectedDate;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<Event> get eventsOfSelectedDate {
    return _events.where((event) {
      return event.from.day == _selectedDate.day &&
          event.from.month == _selectedDate.month &&
          event.from.year == _selectedDate.year;
    }).toList();
  }

  Future<void> loadEventsFromDB() async {
    // Load all events from the database
    _events = await SSIDatabase.instance.readAllEvents();
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    final newEvent = await SSIDatabase.instance.createEvent(event);
    _events = [..._events, newEvent];
    notifyListeners();
  }

  Future<void> deleteEvent(Event event) async {
    // Delete the event from the database
    await SSIDatabase.instance.deleteEvent(event.notificationId!);

    _events = _events
        .where((e) => e.notificationId != event.notificationId)
        .toList();
    notifyListeners();
  }

  Future<void> editEvent(Event newEvent, Event oldEvent) async {
    // Update the event in the database
    await SSIDatabase.instance.updateEvent(newEvent);

    final index = _events.indexOf(oldEvent);
    if (index != -1) {
      _events = List.from(_events);
      _events[index] = newEvent;
      notifyListeners();
    }
  }

   int getActiveEventCount() {
    return _events.where((event) => event.to.isAfter(DateTime.now())).length;
  }
}
