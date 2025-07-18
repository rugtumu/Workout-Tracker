import 'package:flutter/foundation.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/utils/database_helper.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  bool _isLoading = false;
  String _error = '';

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadWorkouts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final dbHelper = await DatabaseHelper.getInstance();
      _workouts = await dbHelper.getWorkouts();
    } catch (e) {
      _error = 'Failed to load workouts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addWorkout(Workout workout) async {
    try {
      final dbHelper = await DatabaseHelper.getInstance();
      await dbHelper.insertWorkout(workout);
      await loadWorkouts();
    } catch (e) {
      _error = 'Failed to add workout: $e';
      notifyListeners();
    }
  }

  Future<void> updateWorkout(Workout workout) async {
    try {
      final dbHelper = await DatabaseHelper.getInstance();
      await dbHelper.updateWorkout(workout);
      await loadWorkouts();
    } catch (e) {
      _error = 'Failed to update workout: $e';
      notifyListeners();
    }
  }

  Future<void> deleteWorkout(int id) async {
    try {
      final dbHelper = await DatabaseHelper.getInstance();
      await dbHelper.deleteWorkout(id);
      await loadWorkouts();
    } catch (e) {
      _error = 'Failed to delete workout: $e';
      notifyListeners();
    }
  }

  Future<List<Workout>> getWorkoutsByDate(String date) async {
    try {
      final dbHelper = await DatabaseHelper.getInstance();
      return await dbHelper.getWorkoutsByDate(date);
    } catch (e) {
      _error = 'Failed to get workouts by date: $e';
      notifyListeners();
      return [];
    }
  }

  Future<List<Workout>> getWorkoutsByExercise(String exerciseName) async {
    try {
      final dbHelper = await DatabaseHelper.getInstance();
      return await dbHelper.getWorkoutsByExercise(exerciseName);
    } catch (e) {
      _error = 'Failed to get workouts by exercise: $e';
      notifyListeners();
      return [];
    }
  }

  List<String> getUniqueExercises() {
    final exercises = _workouts.map((w) => w.exerciseName).toSet().toList();
    exercises.sort();
    return exercises;
  }

  Map<String, List<Workout>> getWorkoutsByExerciseMap() {
    final Map<String, List<Workout>> exerciseMap = {};
    for (final workout in _workouts) {
      if (!exerciseMap.containsKey(workout.exerciseName)) {
        exerciseMap[workout.exerciseName] = [];
      }
      exerciseMap[workout.exerciseName]!.add(workout);
    }
    return exerciseMap;
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
} 