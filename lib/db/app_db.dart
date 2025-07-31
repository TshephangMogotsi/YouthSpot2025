import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/event_model.dart';
import 'models/goal_model.dart';
import 'models/goal_reminder.dart';
import 'models/journal_model.dart';
import 'models/medicine_model.dart';
import 'models/mood_model.dart';
import 'models/doses_model.dart';
import '../models/quotes_model.dart';

class SSIDatabase {
  static final SSIDatabase instance = SSIDatabase._init();

  static Database? _database;

  SSIDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('ssi_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: 1, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
      await db.execute('''
        ALTER TABLE $tableMedicine ADD COLUMN ${MedicineFields.startDate} TEXT;
      ''');
      await db.execute('''
        ALTER TABLE $tableMedicine ADD COLUMN ${MedicineFields.endDate} TEXT;
      ''');
      await db.execute('''
        ALTER TABLE $tableMedicine ADD COLUMN ${MedicineFields.notificationIds} TEXT;
      ''');
    }
    if (oldVersion < 10) {
      await db.execute('''
        ALTER TABLE $tableGoal ADD COLUMN ${GoalFields.notificationIds} TEXT;
      ''');
      await db.execute('''
        ALTER TABLE $tableGoal ADD COLUMN ${GoalFields.totalReminders} INTEGER;
      ''');
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const idType2 = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableMedicine ( 
        ${MedicineFields.id} $idType, 
        ${MedicineFields.medicineName} $textType,
        ${MedicineFields.medicineType} $textType,
        ${MedicineFields.note} $textType,
        ${MedicineFields.doses} $textType,
        ${MedicineFields.color} $integerType,
        ${MedicineFields.startDate} $textType,
        ${MedicineFields.endDate} $textType,
        ${MedicineFields.notificationIds} $textType -- New field
         )
    ''');
    await db.execute('''
    CREATE TABLE $tableDose (
        ${DoseFields.id} $idType, 
        ${DoseFields.medicineId} $integerType,
        ${DoseFields.time} $textType,
        FOREIGN KEY (${DoseFields.medicineId}) REFERENCES $tableMedicine(${MedicineFields.id})
         )
    ''');
    await db.execute('''
    CREATE TABLE $tableFavoriteQuotes (
        ${QuotesModelFields.id} $idType2, 
        ${QuotesModelFields.quote} $textType,
        ${QuotesModelFields.author} $textType,
        ${QuotesModelFields.isFavorite} $integerType,
        ${QuotesModelFields.backgroundImageUrl} $textType
         )
    ''');
    await db.execute('''
    CREATE TABLE $tableMood (
        ${MoodFields.id} $idType, 
        ${MoodFields.mood} $textType,
        ${MoodFields.description} $textType,
        ${MoodFields.date} $textType
         )
    ''');
    await db.execute('''
      CREATE TABLE $tableGoal (
        ${GoalFields.id} $idType, 
        ${GoalFields.goalName} $textType,
        ${GoalFields.goal} $textType,
        ${GoalFields.description} $textType,
        ${GoalFields.startDay} $textType,
        ${GoalFields.endDay} $textType,
        ${GoalFields.reminders} $textType,
        ${GoalFields.notificationIds} $textType,
        ${GoalFields.totalReminders} $integerType -- New field
      )
    ''');
    await db.execute('''
        CREATE TABLE $tableGoalReminder (
        ${GoalReminderFields.id} $idType, 
        ${GoalReminderFields.goalId} $integerType,
        ${GoalReminderFields.time} $textType,
        FOREIGN KEY (${GoalReminderFields.goalId}) REFERENCES $tableGoal(${GoalFields.id})
         )
    ''');
    await db.execute('''
        CREATE TABLE $tableJournal(
          ${JournalFields.id} $idType,
          ${JournalFields.isImportant} $boolType,
          ${JournalFields.number} $integerType,
          ${JournalFields.title} $textType,
          ${JournalFields.description} $textType,
          ${JournalFields.time} $textType
        )
    ''');
    await db.execute('''
    CREATE TABLE $tableEvent ( 
      ${EventFields.id} $idType, 
      ${EventFields.title} $textType,
      ${EventFields.description} $textType,
      ${EventFields.from} $textType,
      ${EventFields.to} $textType,
      ${EventFields.backgroundColor} $integerType,
      ${EventFields.isAllDay} $boolType,
      ${EventFields.notificationId} $integerType
    )
  ''');
  }

  //----------------------------JOURNAL FUNCTIONS------------------------------

  Future<JournalEntry> createJounalEntry(JournalEntry journal) async {
    final db = await instance.database;

    final id = await db.insert(tableJournal, journal.toJson());

    return journal.copy(id: id);
  }

  Future<JournalEntry> readJournalEntry(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableJournal,
      columns: JournalFields.values,
      where: '${JournalFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return JournalEntry.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<JournalEntry>> readAllJournalEntries() async {
    final db = await instance.database;

    const orderBy = '${JournalFields.time} ASC';

    final result = await db.query(tableJournal, orderBy: orderBy);

    return result.map((json) => JournalEntry.fromJson(json)).toList();
  }

  Future<int> updateJournalEntry(JournalEntry journal) async {
    final db = await instance.database;

    return db.update(
      tableJournal,
      journal.toJson(),
      where: '${JournalFields.id} = ?',
      whereArgs: [journal.id],
    );
  }

  //delete medicine
  Future<int> deleteJournalEntry(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableJournal,
      where: '${JournalFields.id} = ?',
      whereArgs: [id],
    );
  }

  //----------------------------MEDICINE FUNCTIONS------------------------------

  Future<Medicine> createMedicine(Medicine medicine) async {
    final db = await instance.database;

    // Insert into the medicine table
    final medicineId = await db.insert(tableMedicine, medicine.toJson());

    // Insert into the doses table
    final batch = db.batch();
    for (final time in medicine.doses) {
      final dosage = Dosage(
        time: time.toString(),
        medicineId: medicineId,
      ).toJson();
      batch.rawInsert(
          'INSERT INTO $tableDose (${DoseFields.time}, ${DoseFields.medicineId}) VALUES (?, ?)',
          [dosage[DoseFields.time], dosage[DoseFields.medicineId]]);
    }
    await batch.commit();
    return medicine.copy(id: medicineId);
  }

  //read medicine
  Future<Medicine> readMedicine(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMedicine,
      columns: MedicineFields.values,
      where: '${MedicineFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Medicine.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  //read all medicine
  Future<List<Medicine>> readAllMedication() async {
    final db = await instance.database;
    final result = await db.query(tableMedicine);
    return result.map((json) => Medicine.fromJson(json)).toList();
  }

  //update medicine
  Future<int> updateMedicine(Medicine medicine) async {
    final db = await instance.database;

    return db.update(
      tableMedicine,
      medicine.toJson(),
      where: '${MedicineFields.id} = ?',
      whereArgs: [medicine.id],
    );
  }

  //delete medicine
  Future<int> deleteMedication(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMedicine,
      where: '${MedicineFields.id} = ?',
      whereArgs: [id],
    );
  }

  // count medicine
  Future<int> getMedicineCount() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableMedicine'));
    return count ?? 0;
  }

  //----------------------------QOUTE FUNCTIONS---------------------------------

  //insert favorite qoute
  Future<void> insertFavoriteQoute(QuotesModel qoute) async {
    final db = await instance.database;
    await db.insert(tableFavoriteQuotes, qoute.toJson());
  }

  //read all favorite qoutes
  Future<List<QuotesModel>> readAllFavoriteQoutes() async {
    final db = await instance.database;
    final result = await db.query(tableFavoriteQuotes);
    return result.map((json) => QuotesModel.fromJson(json)).toList();
  }

  //check if id is in favorite qoutes
  Future<bool> isFavoriteQoute(int id) async {
    final db = await instance.database;
    final result = await db.query(tableFavoriteQuotes,
        where: '${QuotesModelFields.id} = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  // Delete a favorite quote from the database
  Future<int> deleteFavoriteQoute(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableFavoriteQuotes,
      where: '${QuotesModelFields.id} = ?',
      whereArgs: [id],
    );
  }

  //----------------------------MOOD FUNCTIONS----------------------------------

  //add mood
  Future<Mood> addMood(Mood mood) async {
    final db = await instance.database;
    final id = await db.insert(tableMood, mood.toJson());
    if (kDebugMode) {
      print('Mood added id: $id');
    }
    return mood.copy(id: id);
  }

  //read all moods
  Future<List<Mood>> readAllMoods() async {
    final db = await instance.database;
    final result = await db.query(tableMood);
    return result.map((json) => Mood.fromJson(json)).toList();
  }

  // check if date in moods matches today date STRING, return true if it does else false
  Future<bool> isMoodToday(String startOfDay, String endOfDay) async {
    final db = await instance.database;
    final result = await db.query(
      tableMood,
      where: '${MoodFields.date} BETWEEN ? AND ?',
      whereArgs: [startOfDay, endOfDay],
    );
    return result.isNotEmpty;
  }

  //close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  //----------------------------GOAL FUNCTIONS----------------------------------

  //add new goal
  Future<Goal> createGoal(Goal goal) async {
    final db = await instance.database;

    // Insert into the goal table
    final goalId = await db.insert(tableGoal, goal.toJson());

    // Insert into the reminders table
    final batch = db.batch();
    for (final time in goal.reminders) {
      final reminder = GoalReminder(
        time: time.toString(),
        goalId: goalId,
      ).toJson();
      batch.rawInsert(
          'INSERT INTO $tableGoalReminder (${GoalReminderFields.time}, ${GoalReminderFields.goalId}) VALUES (?, ?)',
          [
            reminder[GoalReminderFields.time],
            reminder[GoalReminderFields.goalId]
          ]);
    }
    await batch.commit();
    return goal.copy(id: goalId);
  }

  //update goal
  Future<int> updateGoal(Goal goal) async {
    final db = await instance.database;

    return db.update(
      tableGoal,
      goal.toJson(),
      where: '${GoalFields.id} = ?',
      whereArgs: [goal.id],
    );
  }

  //read all goals
  Future<List<Goal>> readAllGoals() async {
    final db = await instance.database;
    final result = await db.query(tableGoal);
    return result.map((json) => Goal.fromJson(json)).toList();
  }

  //delete goal
  Future<int> deleteGoal(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableGoal,
      where: '${GoalFields.id} = ?',
      whereArgs: [id],
    );
  }

  // count goals
  Future<int> getGoalCount() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableGoal'));
    return count ?? 0;
  }

  //----------------------------EVENT FUNCTIONS----------------------------------

  // create event
  Future<Event> createEvent(Event event) async {
    final db = await instance.database;

    final id = await db.insert(tableEvent, event.toJson());

    return event.copyWith(
        notificationId: id); // Returning the event with the ID
  }

  // read event
  Future<Event> readEvent(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableEvent,
      columns: EventFields.values,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // read all events
  Future<List<Event>> readAllEvents() async {
    final db = await instance.database;

    const orderBy = '${EventFields.from} ASC';

    final result = await db.query(tableEvent, orderBy: orderBy);

    return result.map((json) => Event.fromJson(json)).toList();
  }

  // update event
  Future<int> updateEvent(Event event) async {
    final db = await instance.database;

    return db.update(
      tableEvent,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.notificationId],
    );
  }

  // delete event
  Future<int> deleteEvent(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableEvent,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  //----------------------------DATABASE  FUNCTIONS----------------------------------

  Future<void> deleteAllData() async {
    final db = await instance.database;

    // Start a batch to delete data from all tables
    final batch = db.batch();

    batch.delete(tableMedicine);
    batch.delete(tableFavoriteQuotes);
    batch.delete(tableMood);
    batch.delete(tableDose);
    batch.delete(tableGoal);
    batch.delete(tableGoalReminder);
    batch.delete(tableJournal);
    batch.delete(tableEvent);

    // Commit the batch
    await batch.commit(noResult: true);
  }
}
