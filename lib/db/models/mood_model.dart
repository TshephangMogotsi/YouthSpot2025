const String tableMood = 'mood';

class MoodFields {
  static final List<String> values = [
    /// Add all fields
    id, mood, description, date
  ];

  static const String id = '_id';
  static const String mood = 'mood';
  static const String description = 'description';
  static const String date = 'date';
}

class Mood {
  final int? id;
  final String mood;
  final String description;
  final String date;

  const Mood({
    this.id,
    required this.mood,
    required this.description,
    required this.date,
  });

  Mood copy({
    int? id,
    String? mood,
    String? description,
    String? date,
  }) =>
      Mood(
        id: id ?? this.id,
        mood: mood ?? this.mood,
        description: description ?? this.description,
        date: date ?? this.date,
      );

  static Mood fromJson(Map<String, Object?> json) => Mood(
        id: json[MoodFields.id] as int?,
        mood: json[MoodFields.mood] as String,
        description: json[MoodFields.description] as String,
        date: json[MoodFields.date] as String,
      );

  Map<String, Object?> toJson() => {
        MoodFields.id: id,
        MoodFields.mood: mood,
        MoodFields.description: description,
        MoodFields.date: date,
      };
}
