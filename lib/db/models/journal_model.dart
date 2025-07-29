const String tableJournal = 'journal';

class JournalFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time
  ];

  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class JournalEntry {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const JournalEntry(
      {this.id,
      required this.isImportant,
      required this.number,
      required this.title,
      required this.description,
      required this.createdTime});

  static JournalEntry fromJson(Map<String, Object?> json) => JournalEntry(
        id: json[JournalFields.id] as int?,
        isImportant: json[JournalFields.isImportant] == 1,
        number: json[JournalFields.number] as int,
        title: json[JournalFields.title] as String,
        description: json[JournalFields.description] as String,
        createdTime: DateTime.parse(json[JournalFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        JournalFields.id: id,
        JournalFields.title: title,
        JournalFields.isImportant: isImportant ? 1 : 0,
        JournalFields.number: number,
        JournalFields.description: description,
        JournalFields.time: createdTime.toIso8601String()
      };

  JournalEntry copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      JournalEntry(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );
}
