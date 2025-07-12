import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/workout_provider.dart';
import 'package:fitness_tracker/widgets/workout_card.dart';
import 'package:fitness_tracker/widgets/add_workout_dialog.dart';
import 'package:fitness_tracker/widgets/progress_chart.dart';
import 'package:intl/intl.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().loadWorkouts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(),
          _buildProgressTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWorkoutDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTodayTab() {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        if (workoutProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (workoutProvider.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  workoutProvider.error,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => workoutProvider.loadWorkouts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final todayWorkouts = workoutProvider.workouts
            .where((workout) => workout.date == _selectedDate)
            .toList();

        if (todayWorkouts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 64,
                  color: Colors.white54,
                ),
                const SizedBox(height: 16),
                Text(
                  'No workouts for ${DateFormat('MMM dd, yyyy').format(DateTime.parse(_selectedDate))}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first workout!',
                  style: const TextStyle(
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: todayWorkouts.length,
          itemBuilder: (context, index) {
            return WorkoutCard(
              workout: todayWorkouts[index],
              onEdit: () => _showEditWorkoutDialog(todayWorkouts[index]),
              onDelete: () => _deleteWorkout(todayWorkouts[index].id!),
            );
          },
        );
      },
    );
  }

  Widget _buildProgressTab() {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        if (workoutProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final exercises = workoutProvider.getUniqueExercises();
        
        if (exercises.isEmpty) {
          return const Center(
            child: Text(
              'No workout data available for progress tracking',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Charts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...exercises.map((exercise) => ProgressChart(
                      exerciseName: exercise,
                      workouts: workoutProvider.getWorkoutsByExerciseMap()[exercise] ?? [],
                    )),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_selectedDate),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showAddWorkoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AddWorkoutDialog(
        selectedDate: _selectedDate,
      ),
    );
  }

  void _showEditWorkoutDialog(dynamic workout) {
    showDialog(
      context: context,
      builder: (context) => AddWorkoutDialog(
        selectedDate: _selectedDate,
        workout: workout,
      ),
    );
  }

  void _deleteWorkout(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: const Text('Are you sure you want to delete this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<WorkoutProvider>().deleteWorkout(id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 