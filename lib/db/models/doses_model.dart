const String tableDose = 'doses';

class DoseFields {
  static final List<String> values = [
    /// Add all fields
    id, time, medicineId
  ];

  static const String id = '_id';
  static const String time = 'time';
  static const String medicineId = 'medicineId';
}

class Dosage {
  final int? id;
  final String time;
  final int medicineId;

  const Dosage({
    this.id,
    required this.time,
    required this.medicineId,
  });

  Dosage copy({
    int? id,
    String? time,
    int? medicineId,
  }) =>
      Dosage(
        id: id ?? this.id,
        time: time ?? this.time,
        medicineId: medicineId ?? this.medicineId,
      );

  static Dosage fromJson(Map<String, Object?> json) => Dosage(
        id: json[DoseFields.id] as int?,
        time: json[DoseFields.time] as String,
        medicineId: json[DoseFields.medicineId] as int,
      );

  Map<String, Object?> toJson() => {
        DoseFields.id: id,
        DoseFields.time: time,
        DoseFields.medicineId: medicineId,
      };
}
