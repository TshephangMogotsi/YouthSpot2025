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
    // Add event to the local list
    _events.add(event);
    notifyListeners();

    // Save the event to the database
    await SSIDatabase.instance.createEvent(event);
  }

  Future<void> deleteEvent(Event event) async {
    // Remove the event from the local list
    _events.remove(event);
    notifyListeners();

    // Delete the event from the database
    await SSIDatabase.instance.deleteEvent(event.notificationId!);
  }

  Future<void> editEvent(Event newEvent, Event oldEvent) async {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();

    // Update the event in the database
    await SSIDatabase.instance.updateEvent(newEvent);
  }

   int getActiveEventCount() {
    return _events.where((event) => event.to.isAfter(DateTime.now())).length;
  }
}
