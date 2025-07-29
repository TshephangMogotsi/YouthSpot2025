import 'package:flutter/material.dart';

const String tableEvent = 'event';

class EventFields {
  static final List<String> values = [
    id,
    title,
    description,
    from,
    to,
    backgroundColor,
    isAllDay,
    notificationId
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String from = 'fromDate';
  static const String to = 'toDate';
  static const String backgroundColor = 'backgroundColor';
  static const String isAllDay = 'isAllDay';
  static const String notificationId = 'notificationId';
}

class Event {
  final int? notificationId;
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  Event({
    this.notificationId,
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.green,
    this.isAllDay = false,
  });

  Event copyWith({
    int? notificationId,
    String? title,
    String? description,
    DateTime? from,
    DateTime? to,
    Color? backgroundColor,
    bool? isAllDay,
  }) {
    return Event(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      description: description ?? this.description,
      from: from ?? this.from,
      to: to ?? this.to,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  Map<String, Object?> toJson() => {
        EventFields.id: notificationId,
        EventFields.title: title,
        EventFields.description: description,
        EventFields.from: from.toIso8601String(),
        EventFields.to: to.toIso8601String(),
        EventFields.backgroundColor: backgroundColor.value,
        EventFields.isAllDay: isAllDay ? 1 : 0,
        EventFields.notificationId: notificationId,
      };

  static Event fromJson(Map<String, Object?> json) => Event(
        notificationId: json[EventFields.id] as int?,
        title: json[EventFields.title] as String,
        description: json[EventFields.description] as String,
        from: DateTime.parse(json[EventFields.from] as String),
        to: DateTime.parse(json[EventFields.to] as String),
        backgroundColor: Color(json[EventFields.backgroundColor] as int),
        isAllDay: (json[EventFields.isAllDay] as int) == 1,
      );
}
