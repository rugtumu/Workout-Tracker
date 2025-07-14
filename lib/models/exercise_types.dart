class ExerciseTypes {
  static const List<String> predefinedExercises = [
    // Core exercises
    "Back Extension",
    "Declined Bench Abs",
    "Pilates Ball Abs",
    
    // Arm exercises
    "Cable Triceps Pushdown",
    "Dumbbell Biceps",
    "Dumbbell Forearm",
    "Dumbbell Triceps",
    "Z-bar Biceps",
    "Z-bar Triceps",
    
    // Back exercises
    "Barfix",
    "Lat Pulldown",
    "Muscle Up",
    "Narrow Seated Cable Row",
    "Seated Row",
    "Wide Seated Cable Row",
    
    // Chest exercises
    "Bench Press",
    "Chest Dips",
    "Declined Bench Press",
    "Dumbbell Chest Press",
    "Inclined Bench Press",
    "Inclined Dumbbell Chest Press",
    "Machine Chest Press",
    "Pectoral Fly Cable",
    "Pectoral Fly Machine",
    
    // Leg exercises
    "Abductor",
    "Adductor",
    "Calf Raise",
    "Leg Curl",
    "Leg Extension", 
    "Leg Press",
    
    // Cardio exercises
    "Running",
    "Cycling",
    "Swimming",
    "Rowing",
    "Elliptical",
    "Stair Climber",
    "Jump Rope",
    "Walking",
    "Hiking",
    "Treadmill",
    "Stationary Bike",
    "Rowing Machine",
  ];

  static const List<String> cardioExercises = [
    "Running",
    "Cycling",
    "Swimming",
    "Rowing",
    "Elliptical",
    "Stair Climber",
    "Jump Rope",
    "Walking",
    "Hiking",
    "Treadmill",
    "Stationary Bike",
    "Rowing Machine",
  ];

  static bool isPredefined(String exercise) {
    return predefinedExercises.contains(exercise);
  }

  static bool isCardio(String exercise) {
    return cardioExercises.contains(exercise);
  }

  static List<String> getFilteredExercises(String query) {
    if (query.isEmpty) {
      return predefinedExercises;
    }
    return predefinedExercises
        .where((exercise) => 
            exercise.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
} 