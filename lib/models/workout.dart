class Workout {
  final int? id;
  final String date;
  final String exerciseName;
  final int sets;
  final int reps;
  final double weight;
  final int? durationMinutes; // For cardio exercises
  final String? notes;

  Workout({
    this.id,
    required this.date,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weight,
    this.durationMinutes,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'exercise_name': exerciseName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration_minutes': durationMinutes,
      'notes': notes,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      date: map['date'],
      exerciseName: map['exercise_name'],
      sets: map['sets'],
      reps: map['reps'],
      weight: map['weight'],
      durationMinutes: map['duration_minutes'],
      notes: map['notes'],
    );
  }

  Workout copyWith({
    int? id,
    String? date,
    String? exerciseName,
    int? sets,
    int? reps,
    double? weight,
    int? durationMinutes,
    String? notes,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'Workout(id: $id, date: $date, exerciseName: $exerciseName, sets: $sets, reps: $reps, weight: $weight, durationMinutes: $durationMinutes, notes: $notes)';
  }
} 