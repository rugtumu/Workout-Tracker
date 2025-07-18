import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/medical_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  final String dbPassword;

  DatabaseHelper._init(this.dbPassword);

  static Future<DatabaseHelper> getInstance() async {
    if (_instance != null) return _instance!;
    final storage = FlutterSecureStorage();
    String? password = await storage.read(key: 'db_password');
    if (password == null) {
      // This should not happen; PIN setup should be done before DB init
      throw Exception('Database password not set!');
    }
    _instance = DatabaseHelper._init(password);
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_tracker.db', dbPassword);
    return _database!;
  }

  Future<Database> _initDB(String filePath, String dbPassword) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2, // Updated version for migration
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      password: dbPassword,
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
        duration_minutes INTEGER,
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

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration to version 2: Update exercise names to proper capitalization
      await _migrateExerciseNames(db);
      
      // Add duration_minutes column for cardio exercises
      await db.execute('ALTER TABLE workouts ADD COLUMN duration_minutes INTEGER');
    }
  }

  Future<void> _migrateExerciseNames(Database db) async {
    // Map of old exercise names to new properly capitalized names
    final Map<String, String> exerciseNameMappings = {
      'Chest press': 'Chest Press',
      'Bench press': 'Bench Press',
      'Declined bench press': 'Declined Bench Press',
      'Inclined bench press': 'Inclined Bench Press',
      'Inclined dumbbell chest press': 'Inclined Dumbbell Chest Press',
      'Dumbbell chest press': 'Dumbbell Chest Press',
      'Machine chest press': 'Machine Chest Press',
      'Pectoral fly cable': 'Pectoral Fly Cable',
      'Pectoral fly machine': 'Pectoral Fly Machine',
      'Cable triceps pushdown': 'Cable Triceps Pushdown',
      'Dumbbell biceps': 'Dumbbell Biceps',
      'Dumbbell forearm': 'Dumbbell Forearm',
      'Dumbbell triceps': 'Dumbbell Triceps',
      'Z-bar biceps': 'Z-bar Biceps',
      'Z-bar triceps': 'Z-bar Triceps',
      'Lat pulldown': 'Lat Pulldown',
      'Narrow seated cable row': 'Narrow Seated Cable Row',
      'Seated row': 'Seated Row',
      'Wide seated cable row': 'Wide Seated Cable Row',
      'Declined bench abs': 'Declined Bench Abs',
      'Pilates ball abs': 'Pilates Ball Abs',
      'Back extension': 'Back Extension',
      'Leg curl': 'Leg Curl',
      'Leg extension': 'Leg Extension',
      'Leg press': 'Leg Press',
      'Calf raise': 'Calf Raise',
    };

    // Update each exercise name in the database
    for (final entry in exerciseNameMappings.entries) {
      await db.update(
        'workouts',
        {'exercise_name': entry.value},
        where: 'exercise_name = ?',
        whereArgs: [entry.key],
      );
    }
  }

  // Workout CRUD operations
  Future<int> insertWorkout(Workout workout) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    return await db.insert('workouts', workout.toMap());
  }

  Future<List<Workout>> getWorkouts() async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('workouts', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  Future<List<Workout>> getWorkoutsByDate(String date) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'exercise_name ASC',
    );
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  Future<List<Workout>> getWorkoutsByExercise(String exerciseName) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'exercise_name = ?',
      whereArgs: [exerciseName],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  Future<int> updateWorkout(Workout workout) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    return await db.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    return await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Medical data CRUD operations
  Future<int> insertMedicalData(MedicalData data) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    return await db.insert('medical_data', data.toMap());
  }

  Future<List<MedicalData>> getMedicalData() async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('medical_data', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => MedicalData.fromMap(maps[i]));
  }

  Future<List<MedicalData>> getMedicalDataByType(String type) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medical_data',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => MedicalData.fromMap(maps[i]));
  }

  Future<int> updateMedicalData(MedicalData data) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    return await db.update(
      'medical_data',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> deleteMedicalData(int id) async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
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

  // Homepage specific queries
  Future<int> getWeeklyStreak() async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    
    // Get all unique dates where workouts were done
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT DISTINCT date FROM workouts ORDER BY date DESC
    ''');
    
    if (maps.isEmpty) return 0;
    
    final List<String> workoutDates = maps.map((m) => m['date'] as String).toList();
    final List<DateTime> dates = workoutDates.map((d) => DateTime.parse(d)).toList();
    
    // Calculate weekly streak
    int streak = 0;
    DateTime? currentWeekStart;
    
    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      
      if (currentWeekStart == null) {
        currentWeekStart = weekStart;
        streak = 1;
      } else {
        final weeksDiff = currentWeekStart.difference(weekStart).inDays ~/ 7;
        if (weeksDiff == 1) {
          streak++;
          currentWeekStart = weekStart;
        } else if (weeksDiff > 1) {
          break; // Streak broken
        }
      }
    }
    
    return streak;
  }

  Future<double?> getCurrentBodyWeight() async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'medical_data',
      where: 'type = ?',
      whereArgs: ['Body Weight'],
      orderBy: 'date DESC',
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return maps.first['value'] as double;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getFavoriteExercise() async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    
    // Get exercise with most workouts, then highest weight if tied
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        exercise_name,
        COUNT(*) as workout_count,
        MAX(weight) as max_weight
      FROM workouts 
      GROUP BY exercise_name 
      ORDER BY workout_count DESC, max_weight DESC 
      LIMIT 1
    ''');
    
    if (maps.isNotEmpty) {
      return {
        'exercise_name': maps.first['exercise_name'],
        'workout_count': maps.first['workout_count'],
        'max_weight': maps.first['max_weight'],
      };
    }
    return null;
  }

  Future<Map<String, dynamic>?> getBenchPressPR() async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'exercise_name = ?',
      whereArgs: ['Bench Press'],
      orderBy: 'weight DESC',
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return {
        'weight': maps.first['weight'],
        'date': maps.first['date'],
        'sets': maps.first['sets'],
        'reps': maps.first['reps'],
      };
    }
    return null;
  }

  Future<Map<String, dynamic>> getWeeklySummary() async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    
    // Get current week's start and end
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    final weekStartStr = weekStart.toIso8601String().split('T')[0];
    final weekEndStr = weekEnd.toIso8601String().split('T')[0];
    
    // Get workouts this week
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        COUNT(DISTINCT date) as workout_days,
        COUNT(*) as total_workouts,
        SUM(COALESCE(duration_minutes, 0)) as total_duration
      FROM workouts 
      WHERE date BETWEEN ? AND ?
    ''', [weekStartStr, weekEndStr]);
    
    if (maps.isNotEmpty) {
      return {
        'workout_days': maps.first['workout_days'] ?? 0,
        'total_workouts': maps.first['total_workouts'] ?? 0,
        'total_duration': maps.first['total_duration'] ?? 0,
      };
    }
    
    return {
      'workout_days': 0,
      'total_workouts': 0,
      'total_duration': 0,
    };
  }

  Future<void> close() async {
    final dbHelper = await DatabaseHelper.getInstance();
    final db = await dbHelper.database;
    db.close();
  }
} 