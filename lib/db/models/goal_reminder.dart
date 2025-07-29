const String tableGoalReminder = 'goal_reminder';

class GoalReminderFields {
  static final List<String> values = [
    /// Add all fields
    id, time, goalId
  ];

  static const String id = '_id';
  static const String time = 'time';
  static const String goalId = 'goalId';
}

class GoalReminder {
  final int? id;
  final String time;
  final int goalId;

  const GoalReminder({
    this.id,
    required this.time,
    required this.goalId,
  });

  GoalReminder copy({
    int? id,
    String? time,
    int? goalId,
  }) =>
      GoalReminder(
        id: id ?? this.id,
        time: time ?? this.time,
        goalId: goalId ?? this.goalId,
      );

  static GoalReminder fromJson(Map<String, Object?> json) => GoalReminder(
        id: json[GoalReminderFields.id] as int?,
        time: json[GoalReminderFields.time] as String,
        goalId: json[GoalReminderFields.goalId] as int,
      );

  Map<String, Object?> toJson() => {
        GoalReminderFields.id: id,
        GoalReminderFields.time: time,
        GoalReminderFields.goalId: goalId,
      };
}
