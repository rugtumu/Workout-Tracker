import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'package:workout_tracker/providers/medical_provider.dart';
import 'package:workout_tracker/utils/database_helper.dart';
import 'package:workout_tracker/utils/export_helper.dart';
import 'package:workout_tracker/utils/import_helper.dart';
import 'package:workout_tracker/utils/biometric_helper.dart';
import 'dart:convert';
import 'package:workout_tracker/screens/welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    final storage = FlutterSecureStorage();
    final isEnabled = await storage.read(key: 'biometric_enabled');
    final isAvailable = await BiometricHelper.isBiometricAvailable();
    
    setState(() {
      _isBiometricEnabled = isEnabled == 'true';
      _isBiometricAvailable = isAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildDataSection(context),
          const SizedBox(height: 24),
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.fitness_center,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Workout Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Personal Fitness Companion',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Encrypted & Private',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.offline_bolt, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Offline First',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _openGitHub(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.code, color: Colors.white54, size: 16),
                    SizedBox(width: 8),
                                         Text(
                       'Developed by rugtumu',
                       style: TextStyle(
                         color: Colors.white54,
                         fontSize: 12,
                       ),
                     ),
                  ],
                ),
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
            _buildDataCard(
              'Export Workout Data',
              'Export your workout data as JSON',
              Icons.fitness_center,
              Colors.green,
              () => _exportWorkoutData(context),
            ),
            const SizedBox(height: 12),
            _buildDataCard(
              'Export Medical Data',
              'Export your medical data as JSON',
              Icons.health_and_safety,
              Colors.blue,
              () => _exportMedicalData(context),
            ),
            const SizedBox(height: 12),
            _buildDataCard(
              'Export All Data',
              'Export complete backup of all data',
              Icons.backup,
              Colors.orange,
              () => _exportAllData(context),
            ),
            const SizedBox(height: 12),
            _buildDataCard(
              'Import Data',
              'Import data from backup files',
              Icons.file_upload,
              Colors.purple,
              () => _importData(context),
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
            
            // Fingerprint information card for existing users
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.fingerprint, color: Colors.purple),
                  title: const Text('Fingerprint Authentication'),
                  subtitle: Text(_isBiometricEnabled ? 'Enabled' : 'Disabled'),
                  trailing: Switch(
                    value: _isBiometricEnabled,
                    onChanged: _isBiometricAvailable
                        ? (value) => _toggleBiometric(context, value)
                        : null,
                  ),
                ),
                if (!_isBiometricAvailable)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Fingerprint is not compatible with this device.',
                            style: TextStyle(color: Colors.orange, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
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

  Future<void> _toggleBiometric(BuildContext context, bool enabled) async {
    final storage = FlutterSecureStorage();
    if (enabled) {
      // Test biometric authentication before enabling
      print('DEBUG: ProfileScreen - Starting biometric authentication...');
      final isAuthenticated = await BiometricHelper.authenticate();
      print('DEBUG: ProfileScreen - Authentication result: $isAuthenticated');
      
      if (isAuthenticated) {
        await storage.write(key: 'biometric_enabled', value: 'true');
        setState(() {
          _isBiometricEnabled = true;
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint authentication enabled'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed. Please check your fingerprint settings and try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      await storage.write(key: 'biometric_enabled', value: 'false');
      setState(() {
        _isBiometricEnabled = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint authentication disabled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
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
      final dbHelper = await DatabaseHelper.getInstance();
      final allData = await dbHelper.exportAllData();
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

  void _importData(BuildContext context) async {
    try {
      // Show confirmation dialog
      final shouldImport = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Import Data'),
          content: const Text(
            'This will import data from a backup file. Existing data will be preserved. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Import'),
            ),
          ],
        ),
      );

      if (shouldImport != true) return;

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Importing data...'),
            ],
          ),
        ),
      );

      // Import data
      final data = await ImportHelper.importData();
      if (data != null) {
        await ImportHelper.importAllData(data);
        
        // Refresh providers
        await context.read<WorkoutProvider>().loadWorkouts();
        await context.read<MedicalProvider>().loadMedicalData();

        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data imported successfully')),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to import data: $e')),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Workout Tracker'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.2'),
            SizedBox(height: 8),
            Text('A private, offline-capable workout tracker for personal use.'),
            SizedBox(height: 16),
            Text('Features:'),
            Text('• Workout logging and tracking.'),
            Text('• Medical data monitoring.'),
            Text('• Progress visualization.'),
            Text('• Data export/import capabilities.'),
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
            Text('• No data is sent to external servers.'),
            Text('• All data is encrypted in the local database.'),
            Text('• You control your data completely.'),
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
        title: const Text('⚠️ Clear All Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('⚠️ WARNING: This action is irreversible!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            SizedBox(height: 8),
            Text('This will permanently delete:'),
            Text('• All workout data'),
            Text('• All medical data'),
            Text('• All progress history'),
            SizedBox(height: 8),
            Text('💡 Recommendation: Export your data first using the "Export All Data" option above.'),
            SizedBox(height: 8),
            Text('This action cannot be undone. Are you absolutely sure?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSecondWarning(context);
            },
            child: const Text('I Understand', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showSecondWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚨 Final Warning'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This is your LAST chance to cancel.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            SizedBox(height: 8),
            Text('All your data will be permanently deleted.'),
            SizedBox(height: 8),
            Text('To confirm deletion, type exactly:'),
            SizedBox(height: 4),
            Text('"Terminate all!"', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showFinalConfirmation(context);
            },
            child: const Text('Continue', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showFinalConfirmation(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔒 Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Type the exact phrase to confirm:'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Terminate all!',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text('This action cannot be undone.', style: TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim() == "Terminate all!") {
                Navigator.of(context).pop();
                _clearAllData(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect phrase. Please type exactly: Terminate all!')),
                );
              }
            },
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
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
        Navigator.of(context).pop(); // Close any open dialogs
        _showDataTerminatedScreen(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear data: $e')),
        );
      }
    }
  }

  void _showDataTerminatedScreen(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('✅ Data Terminated Successfully'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Your data has been terminated successfully.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'All workout and medical data has been permanently deleted.',
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openGitHub(BuildContext context) async {
    final Uri url = Uri.parse('https://github.com/rugtumu/Workout-Tracker');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open GitHub link')),
        );
      }
    }
  }
} 