import 'dart:async';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:project_cut/extensions/double.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/progress_pic.dart';
import 'package:project_cut/model/week.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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
      'CREATE TABLE cycles(id INTEGER PRIMARY KEY, startWeight REAL, goalWeight REAL, startBodyFat REAL, goalBodyFat REAL, startDateTime TEXT, endDateTime TEXT)',
    );
    // WEEKS TABLE
    db.execute(
      'CREATE TABLE weeks(id INTEGER PRIMARY KEY, cycleId INTEGER, week INTEGER, calorieDeficit INTEGER, weightLoss REAL, weightGoal REAL, bodyFatGoal REAL)',
    );
    // BIOMETRICS TABLE
    db.execute(
      'CREATE TABLE biometrics(id INTEGER PRIMARY KEY, weekId INTEGER, cycleId INTEGER, currentWeight REAL, bodyFat REAL, dateTime TEXT, day INTEGER, estimated INTEGER)',
    );
    // PROGRESS PICS TABLE
    db.execute(
      'CREATE TABLE progressPictures(id INTEGER PRIMARY KEY, biometricId INTEGER, cycleId INTEGER, imagePath TEXT, dateTime TEXT)',
    );
  }

  // BIOMETRIC FUNCTIONS
  List<Biometric> generateBiometricList(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Biometric(
        id: maps[i]['id'],
        weekId: maps[i]['weekId'],
        cycleId: maps[i]['cycleId'],
        currentWeight: maps[i]['currentWeight'],
        bodyFat: maps[i]['bodyFat'],
        dateTime: maps[i]['dateTime'],
        day: maps[i]['day'],
        estimated: maps[i]['estimated'],
      );
    });
  }

  Future<void> insertWeight(double enteredWeight) async {
    Biometric latestBiometricEntry = await getLatestBiometric();
    final prefs = await SharedPreferences.getInstance();
    int cycleId = prefs.getInt('currentCycleId')!;

    DateTime currentDateTime =
        DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));

    DateTime lastEntryDateTime = DateTime.parse(DateFormat("yyyy-MM-dd")
        .format(DateTime.parse(latestBiometricEntry.dateTime)));

    int daysSinceLastEntry =
        currentDateTime.difference(lastEntryDateTime).inDays;

    double weightDifference =
        enteredWeight - latestBiometricEntry.currentWeight;

    int weekId = latestBiometricEntry.weekId;

    if (daysSinceLastEntry > 1) {
      double dailyWeightDifference = weightDifference / daysSinceLastEntry;

      for (var i = 1; i < daysSinceLastEntry; i++) {
        DateTime estimatedDateTime = lastEntryDateTime.add(Duration(days: i));
        double estimatedWeight =
            latestBiometricEntry.currentWeight + dailyWeightDifference;

        Biometric estimatedBiometric = Biometric(
          weekId: weekId,
          cycleId: cycleId,
          currentWeight: estimatedWeight.toTwoDecimalPlaces(),
          // add latest body measurements to shared preferences
          // calculate based on that
          bodyFat: latestBiometricEntry.bodyFat,
          dateTime: estimatedDateTime.toLocal().toString(),
          day: estimatedDateTime.weekday,
          estimated: 1,
        );

        insertBiometric(estimatedBiometric);
        // incremement week if previous estimated week added was day 7
        if (estimatedBiometric.day == 7) {
          weekId += 1;
        }
        latestBiometricEntry = estimatedBiometric;
      }
    }
    Biometric enteredBiometric = Biometric(
      weekId: latestBiometricEntry.day == 7
          ? weekId + 1
          : latestBiometricEntry.weekId,
      cycleId: cycleId,
      currentWeight: enteredWeight,
      bodyFat: latestBiometricEntry.bodyFat,
      dateTime: DateTime.now().toLocal().toString(),
      day: DateTime.now().weekday,
      estimated: 0,
    );

    insertBiometric(enteredBiometric);
  }

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
    final prefs = await SharedPreferences.getInstance();
    int cycleId = prefs.getInt('currentCycleId') ?? 1;

    final List<Map<String, dynamic>> maps = await db.query(
      'biometrics',
      orderBy: 'dateTime',
      where: 'cycleId = ?',
      whereArgs: [cycleId],
    );

    List<Biometric> biometrics = generateBiometricList(maps);

    return biometrics;
  }

  Future<List<Biometric>> getBiometricsForWeek(int weekId) async {
    final db = await database;
    final prefs = await SharedPreferences.getInstance();
    int cycleId = prefs.getInt('currentCycleId') ?? 1;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM biometrics WHERE weekId = $weekId AND cycleId = $cycleId');

    List<Biometric> biometrics = generateBiometricList(maps);

    return biometrics;
  }

  Future<Biometric> getLatestBiometric() async {
    final db = await database;
    final prefs = await SharedPreferences.getInstance();
    int cycleId = prefs.getInt('currentCycleId') ?? 1;

    final List<Map<String, dynamic>> maps = await db.query('biometrics',
        limit: 1,
        orderBy: 'dateTime DESC',
        where: 'cycleId = ?',
        whereArgs: [cycleId]);

    List<Biometric> biometrics = generateBiometricList(maps);
    Biometric latestBiometric = const Biometric(
        weekId: 0,
        cycleId: 0,
        currentWeight: 0,
        bodyFat: 0,
        dateTime: '0',
        day: 0,
        estimated: 0);
    if (biometrics.isNotEmpty) {
      latestBiometric = biometrics.first;
    }

    return latestBiometric;
  }

  Future<List<Biometric>> get progressPictureBiometrics async {
    final db = await database;
    final prefs = await SharedPreferences.getInstance();
    int cycleId = prefs.getInt('currentCycleId') ?? 1;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT bio.* FROM biometrics bio INNER JOIN progressPictures pics ON bio.id = pics.biometricId WHERE bio.cycleId = $cycleId');

    List<Biometric> biometrics = generateBiometricList(maps);

    return biometrics;
  }

  // WEEK FUNCTIONS
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

  Future<void> deleteAllWeeks() async {
    final db = await database;

    await db.delete(
      'weeks',
    );
  }

  Future<List<Week>> getWeeks() async {
    final db = await database;
    final prefs = await SharedPreferences.getInstance();
    int cycleId = prefs.getInt('currentCycleId') ?? 1;

    final List<Map<String, dynamic>> maps =
        await db.query('weeks', where: 'cycleId = ?', whereArgs: [cycleId]);

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

  Future<Week> getWeekById(int weekId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'weeks',
      where: 'id = ?',
      whereArgs: [weekId],
    );

    return maps.isNotEmpty
        ? generateWeekList(maps).first
        : const Week(
            cycleId: 0,
            week: 0,
            calorieDeficit: 0,
            weightLoss: 0,
            weightGoal: 0,
            bodyFatGoal: 0);
  }

  Future<Week> getWeekByWeekNumber(int week) async {
    final db = await database;
    final prefs = await SharedPreferences.getInstance();
    int cycleId = prefs.getInt('currentCycleId') ?? 1;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM weeks WHERE week = $week AND cycleId = $cycleId');

    return maps.isNotEmpty
        ? generateWeekList(maps).first
        : const Week(
            cycleId: 0,
            week: 0,
            calorieDeficit: 0,
            weightLoss: 0,
            weightGoal: 0,
            bodyFatGoal: 0);
  }

  // CYCLE FUNCTIONS
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

  Future<List<Cycle>> getCycles() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('cycles');

    return generateCycleList(maps);
  }

  Future<Cycle> getCurrentCycle() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'cycles',
      limit: 1,
      orderBy: 'id DESC',
    );

    return maps.isNotEmpty
        ? generateCycleList(maps).first
        : const Cycle(
            startWeight: 0,
            goalWeight: 0,
            startBodyFat: 0,
            goalBodyFat: 0,
            startDateTime: '2022-11-01 12:00:00.000000',
            endDateTime: '2022-11-10 12:00:00.000000',
          );
  }

  // PROGRESS PICTURE FUNCTIONS
  List<ProgressPicture> generateProgressPictureList(
      List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return ProgressPicture(
        id: maps[i]['id'],
        biometricId: maps[i]['biometricId'],
        cycleId: maps[i]['cycleId'],
        imagePath: maps[i]['imagePath'],
        dateTime: maps[i]['dateTime'],
      );
    });
  }

  Future<int> insertProgressPicture(ProgressPicture progressPicture) async {
    final db = await database;

    int id = await db.insert(
      'progressPictures',
      progressPicture.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<ProgressPicture>> getProgressPictures() async {
    final db = await database;
    final prefs = await SharedPreferences.getInstance();
    int cycleId = prefs.getInt('currentCycleId') ?? 1;

    final List<Map<String, dynamic>> maps = await db
        .query('progressPictures', where: 'cycleId = ?', whereArgs: [cycleId]);

    return generateProgressPictureList(maps);
  }

  Future<void> deleteProgressPictureById(int id) async {
    final db = await database;

    await db.delete(
      'progressPictures',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteProgressPictures() async {
    final db = await database;

    await db.delete('progressPictures');
  }

  Future<void> deleteCycleData(int id) async {
    final db = await database;

    await db.delete('cycles', where: 'id = ?', whereArgs: [id]);
    await db.delete('weeks', where: 'cycleId = ?', whereArgs: [id]);
    await db.delete('biometrics', where: 'cycleId = ?', whereArgs: [id]);
    await db.delete('progressPictures', where: 'cycleId = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await database;

    await db.delete('biometrics');
    await db.delete('weeks');
    await db.delete('cycles');
    await db.delete('progressPictures');
  }
}
