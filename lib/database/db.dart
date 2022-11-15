import 'dart:async';
import 'package:path/path.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';
import 'package:sqflite/sqflite.dart';

// TODO: create insert/update/delete/read functions for biometric table
// TODO: create insert/update/delete/read functions for weeks table

class AppDatabase {
  static final AppDatabase db = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      onCreate: ((db, version) => createTables(db)),
      version: 1,
    );
  }

  void createTables(Database db) {
    // CYCLES TABLE
    db.execute(
      'CREATE TABLE cycles(id INTEGER PRIMARY KEY, startWeight REAL, goalWeight REAL, startBodyFat INTEGER, goalBodyFat INTEGER, startDateTime TEXT, endDateTime TEXT)',
    );
    // WEEKS TABLE
    db.execute(
      'CREATE TABLE weeks(id INTEGER PRIMARY KEY, cycleId INTEGER, week INTEGER, calorieDeficit INTEGER, weightLoss REAL, weightGoal REAL, bodyFatGoal REAL)',
    );
    // BIOMETRICS TABLE
    db.execute(
      'CREATE TABLE biometrics(id INTEGER PRIMARY KEY, weekId INTEGER, cycleId INTEGER, currentWeight REAL, bodyFat INTEGER, dateTime TEXT, day INTEGER)',
    );
  }

  // BIOMETRIC FUNCTIONS
  Future<void> insertBiometric(Biometric biometric) async {
    final db = await database;

    await db.insert(
      'biometrics',
      biometric.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateBiometric(Biometric biometric) async {
    final db = await database;

    await db.update(
      'biometrics',
      biometric.toMap(),
      where: 'id = ?',
      whereArgs: [biometric.id],
    );
  }

  Future<void> deleteBiometrics(int id) async {
    final db = await database;

    await db.delete(
      'biometrics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllBiometrics() async {
    final db = await database;

    await db.delete('biometrics');
  }

  Future<List<Biometric>> getBiometrics() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('biometrics');

    return List.generate(maps.length, (i) {
      return Biometric(
        id: maps[i]['id'],
        weekId: maps[i]['weekId'],
        cycleId: maps[i]['cycleId'],
        currentWeight: maps[i]['currentWeight'],
        bodyFat: maps[i]['bodyFat'],
        dateTime: maps[i]['dateTime'],
        day: maps[i]['day'],
      );
    });
  }

  Future<List<Biometric>> getBiometricsForWeek(int week) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM biometrics WHERE weekId = $week');

    return List.generate(maps.length, (i) {
      return Biometric(
        id: maps[i]['id'],
        weekId: maps[i]['weekId'],
        cycleId: maps[i]['cycleId'],
        currentWeight: maps[i]['currentWeight'],
        bodyFat: maps[i]['bodyFat'],
        dateTime: maps[i]['dateTime'],
        day: maps[i]['day'],
      );
    });
  }

  // WEEK FUNCTIONS
  Future<void> insertWeek(Week week) async {
    final db = await database;

    await db.insert(
      'weeks',
      week.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateWeek(Week week) async {
    final db = await database;

    await db.update(
      'weeks',
      week.toMap(),
      where: 'id = ?',
      whereArgs: [week.id],
    );
  }

  Future<void> deleteWeek(int id) async {
    final db = await database;

    await db.delete(
      'weeks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  List<Week> generateWeekList(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Week(
        id: maps[i]['id'],
        cycleId: maps[i]['cycleId'],
        week: maps[i]['week'],
        calorieDeficit: maps[i]['calorieDeficit'],
        weightLoss: maps[i]['weightLoss'],
        weightGoal: maps[i]['weightGoal'],
        bodyFatGoal: maps[i]['bodyFatGoal'],
      );
    });
  }

  Future<List<Week>> getWeeks() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('weeks');

    return generateWeekList(maps);
  }

  Future<List<Week>> getWeekListFromCycleId(int cycleId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'weeks',
      where: 'cycleId = ?',
      whereArgs: [cycleId],
    );

    return generateWeekList(maps);
  }

  // CYCLE FUNCTIONS
  Future<void> insertCycle(Cycle cycle) async {
    final db = await database;

    await db.insert(
      'cycles',
      cycle.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCycle(Cycle cycle) async {
    final db = await database;

    await db.update(
      'cycles',
      cycle.toMap(),
      where: 'id = ?',
      whereArgs: [cycle.id],
    );
  }

  Future<void> deleteCycle(int id) async {
    final db = await database;

    await db.delete(
      'cycles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  List<Cycle> generateCycleList(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Cycle(
        id: maps[i]['id'],
        startWeight: maps[i]['startWeight'],
        goalWeight: maps[i]['goalWeight'],
        startBodyFat: maps[i]['startBodyFat'],
        goalBodyFat: maps[i]['goalBodyFat'],
        startDateTime: maps[i]['startDateTime'],
        endDateTime: maps[i]['endDateTime'],
      );
    });
  }

  Future<List<Cycle>> getCycles() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('cycles');

    return generateCycleList(maps);
  }

  Future<List<Cycle>> getCurrentCycle() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'cycles',
      limit: 1,
      orderBy: 'id DESC',
    );

    return generateCycleList(maps);
  }

  Future<void> deleteAll() async {
    final db = await database;

    await db.delete('biometrics');
    await db.delete('weeks');
    await db.delete('cycles');
  }
}
