/// Duration type for Google Home automations
/// Based on https://developers.home.google.com/automations/schema/basics#duration
/// 
/// Duration represents a period of time in the format:
/// - 30min
/// - 1hour
/// - 20sec
/// - 1hour10min20sec
/// 
/// Last checked: 2024-12-19
class AutomationDuration {
  const AutomationDuration(this.value);
  
  /// The duration string value (e.g., "30min", "1hour", "20sec", "1hour10min20sec")
  final String value;
  
  /// Create a Duration from a string
  factory AutomationDuration.fromString(String value) {
    return AutomationDuration(value);
  }
  
  /// Convert to string (for YAML serialization)
  String toString() => value;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutomationDuration &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
