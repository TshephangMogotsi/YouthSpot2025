import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String tableMedicine = 'medicine';

class MedicineFields {
  static final List<String> values = [
    id, medicineName, medicineType, note, doses, color, startDate, endDate, notificationIds
  ];

  static const String id = '_id';
  static const String medicineName = 'medicineName';
  static const String medicineType = 'medicineType';
  static const String note = 'note';
  static const String doses = 'doses';
  static const String color = 'color';
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';
  static const String notificationIds = 'notificationIds'; // New field
}

class Medicine {
  final int? id;
  final String medicineName;
  final String medicineType;
  final String note;
  final List<TimeOfDay> doses;
  final int color;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> notificationIds; // New field

  const Medicine({
    this.id,
    required this.medicineName,
    required this.medicineType,
    required this.note,
    required this.doses,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.notificationIds, // Add to constructor
  });

  Medicine copy({
    int? id,
    String? medicineName,
    String? medicineType,
    String? note,
    List<TimeOfDay>? doses,
    int? color,
    DateTime? startDate,
    DateTime? endDate,
    List<int>? notificationIds, // Add to copy method
  }) =>
      Medicine(
        id: id ?? this.id,
        medicineName: medicineName ?? this.medicineName,
        medicineType: medicineType ?? this.medicineType,
        note: note ?? this.note,
        doses: doses ?? this.doses,
        color: color ?? this.color,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        notificationIds: notificationIds ?? this.notificationIds,
      );

  static Medicine fromJson(Map<String, Object?> json) => Medicine(
        id: json[MedicineFields.id] as int?,
        medicineName: json[MedicineFields.medicineName] as String,
        medicineType: json[MedicineFields.medicineType] as String,
        note: json[MedicineFields.note] as String,
        doses: _parseDoses(json[MedicineFields.doses] as String),
        color: json[MedicineFields.color] as int,
        startDate: DateTime.parse(json[MedicineFields.startDate] as String),
        endDate: DateTime.parse(json[MedicineFields.endDate] as String),
        notificationIds: _parseNotificationIds(json[MedicineFields.notificationIds] as String),
      );

  Map<String, Object?> toJson() => {
        MedicineFields.id: id,
        MedicineFields.medicineName: medicineName,
        MedicineFields.medicineType: medicineType,
        MedicineFields.note: note,
        MedicineFields.doses: _dosesToString(doses),
        MedicineFields.color: color,
        MedicineFields.startDate: startDate.toIso8601String(),
        MedicineFields.endDate: endDate.toIso8601String(),
        MedicineFields.notificationIds: _notificationIdsToString(notificationIds),
      };

  static String _dosesToString(List<TimeOfDay> doses) {
    final formatter = DateFormat.Hm();
    return doses
        .map((dose) => formatter.format(_dateTimeFromTimeOfDay(dose)))
        .join(',');
  }

  static List<TimeOfDay> _parseDoses(String dosesString) {
    final formatter = DateFormat.Hm();
    if (dosesString.isEmpty) {
      return [];
    }
    final dosesList = dosesString.split(',');
    return dosesList
        .map(
            (doseString) => _timeOfDayFromDateTime(formatter.parse(doseString)))
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