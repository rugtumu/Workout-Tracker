import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/medical_data.dart';
import 'package:workout_tracker/utils/database_helper.dart';

class ImportHelper {
  static Future<Map<String, dynamic>?> importData() async {
    try {
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null) return null;

      // Read file
      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate data structure
      if (!_validateImportData(data)) {
        throw Exception('Invalid data format. This file was not exported from this app.');
      }

      return data;
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  static bool _validateImportData(Map<String, dynamic> data) {
    // Check if it has the expected structure
    if (!data.containsKey('workouts') || !data.containsKey('medical_data')) {
      return false;
    }

    // Validate workouts structure
    if (data['workouts'] is List) {
      for (final workout in data['workouts']) {
        if (workout is! Map<String, dynamic>) return false;
        if (!workout.containsKey('date') || 
            !workout.containsKey('exercise_name') ||
            !workout.containsKey('sets') ||
            !workout.containsKey('reps') ||
            !workout.containsKey('weight')) {
          return false;
        }
      }
    }

    // Validate medical data structure
    if (data['medical_data'] is List) {
      for (final medicalData in data['medical_data']) {
        if (medicalData is! Map<String, dynamic>) return false;
        if (!medicalData.containsKey('date') || 
            !medicalData.containsKey('type') ||
            !medicalData.containsKey('value')) {
          return false;
        }
      }
    }

    return true;
  }

  static Future<void> importWorkouts(List<dynamic> workoutsData) async {
    final dbHelper = await DatabaseHelper.getInstance();
    for (final workoutData in workoutsData) {
      final workout = Workout.fromMap(workoutData);
      await dbHelper.insertWorkout(workout);
    }
  }

  static Future<void> importMedicalData(List<dynamic> medicalDataList) async {
    final dbHelper = await DatabaseHelper.getInstance();
    for (final medicalData in medicalDataList) {
      final data = MedicalData.fromMap(medicalData);
      await dbHelper.insertMedicalData(data);
    }
  }

  static Future<void> importAllData(Map<String, dynamic> data) async {
    // Import workouts
    if (data['workouts'] is List) {
      await importWorkouts(data['workouts']);
    }

    // Import medical data
    if (data['medical_data'] is List) {
      await importMedicalData(data['medical_data']);
    }
  }
} 