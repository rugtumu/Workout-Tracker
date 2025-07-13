class ExerciseTypes {
  static const List<String> predefinedExercises = [
    // Core exercises
    "Back extension",
    "Declined bench abs",
    "Pilates ball abs",
    
    // Arm exercises
    "Cable triceps pushdown",
    "Dumbbell biceps",
    "Dumbbell forearm",
    "Dumbbell triceps",
    "Z-bar biceps",
    "Z-bar triceps",
    
    // Back exercises
    "Barfix",
    "Lat pulldown",
    "Muscle up",
    "Narrow seated cable row",
    "Seated row",
    "Wide seated cable row",
    
    // Chest exercises
    "Bench press",
    "Chest dips",
    "Declined bench press",
    "Dumbbell chest press",
    "Inclined bench press",
    "Inclined dumbbell chest press",
    "Inclined dumbbell chest press",
    "Machine chest press",
    "Pectoral fly cable",
    "Pectoral fly machine",
    
    // Leg exercises
    "Abductor",
    "Adductor",
    "Calf raise",
    "Leg curl",
    "Leg extension", 
    "Leg press",
  ];

  static bool isPredefined(String exercise) {
    return predefinedExercises.contains(exercise);
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