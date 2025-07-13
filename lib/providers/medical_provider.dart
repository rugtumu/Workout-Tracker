import 'package:flutter/foundation.dart';
import 'package:workout_tracker/models/medical_data.dart';
import 'package:workout_tracker/utils/database_helper.dart';

class MedicalProvider with ChangeNotifier {
  List<MedicalData> _medicalData = [];
  bool _isLoading = false;
  String _error = '';

  List<MedicalData> get medicalData => _medicalData;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadMedicalData() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _medicalData = await DatabaseHelper.instance.getMedicalData();
    } catch (e) {
      _error = 'Failed to load medical data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedicalData(MedicalData data) async {
    try {
      await DatabaseHelper.instance.insertMedicalData(data);
      await loadMedicalData();
    } catch (e) {
      _error = 'Failed to add medical data: $e';
      notifyListeners();
    }
  }

  Future<void> updateMedicalData(MedicalData data) async {
    try {
      await DatabaseHelper.instance.updateMedicalData(data);
      await loadMedicalData();
    } catch (e) {
      _error = 'Failed to update medical data: $e';
      notifyListeners();
    }
  }

  Future<void> deleteMedicalData(int id) async {
    try {
      await DatabaseHelper.instance.deleteMedicalData(id);
      await loadMedicalData();
    } catch (e) {
      _error = 'Failed to delete medical data: $e';
      notifyListeners();
    }
  }

  Future<List<MedicalData>> getMedicalDataByType(String type) async {
    try {
      return await DatabaseHelper.instance.getMedicalDataByType(type);
    } catch (e) {
      _error = 'Failed to get medical data by type: $e';
      notifyListeners();
      return [];
    }
  }

  List<String> getUniqueTypes() {
    final types = _medicalData.map((m) => m.type).toSet().toList();
    types.sort();
    return types;
  }

  Map<String, List<MedicalData>> getMedicalDataByTypeMap() {
    final Map<String, List<MedicalData>> typeMap = {};
    for (final data in _medicalData) {
      if (!typeMap.containsKey(data.type)) {
        typeMap[data.type] = [];
      }
      typeMap[data.type]!.add(data);
    }
    return typeMap;
  }

  List<MedicalData> getMedicalDataByDateRange(DateTime start, DateTime end) {
    return _medicalData.where((data) {
      final dataDate = DateTime.parse(data.date);
      return dataDate.isAfter(start.subtract(const Duration(days: 1))) &&
             dataDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
} 