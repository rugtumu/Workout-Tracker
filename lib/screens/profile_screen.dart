import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/workout_provider.dart';
import 'package:fitness_tracker/providers/medical_provider.dart';
import 'package:fitness_tracker/utils/database_helper.dart';
import 'package:fitness_tracker/utils/export_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildDataSection(context),
          const SizedBox(height: 24),
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fitness Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Personal Health Companion',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer2<WorkoutProvider, MedicalProvider>(
              builder: (context, workoutProvider, medicalProvider, child) {
                return Column(
                  children: [
                    _buildDataCard(
                      'Workouts',
                      '${workoutProvider.workouts.length} entries',
                      Icons.fitness_center,
                      Colors.green,
                      () => _exportWorkoutData(context),
                    ),
                    const SizedBox(height: 12),
                    _buildDataCard(
                      'Medical Data',
                      '${medicalProvider.medicalData.length} entries',
                      Icons.health_and_safety,
                      Colors.blue,
                      () => _exportMedicalData(context),
                    ),
                    const SizedBox(height: 12),
                    _buildDataCard(
                      'Export All Data',
                      'Backup everything',
                      Icons.download,
                      Colors.orange,
                      () => _exportAllData(context),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      color: const Color(0xFF2A2A2A),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('About'),
              subtitle: const Text('App version and information'),
              onTap: () => _showAboutDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.green),
              title: const Text('Privacy'),
              subtitle: const Text('Data privacy information'),
              onTap: () => _showPrivacyDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Clear All Data'),
              subtitle: const Text('Delete all workout and medical data'),
              onTap: () => _showClearDataDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _exportWorkoutData(BuildContext context) async {
    try {
      final workoutProvider = context.read<WorkoutProvider>();
      final data = workoutProvider.workouts.map((w) => w.toMap()).toList();
      final jsonData = jsonEncode(data);
      
      await ExportHelper.exportData(
        jsonData,
        'workout_data_${DateTime.now().millisecondsSinceEpoch}.json',
        'Workout Data Export',
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout data exported successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export workout data: $e')),
        );
      }
    }
  }

  void _exportMedicalData(BuildContext context) async {
    try {
      final medicalProvider = context.read<MedicalProvider>();
      final data = medicalProvider.medicalData.map((m) => m.toMap()).toList();
      final jsonData = jsonEncode(data);
      
      await ExportHelper.exportData(
        jsonData,
        'medical_data_${DateTime.now().millisecondsSinceEpoch}.json',
        'Medical Data Export',
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medical data exported successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export medical data: $e')),
        );
      }
    }
  }

  void _exportAllData(BuildContext context) async {
    try {
      final allData = await DatabaseHelper.instance.exportAllData();
      final jsonData = jsonEncode(allData);
      
      await ExportHelper.exportData(
        jsonData,
        'fitness_tracker_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        'Complete Data Backup',
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data exported successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export data: $e')),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Fitness Tracker'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('A private, offline-capable workout tracker for personal use.'),
            SizedBox(height: 16),
            Text('Features:'),
            Text('• Workout logging and tracking'),
            Text('• Medical data monitoring'),
            Text('• Progress visualization'),
            Text('• Data export capabilities'),
            SizedBox(height: 16),
            Text('Built with Flutter and SQLite'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your data is stored locally on your device.'),
            SizedBox(height: 8),
            Text('• No data is sent to external servers'),
            Text('• All data is encrypted in the local database'),
            Text('• You control your data completely'),
            SizedBox(height: 8),
            Text('For data backup, use the export features in this app.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all workout and medical data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllData(context);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearAllData(BuildContext context) async {
    try {
      final workoutProvider = context.read<WorkoutProvider>();
      final medicalProvider = context.read<MedicalProvider>();
      
      // Clear all data
      for (final workout in workoutProvider.workouts) {
        if (workout.id != null) {
          await workoutProvider.deleteWorkout(workout.id!);
        }
      }
      
      for (final medicalData in medicalProvider.medicalData) {
        if (medicalData.id != null) {
          await medicalProvider.deleteMedicalData(medicalData.id!);
        }
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data cleared successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear data: $e')),
        );
      }
    }
  }
} 