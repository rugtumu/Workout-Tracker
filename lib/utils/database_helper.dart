import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:fitness_tracker/models/medical_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Workout table
    await db.execute('''
      CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        exercise_name TEXT NOT NULL,
        sets INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight REAL NOT NULL,
        notes TEXT
      )
    ''');

    // Medical data table
    await db.execute('''
      CREATE TABLE medical_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        unit TEXT,
        notes TEXT
      )
    ''');
  }

  // Workout CRUD operations
  Future<int> insertWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.insert('workouts', workout.toMap());
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('workouts', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  Future<List<Workout>> getWorkoutsByDate(String date) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'exercise_name ASC',
    );
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  Future<List<Workout>> getWorkoutsByExercise(String exerciseName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'exercise_name = ?',
      whereArgs: [exerciseName],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  Future<int> updateWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final db = await instance.database;
    return await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Medical data CRUD operations
  Future<int> insertMedicalData(MedicalData data) async {
    final db = await instance.database;
    return await db.insert('medical_data', data.toMap());
  }

  Future<List<MedicalData>> getMedicalData() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('medical_data', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => MedicalData.fromMap(maps[i]));
  }

  Future<List<MedicalData>> getMedicalDataByType(String type) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medical_data',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => MedicalData.fromMap(maps[i]));
  }

  Future<int> updateMedicalData(MedicalData data) async {
    final db = await instance.database;
    return await db.update(
      'medical_data',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> deleteMedicalData(int id) async {
    final db = await instance.database;
    return await db.delete(
      'medical_data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Export data
  Future<Map<String, dynamic>> exportAllData() async {
    final workouts = await getWorkouts();
    final medicalData = await getMedicalData();
    
    return {
      'workouts': workouts.map((w) => w.toMap()).toList(),
      'medical_data': medicalData.map((m) => m.toMap()).toList(),
      'export_date': DateTime.now().toIso8601String(),
    };
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
} 