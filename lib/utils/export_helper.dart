import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportHelper {
  static Future<void> exportData(String data, String filename, String subject) async {
    try {
      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      
      // Write the data to the file
      await file.writeAsString(data);
      
      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: subject,
        text: 'Fitness Tracker Data Export',
      );
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  static Future<String> exportToCSV(List<Map<String, dynamic>> data, List<String> headers) async {
    final csvBuffer = StringBuffer();
    
    // Add headers
    csvBuffer.writeln(headers.join(','));
    
    // Add data rows
    for (final row in data) {
      final values = headers.map((header) {
        final value = row[header]?.toString() ?? '';
        // Escape commas and quotes
        if (value.contains(',') || value.contains('"')) {
          return '"${value.replaceAll('"', '""')}"';
        }
        return value;
      });
      csvBuffer.writeln(values.join(','));
    }
    
    return csvBuffer.toString();
  }

  static Future<void> exportWorkoutDataToCSV(List<Map<String, dynamic>> workouts) async {
    final headers = ['Date', 'Exercise', 'Sets', 'Reps', 'Weight', 'Notes'];
    final csvData = await exportToCSV(workouts, headers);
    
    await exportData(
      csvData,
      'workout_data_${DateTime.now().millisecondsSinceEpoch}.csv',
      'Workout Data Export (CSV)',
    );
  }

  static Future<void> exportMedicalDataToCSV(List<Map<String, dynamic>> medicalData) async {
    final headers = ['Date', 'Type', 'Value', 'Unit', 'Notes'];
    final csvData = await exportToCSV(medicalData, headers);
    
    await exportData(
      csvData,
      'medical_data_${DateTime.now().millisecondsSinceEpoch}.csv',
      'Medical Data Export (CSV)',
    );
  }
} 