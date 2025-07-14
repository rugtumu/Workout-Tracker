class MeasurementTypes {
  static const List<String> predefinedTypes = [
    "Body Weight",
    "Waist",
    "Body Fat",
    "Left Biceps",
    "Right Biceps",
    "Left Forearm",
    "Right Forearm",
    "Caloric Intake",
  ];

  static const Map<String, String> defaultUnits = {
    "Body Weight": "kg",
    "Waist": "cm",
    "Body Fat": "%",
    "Left Biceps": "cm",
    "Right Biceps": "cm",
    "Left Forearm": "cm",
    "Right Forearm": "cm",
    "Caloric Intake": "kcal",
  };

  static String getDefaultUnit(String type) {
    return defaultUnits[type] ?? "";
  }

  static bool isPredefined(String type) {
    return predefinedTypes.contains(type);
  }
} 