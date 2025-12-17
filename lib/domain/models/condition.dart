/// Condition models for Google Home automations
/// Based on https://developers.home.google.com/automations/starters-conditions-and-actions

// ============================================================================
// Enums for State Values
// ============================================================================

/// Home presence mode values
/// https://developers.home.google.com/automations/schema/reference/entity/sht_structure/home_presence_state
enum HomePresenceMode {
  home('HOME'),
  away('AWAY');

  const HomePresenceMode(this.value);
  final String value;

  static HomePresenceMode? fromString(String? value) {
    if (value == null) return null;
    return HomePresenceMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown HomePresenceMode: $value'),
    );
  }
}

/// Occupancy state values
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/occupancy_sensing_state
enum OccupancyState {
  occupied('OCCUPIED'),
  unoccupied('UNOCCUPIED');

  const OccupancyState(this.value);
  final String value;

  static OccupancyState? fromString(String? value) {
    if (value == null) return null;
    return OccupancyState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown OccupancyState: $value'),
    );
  }
}

/// Weekday values for time conditions
/// https://developers.home.google.com/automations/schema/reference/standard/time_between_state
enum Weekday {
  monday('MON'),
  tuesday('TUE'),
  wednesday('WED'),
  thursday('THU'),
  friday('FRI'),
  saturday('SAT'),
  sunday('SUN');

  const Weekday(this.value);
  final String value;

  static Weekday? fromString(String? value) {
    if (value == null) return null;
    return Weekday.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown Weekday: $value'),
    );
  }
}

/// Thermostat mode values
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/temperature_setting_state
enum ThermostatMode {
  off('off'),
  heat('heat'),
  cool('cool'),
  heatcool('heatcool'),
  auto('auto'),
  fanOnly('fan-only'),
  purifier('purifier'),
  eco('eco'),
  dry('dry');

  const ThermostatMode(this.value);
  final String value;

  static ThermostatMode? fromString(String? value) {
    if (value == null) return null;
    return ThermostatMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown ThermostatMode: $value'),
    );
  }
}

/// Media playback state values
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_state_state
enum PlaybackState {
  playing('PLAYING'),
  paused('PAUSED'),
  stopped('STOPPED');

  const PlaybackState(this.value);
  final String value;

  static PlaybackState? fromString(String? value) {
    if (value == null) return null;
    return PlaybackState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown PlaybackState: $value'),
    );
  }
}

/// Energy capacity level values
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/energy_storage_state
enum EnergyCapacityLevel {
  criticallyLow('CRITICALLY_LOW'),
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH'),
  full('FULL');

  const EnergyCapacityLevel(this.value);
  final String value;

  static EnergyCapacityLevel? fromString(String? value) {
    if (value == null) return null;
    return EnergyCapacityLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown EnergyCapacityLevel: $value'),
    );
  }
}

// ============================================================================
// Conditions
// ============================================================================

sealed class Condition {
  const Condition();
}

// --- Logical Conditions ---

/// AND condition - all sub-conditions must be true
/// https://developers.home.google.com/automations/schema/reference/standard/and_condition
/// Last checked: 2024-12-19
class AndCondition extends Condition {
  const AndCondition({required this.conditions});
  final List<Condition> conditions;
}

/// OR condition - at least one sub-condition must be true
/// https://developers.home.google.com/automations/schema/reference/standard/or_condition
/// Last checked: 2024-12-19
class OrCondition extends Condition {
  const OrCondition({required this.conditions});
  final List<Condition> conditions;
}

/// NOT condition - negates the sub-condition
/// https://developers.home.google.com/automations/schema/reference/standard/not_condition
/// Last checked: 2024-12-19
class NotCondition extends Condition {
  const NotCondition({required this.condition});
  final Condition condition;
}

// --- Time Conditions ---

/// Time between condition
/// https://developers.home.google.com/automations/schema/reference/standard/time_between_state
/// Last checked: 2024-12-19
class TimeBetweenCondition extends Condition {
  const TimeBetweenCondition({
    this.after,
    this.before,
    this.weekdays,
  });
  final String? after;
  final String? before;
  final List<Weekday>? weekdays; // Array specifying applicable weekdays
}

// --- Home State Conditions ---

/// Home presence condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_structure/home_presence_state
/// Last checked: 2024-12-19
class HomePresenceCondition extends Condition {
  const HomePresenceCondition({
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String state; // homePresenceMode
  final HomePresenceMode? is_;
  final HomePresenceMode? isNot;
  final HomePresenceMode? greaterThan;
  final HomePresenceMode? greaterThanOrEqualTo;
  final HomePresenceMode? lessThan;
  final HomePresenceMode? lessThanOrEqualTo;
}

// --- Device State Conditions ---

/// Generic device state condition for any device state (no specific link - used for various device.state.* types)
/// Last checked: 2024-12-19
class DeviceStateCondition extends Condition {
  const DeviceStateCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state;
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// OnOff state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/on_off_state
/// Last checked: 2024-12-19
class OnOffCondition extends Condition {
  const OnOffCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // on
  final bool? is_;
  final bool? isNot;
  final bool? greaterThan;
  final bool? greaterThanOrEqualTo;
  final bool? lessThan;
  final bool? lessThanOrEqualTo;
}

/// Brightness state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/brightness_state
/// Last checked: 2024-12-19
class BrightnessCondition extends Condition {
  const BrightnessCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // brightness
  final int? is_;
  final int? isNot;
  final int? greaterThan;
  final int? greaterThanOrEqualTo;
  final int? lessThan;
  final int? lessThanOrEqualTo;
}

/// Volume state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/volume_state
/// Last checked: 2024-12-19
/// Note: The type of comparison values depends on the state field:
/// - currentVolume: int (0-100)
/// - isMuted: bool
class VolumeCondition extends Condition {
  const VolumeCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // currentVolume, isMuted
  // For currentVolume: int? (0-100), for isMuted: bool?
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// Lock/Unlock state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/lock_unlock_state
/// Last checked: 2024-12-19
class LockUnlockCondition extends Condition {
  const LockUnlockCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // isLocked
  final bool? is_;
  final bool? isNot;
  final bool? greaterThan;
  final bool? greaterThanOrEqualTo;
  final bool? lessThan;
  final bool? lessThanOrEqualTo;
}

/// Open/Close state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/open_close_state
/// Last checked: 2024-12-19
class OpenCloseCondition extends Condition {
  const OpenCloseCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // openPercent
  final int? is_;
  final int? isNot;
  final int? greaterThan;
  final int? greaterThanOrEqualTo;
  final int? lessThan;
  final int? lessThanOrEqualTo;
}

/// Thermostat/Temperature setting condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/temperature_setting_state
/// Last checked: 2024-12-19
/// Note: The type of comparison values depends on the state field:
/// - thermostatMode: ThermostatMode?
/// - thermostatTemperatureSetpoint, thermostatTemperatureAmbient: double?
class TemperatureSettingCondition extends Condition {
  const TemperatureSettingCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // thermostatMode, thermostatTemperatureSetpoint, thermostatTemperatureAmbient, etc.
  // For thermostatMode: ThermostatMode?, for temperature values: double?
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// Arm/Disarm state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/arm_disarm_state
/// Last checked: 2024-12-19
/// Note: The type of comparison values depends on the state field:
/// - isArmed: bool?
/// - currentArmLevel: String? (device-specific arm level names)
class ArmDisarmCondition extends Condition {
  const ArmDisarmCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // isArmed, currentArmLevel
  // For isArmed: bool?, for currentArmLevel: String?
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// Dock state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/dock_state
/// Last checked: 2024-12-19
class DockCondition extends Condition {
  const DockCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // isDocked
  final bool? is_;
  final bool? isNot;
  final bool? greaterThan;
  final bool? greaterThanOrEqualTo;
  final bool? lessThan;
  final bool? lessThanOrEqualTo;
}

/// Start/Stop state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/start_stop_state
/// Last checked: 2024-12-19
class StartStopCondition extends Condition {
  const StartStopCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // isPaused, isRunning
  final bool? is_;
  final bool? isNot;
  final bool? greaterThan;
  final bool? greaterThanOrEqualTo;
  final bool? lessThan;
  final bool? lessThanOrEqualTo;
}

/// Fan speed state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/fan_speed_state
/// Last checked: 2024-12-19
/// Note: The type of comparison values depends on the state field:
/// - currentFanSpeedPercent: int? (0-100)
/// - currentFanSpeedSetting: String? (device-specific speed names)
class FanSpeedCondition extends Condition {
  const FanSpeedCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // currentFanSpeedPercent, currentFanSpeedSetting
  // For currentFanSpeedPercent: int?, for currentFanSpeedSetting: String?
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// Humidity setting condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/humidity_setting_state
/// Last checked: 2024-12-19
class HumiditySettingCondition extends Condition {
  const HumiditySettingCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // humidityAmbientPercent, humiditySetpointPercent
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// Fill state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/fill_state
/// Last checked: 2024-12-19
class FillCondition extends Condition {
  const FillCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // isFilled, currentFillLevel, currentFillPercent
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// Energy storage state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/energy_storage_state
/// Last checked: 2024-12-19
/// Note: The type of comparison values depends on the state field:
/// - isCharging, isPluggedIn: bool?
/// - descriptiveCapacityRemaining: EnergyCapacityLevel?
class EnergyStorageCondition extends Condition {
  const EnergyStorageCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // isCharging, isPluggedIn, descriptiveCapacityRemaining
  // For isCharging/isPluggedIn: bool?, for descriptiveCapacityRemaining: EnergyCapacityLevel?
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// Motion detection state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/motion_detection_state
/// Last checked: 2024-12-19
class MotionDetectionCondition extends Condition {
  const MotionDetectionCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // motionDetectionEventInProgress
  final bool? is_;
  final bool? isNot;
  final bool? greaterThan;
  final bool? greaterThanOrEqualTo;
  final bool? lessThan;
  final bool? lessThanOrEqualTo;
}

/// Occupancy sensing condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/occupancy_sensing_state
/// Last checked: 2024-12-19
class OccupancySensingCondition extends Condition {
  const OccupancySensingCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // occupancy
  final OccupancyState? is_;
  final OccupancyState? isNot;
  final OccupancyState? greaterThan;
  final OccupancyState? greaterThanOrEqualTo;
  final OccupancyState? lessThan;
  final OccupancyState? lessThanOrEqualTo;
}

/// Online state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/online_state
/// Last checked: 2024-12-19
class OnlineCondition extends Condition {
  const OnlineCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // online
  final bool? is_;
  final bool? isNot;
  final bool? greaterThan;
  final bool? greaterThanOrEqualTo;
  final bool? lessThan;
  final bool? lessThanOrEqualTo;
}

/// Timer state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_state
/// Last checked: 2024-12-19
class TimerCondition extends Condition {
  const TimerCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // timerPaused
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

/// Media state condition
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_state_state
/// Last checked: 2024-12-19
class MediaStateCondition extends Condition {
  const MediaStateCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // playbackState
  final PlaybackState? is_;
  final PlaybackState? isNot;
  final PlaybackState? greaterThan;
  final PlaybackState? greaterThanOrEqualTo;
  final PlaybackState? lessThan;
  final PlaybackState? lessThanOrEqualTo;
}

/// Sensor state condition (for various sensors)
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/sensor_state_state
/// Last checked: 2024-12-19
class SensorStateCondition extends Condition {
  const SensorStateCondition({
    required this.device,
    required this.state,
    this.is_,
    this.isNot,
    this.greaterThan,
    this.greaterThanOrEqualTo,
    this.lessThan,
    this.lessThanOrEqualTo,
  });
  final String device;
  final String state; // e.g., currentSensorStateData.SmokeLevel.currentSensorState, currentSensorStateData.SmokeLevel.rawValue
  final dynamic is_;
  final dynamic isNot;
  final dynamic greaterThan;
  final dynamic greaterThanOrEqualTo;
  final dynamic lessThan;
  final dynamic lessThanOrEqualTo;
}

// ============================================================================
// Condition Type Enum for UI
// ============================================================================

enum ConditionType {
  // Logical
  /// https://developers.home.google.com/automations/schema/reference/standard/and_condition
  and_('AND', 'and'),

  /// https://developers.home.google.com/automations/schema/reference/standard/or_condition
  or_('OR', 'or'),

  /// https://developers.home.google.com/automations/schema/reference/standard/not_condition
  not_('NOT', 'not'),

  // Time
  /// https://developers.home.google.com/automations/schema/reference/standard/time_between_state
  timeBetween('Time Between', 'time.between'),

  // Home
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_structure/home_presence_state
  homePresence('Home Presence', 'home.state.HomePresence'),

  // Device states
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/on_off_state
  onOff('On/Off State', 'device.state.OnOff'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/brightness_state
  brightness('Brightness State', 'device.state.Brightness'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/volume_state
  volume('Volume State', 'device.state.Volume'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/lock_unlock_state
  lockUnlock('Lock State', 'device.state.LockUnlock'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/open_close_state
  openClose('Open/Close State', 'device.state.OpenClose'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/temperature_setting_state
  temperatureSetting('Temperature Setting', 'device.state.TemperatureSetting'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/arm_disarm_state
  armDisarm('Arm/Disarm State', 'device.state.ArmDisarm'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/dock_state
  dock('Dock State', 'device.state.Dock'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/start_stop_state
  startStop('Start/Stop State', 'device.state.StartStop'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/fan_speed_state
  fanSpeed('Fan Speed State', 'device.state.FanSpeed'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/humidity_setting_state
  humiditySetting('Humidity Setting', 'device.state.HumiditySetting'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/fill_state
  fill('Fill State', 'device.state.Fill'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/energy_storage_state
  energyStorage('Energy Storage', 'device.state.EnergyStorage'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/motion_detection_state
  motionDetection('Motion Detection', 'device.state.MotionDetection'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/occupancy_sensing_state
  occupancySensing('Occupancy', 'device.state.OccupancySensing'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/online_state
  online('Online State', 'device.state.Online'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_state
  timer('Timer State', 'device.state.Timer'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_state_state
  mediaState('Media State', 'device.state.MediaState'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/sensor_state_state
  sensorState('Sensor State', 'device.state.SensorState'),

  /// Generic device state (no specific link - used for various device.state.* types)
  deviceState('Device State (Generic)', 'device.state');

  const ConditionType(this.displayName, this.yamlType);

  final String displayName;
  final String yamlType;

  static ConditionType fromCondition(Condition condition) {
    return switch (condition) {
      AndCondition() => ConditionType.and_,
      OrCondition() => ConditionType.or_,
      NotCondition() => ConditionType.not_,
      TimeBetweenCondition() => ConditionType.timeBetween,
      HomePresenceCondition() => ConditionType.homePresence,
      OnOffCondition() => ConditionType.onOff,
      BrightnessCondition() => ConditionType.brightness,
      VolumeCondition() => ConditionType.volume,
      LockUnlockCondition() => ConditionType.lockUnlock,
      OpenCloseCondition() => ConditionType.openClose,
      TemperatureSettingCondition() => ConditionType.temperatureSetting,
      ArmDisarmCondition() => ConditionType.armDisarm,
      DockCondition() => ConditionType.dock,
      StartStopCondition() => ConditionType.startStop,
      FanSpeedCondition() => ConditionType.fanSpeed,
      HumiditySettingCondition() => ConditionType.humiditySetting,
      FillCondition() => ConditionType.fill,
      EnergyStorageCondition() => ConditionType.energyStorage,
      MotionDetectionCondition() => ConditionType.motionDetection,
      OccupancySensingCondition() => ConditionType.occupancySensing,
      OnlineCondition() => ConditionType.online,
      TimerCondition() => ConditionType.timer,
      MediaStateCondition() => ConditionType.mediaState,
      SensorStateCondition() => ConditionType.sensorState,
      DeviceStateCondition() => ConditionType.deviceState,
    };
  }

  /// Create a default condition for this type with realistic examples from docs
  Condition createDefault() {
    return switch (this) {
      ConditionType.and_ => const AndCondition(conditions: []),
      ConditionType.or_ => const OrCondition(conditions: []),
      ConditionType.not_ => const NotCondition(
          condition: TimeBetweenCondition(after: 'sunset', before: 'sunrise')),
      ConditionType.timeBetween =>
        const TimeBetweenCondition(after: 'sunset', before: 'sunrise'),
      ConditionType.homePresence =>
        const HomePresenceCondition(state: 'homePresenceMode', is_: HomePresenceMode.home),
      ConditionType.onOff =>
        const OnOffCondition(device: 'Light - Living Room', state: 'on', is_: true),
      ConditionType.brightness =>
        const BrightnessCondition(device: 'Light - Living Room', state: 'brightness', is_: 50),
      ConditionType.volume =>
        const VolumeCondition(device: 'Speaker - Living Room', state: 'currentVolume', is_: 30),
      ConditionType.lockUnlock =>
        const LockUnlockCondition(device: 'Front Door Lock', state: 'isLocked', is_: true),
      ConditionType.openClose =>
        const OpenCloseCondition(device: 'Blinds - Living Room', state: 'openPercent', is_: 100),
      ConditionType.temperatureSetting => const TemperatureSettingCondition(
          device: 'Thermostat - Living Room', state: 'thermostatMode', is_: ThermostatMode.heat),
      ConditionType.armDisarm => const ArmDisarmCondition(
          device: 'Home Security System', state: 'isArmed', is_: true),
      ConditionType.dock =>
        const DockCondition(device: 'Robot Vacuum - Living Room', state: 'isDocked', is_: true),
      ConditionType.startStop =>
        const StartStopCondition(device: 'Washer - Laundry Room', state: 'isRunning', is_: true),
      ConditionType.fanSpeed => const FanSpeedCondition(
          device: 'Ceiling Fan - Living Room',
          state: 'currentFanSpeedSetting',
          is_: 'medium'),
      ConditionType.humiditySetting => const HumiditySettingCondition(
          device: 'Humidifier - Bedroom', state: 'humiditySetpointPercent', is_: 50),
      ConditionType.fill =>
        const FillCondition(device: 'Bathtub - Bathroom', state: 'isFilled', is_: true),
      ConditionType.energyStorage => const EnergyStorageCondition(
          device: 'Robot Vacuum - Living Room', state: 'isCharging', is_: true),
      ConditionType.motionDetection =>
        const MotionDetectionCondition(device: 'Sensor - Hallway', state: 'motionDetectionEventInProgress', is_: true),
      ConditionType.occupancySensing =>
        const OccupancySensingCondition(device: 'Sensor - Office', state: 'occupancy', is_: OccupancyState.occupied),
      ConditionType.online =>
        const OnlineCondition(device: 'Smart Plug - Office', state: 'online', is_: true),
      ConditionType.timer => const TimerCondition(
          device: 'Washer - Laundry Room', state: 'timerPaused', is_: false),
      ConditionType.mediaState => const MediaStateCondition(
          device: 'Chromecast - Living Room', state: 'playbackState', is_: PlaybackState.playing),
      ConditionType.sensorState => const SensorStateCondition(
          device: 'Smoke Detector - Kitchen', state: 'smokeDetected', is_: false),
      ConditionType.deviceState => const DeviceStateCondition(
          device: 'Light - Living Room', state: 'on', is_: true),
    };
  }
}
