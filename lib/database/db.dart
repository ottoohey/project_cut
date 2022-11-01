import 'dart:async';
import 'package:path/path.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:sqflite/sqflite.dart';

// TODO: create insert/update/delete/read functions for biometric table
// TODO: create insert/update/delete/read functions for weeks table

class BiometricsDatabase {
  static final BiometricsDatabase biometricsDatabase =
      BiometricsDatabase._init();

  static Database? _database;

  BiometricsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('biometrics_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'biometrics_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: ((db, version) => createTables(db)),
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  void createTables(Database db) {
    db.execute(
      'CREATE TABLE biometrics(id INTEGER PRIMARY KEY, currentWeight REAL, bodyFat INTEGER, dateTime TEXT, weekId INTEGER)',
    );

    db.execute(
      'CREATE TABLE weeks(id INTEGER PRIMARY KEY, week INTEGER, calorieDeficit INTEGER, weightLoss REAL, weightGoal REAL, bodyFatGoal REAL)',
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> insertBiometric(Biometric biometric) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'biometrics',
      biometric.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> updateBiometric(Biometric biometric) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'biometrics',
      biometric.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Biometric>> getBiometrics() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('biometrics');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Biometric(
        id: maps[i]['id'],
        currentWeight: maps[i]['currentWeight'],
        bodyFat: maps[i]['bodyFat'],
        dateTime: maps[i]['dateTime'],
        weekId: maps[i]['weekId'],
      );
    });
  }

  Future<void> deleteBiometrics(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'biometrics',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
