class MedicalData {
  final int? id;
  final String date;
  final String type;
  final double value;
  final String? unit;
  final String? notes;

  MedicalData({
    this.id,
    required this.date,
    required this.type,
    required this.value,
    this.unit,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'value': value,
      'unit': unit,
      'notes': notes,
    };
  }

  factory MedicalData.fromMap(Map<String, dynamic> map) {
    return MedicalData(
      id: map['id'],
      date: map['date'],
      type: map['type'],
      value: map['value'],
      unit: map['unit'],
      notes: map['notes'],
    );
  }

  MedicalData copyWith({
    int? id,
    String? date,
    String? type,
    double? value,
    String? unit,
    String? notes,
  }) {
    return MedicalData(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'MedicalData(id: $id, date: $date, type: $type, value: $value, unit: $unit, notes: $notes)';
  }
} 