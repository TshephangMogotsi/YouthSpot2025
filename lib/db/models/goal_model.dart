import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String tableGoal = 'goals';

class GoalFields {
  static final List<String> values = [
    id, goalName, goal, description, startDay, endDay, reminders, notificationIds, totalReminders
  ];

  static const String id = '_id';
  static const String goalName = 'goalName';
  static const String goal = 'goal';
  static const String description = 'description';
  static const String startDay = 'startDay';
  static const String endDay = 'endDay';
  static const String reminders = 'reminders';
  static const String notificationIds = 'notificationIds'; // New field
  static const String totalReminders = 'totalReminders'; // New field
}

class Goal {
  final int? id;
  final String goalName;
  final String goal;
  final String description;
  final DateTime startDay;
  final DateTime endDay;
  final List<TimeOfDay> reminders;
  final List<int> notificationIds; // New field
  final int totalReminders; // New field

  const Goal({
    this.id,
    required this.goalName,
    required this.goal,
    required this.description,
    required this.startDay,
    required this.endDay,
    required this.reminders,
    required this.notificationIds, // Add to constructor
    required this.totalReminders, // Add to constructor
  });

  Goal copy({
    int? id,
    String? goalName,
    String? goal,
    String? description,
    DateTime? startDay,
    DateTime? endDay,
    List<TimeOfDay>? reminders,
    List<int>? notificationIds, // Add to copy method
    int? totalReminders, // Add to copy method
  }) =>
      Goal(
        id: id ?? this.id,
        goalName: goalName ?? this.goalName,
        goal: goal ?? this.goal,
        description: description ?? this.description,
        startDay: startDay ?? this.startDay,
        endDay: endDay ?? this.endDay,
        reminders: reminders ?? this.reminders,
        notificationIds: notificationIds ?? this.notificationIds,
        totalReminders: totalReminders ?? this.totalReminders,
      );

  static Goal fromJson(Map<String, Object?> json) => Goal(
        id: json[GoalFields.id] as int?,
        goalName: json[GoalFields.goalName] as String,
        goal: json[GoalFields.goal] as String,
        description: json[GoalFields.description] as String,
        startDay: DateTime.parse(json[GoalFields.startDay] as String),
        endDay: DateTime.parse(json[GoalFields.endDay] as String),
        reminders: _parseReminders(json[GoalFields.reminders] as String),
        notificationIds: _parseNotificationIds(json[GoalFields.notificationIds] as String),
        totalReminders: json[GoalFields.totalReminders] as int,
      );

  Map<String, Object?> toJson() => {
        GoalFields.id: id,
        GoalFields.goalName: goalName,
        GoalFields.goal: goal,
        GoalFields.description: description,
        GoalFields.startDay: startDay.toIso8601String(),
        GoalFields.endDay: endDay.toIso8601String(),
        GoalFields.reminders: _remindersToString(reminders),
        GoalFields.notificationIds: _notificationIdsToString(notificationIds),
        GoalFields.totalReminders: totalReminders,
      };

  static String _remindersToString(List<TimeOfDay> reminders) {
    final formatter = DateFormat.Hm();
    return reminders
        .map((reminder) => formatter.format(_dateTimeFromTimeOfDay(reminder)))
        .join(',');
  }

  static List<TimeOfDay> _parseReminders(String remindersString) {
    final formatter = DateFormat.Hm();
    if (remindersString.isEmpty) {
      return [];
    }
    final remindersList = remindersString.split(',');
    return remindersList
        .map(
            (reminderString) => _timeOfDayFromDateTime(formatter.parse(reminderString)))
        .toList();
  }

  static String _notificationIdsToString(List<int> notificationIds) {
    return notificationIds.join(',');
  }

  static List<int> _parseNotificationIds(String notificationIdsString) {
    if (notificationIdsString.isEmpty) {
      return [];
    }
    return notificationIdsString.split(',').map((id) => int.parse(id)).toList();
  }

  static DateTime _dateTimeFromTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  static TimeOfDay _timeOfDayFromDateTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}