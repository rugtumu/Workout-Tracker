import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/exercise_types.dart';

class AddWorkoutDialog extends StatefulWidget {
  final String selectedDate;
  final Workout? workout;

  const AddWorkoutDialog({
    super.key,
    required this.selectedDate,
    this.workout,
  });

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isCardio = false;

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _exerciseController.text = widget.workout!.exerciseName;
      _setsController.text = widget.workout!.sets.toString();
      _repsController.text = widget.workout!.reps.toString();
      _weightController.text = widget.workout!.weight.toString();
      _durationController.text = widget.workout!.durationMinutes?.toString() ?? '';
      _notesController.text = widget.workout!.notes ?? '';
      _isCardio = ExerciseTypes.isCardio(widget.workout!.exerciseName);
    }
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF232D28), // Slightly lighter than main background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {}, // Prevents closing when tapping on form fields
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.workout == null ? 'Add Workout' : 'Edit Workout',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return ExerciseTypes.predefinedExercises;
                            }
                            return ExerciseTypes.getFilteredExercises(textEditingValue.text);
                          },
                          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: 'Exercise Name',
                                hintText: 'Select or type exercise name',
                                filled: true,
                                fillColor: const Color(0xFF294034), // More contrast
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an exercise name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _isCardio = ExerciseTypes.isCardio(value);
                                });
                              },
                            );
                          },
                          onSelected: (String selection) {
                            _exerciseController.text = selection;
                            setState(() {
                              _isCardio = ExerciseTypes.isCardio(selection);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_isCardio) ...[
                          TextFormField(
                            controller: _durationController,
                            decoration: InputDecoration(
                              labelText: 'Duration (minutes)',
                              hintText: '30',
                              filled: true,
                              fillColor: const Color(0xFF294034),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter duration';
                              }
                              final duration = int.tryParse(value);
                              if (duration == null || duration <= 0) {
                                return 'Invalid duration';
                              }
                              return null;
                            },
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _setsController,
                                  decoration: InputDecoration(
                                    labelText: 'Sets',
                                    hintText: '3',
                                    filled: true,
                                    fillColor: const Color(0xFF294034),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    final sets = int.tryParse(value);
                                    if (sets == null || sets <= 0) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _repsController,
                                  decoration: InputDecoration(
                                    labelText: 'Reps',
                                    hintText: '10',
                                    filled: true,
                                    fillColor: const Color(0xFF294034),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    final reps = int.tryParse(value);
                                    if (reps == null || reps <= 0) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _weightController,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              hintText: '50.0',
                              filled: true,
                              fillColor: const Color(0xFF294034),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter weight';
                              }
                              final weight = double.tryParse(value);
                              if (weight == null || weight < 0) {
                                return 'Invalid weight';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            labelText: 'Notes (optional)',
                            hintText: 'How did it feel?',
                            filled: true,
                            fillColor: const Color(0xFF294034),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _saveWorkout,
                              child: Text(widget.workout == null ? 'Add' : 'Update'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      final workout = Workout(
        id: widget.workout?.id,
        date: widget.selectedDate,
        exerciseName: _exerciseController.text.trim(),
        sets: _isCardio ? 1 : int.parse(_setsController.text),
        reps: _isCardio ? 1 : int.parse(_repsController.text),
        weight: _isCardio ? 0.0 : double.parse(_weightController.text),
        durationMinutes: _isCardio ? int.parse(_durationController.text) : null,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      final workoutProvider = context.read<WorkoutProvider>();
      
      if (widget.workout == null) {
        await workoutProvider.addWorkout(workout);
      } else {
        await workoutProvider.updateWorkout(workout);
      }

      Navigator.of(context).pop();
    }
  }
} 