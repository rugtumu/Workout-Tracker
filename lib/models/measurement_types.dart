class MeasurementTypes {
  static const List<String> predefinedTypes = [
    "Body weight",
    "Waist",
    "Body fat",
    "Left biceps",
    "Right biceps",
    "Left forearm",
    "Right forearm",
    "Caloric intake",
  ];

  static const Map<String, String> defaultUnits = {
    "Body weight": "kg",
    "Waist": "cm",
    "Body fat": "%",
    "Left biceps": "cm",
    "Right biceps": "cm",
    "Left forearm": "cm",
    "Right forearm": "cm",
    "Caloric intake": "kcal",
  };

  static String getDefaultUnit(String type) {
    return defaultUnits[type] ?? "";
  }

  static bool isPredefined(String type) {
    return predefinedTypes.contains(type);
  }
} 