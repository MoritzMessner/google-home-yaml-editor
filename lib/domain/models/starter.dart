import 'condition.dart';

/// Starter models for Google Home automations
/// Based on https://developers.home.google.com/automations/starters-conditions-and-actions

// ============================================================================
// Starters
// ============================================================================

sealed class Starter {
  const Starter();
}

// --- Assistant Events ---

/// OK Google voice command starter
/// https://developers.home.google.com/automations/schema/reference/entity/assistant/ok_google_event
/// Last checked: 2024-12-21
class OkGoogleStarter extends Starter {
  const OkGoogleStarter({
    this.eventData = '',
    this.is_,
  });
  final String eventData; // query
  final String? is_;
}

// --- Time Events ---

/// Time schedule starter - triggers at specific times
/// https://developers.home.google.com/automations/schema/reference/standard/time_schedule_event
/// Last checked: 2024-12-21
class TimeScheduleStarter extends Starter {
  const TimeScheduleStarter({
    required this.at,
    this.weekdays,
  });
  final String at; // e.g., "6:00 pm", "sunrise", "sunset"
  final List<Weekday>? weekdays; // Array specifying applicable weekdays
}

// --- Home State ---

/// Home presence change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_structure/home_presence_state
/// Last checked: 2024-12-21
class HomePresenceStarter extends Starter {
  const HomePresenceStarter({
    required this.state,
    this.is_,
  });
  final String state; // homePresenceMode
  final HomePresenceMode? is_; // HOME, AWAY
}

// --- Device Events ---

/// Doorbell press event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/doorbell_press_event
/// Last checked: 2024-12-21
class DoorbellPressStarter extends Starter {
  const DoorbellPressStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Motion detection event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/motion_detection_event
/// Last checked: 2024-12-21
class MotionDetectionEventStarter extends Starter {
  const MotionDetectionEventStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Person detection event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/person_detection_event
/// Last checked: 2024-12-21
class PersonDetectionStarter extends Starter {
  const PersonDetectionStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Familiar face detection event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/face_familiar_detection_event
/// Last checked: 2024-12-21
class FaceFamiliarDetectionStarter extends Starter {
  const FaceFamiliarDetectionStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Unfamiliar face detection event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/face_unfamiliar_detection_event
/// Last checked: 2024-12-21
class FaceUnfamiliarDetectionStarter extends Starter {
  const FaceUnfamiliarDetectionStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Animal/pet detection event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/animal_other_detection_event
/// Last checked: 2024-12-21
class AnimalDetectionStarter extends Starter {
  const AnimalDetectionStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Moving vehicle detection event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/moving_vehicle_detection_event
/// Last checked: 2024-12-21
class MovingVehicleDetectionStarter extends Starter {
  const MovingVehicleDetectionStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Package delivered event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/package_delivered_event
/// Last checked: 2024-12-21
class PackageDeliveredStarter extends Starter {
  const PackageDeliveredStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Person talking event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/person_talking_event
/// Last checked: 2024-12-21
class PersonTalkingStarter extends Starter {
  const PersonTalkingStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

/// Sound detection event
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/sound_event
/// Last checked: 2024-12-21
class SoundEventStarter extends Starter {
  const SoundEventStarter({
    required this.device,
    this.eventData,
    this.is_,
  });
  final String device;
  final String? eventData;
  final dynamic is_;
}

// --- Device State Change Starters ---

/// Generic device state change starter (no specific link - used for various device.state.* types)
/// Last checked: 2024-12-21
class DeviceStateStarter extends Starter {
  const DeviceStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state;
  final dynamic is_;
}

/// On/Off state change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/on_off_state
/// Last checked: 2024-12-21
class OnOffStateStarter extends Starter {
  const OnOffStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // on
  final bool? is_;
}

/// Brightness state change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/brightness_state
/// Last checked: 2024-12-21
class BrightnessStateStarter extends Starter {
  const BrightnessStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // brightness
  final int? is_;
}

/// Lock/Unlock state change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/lock_unlock_state
/// Last checked: 2024-12-21
class LockUnlockStateStarter extends Starter {
  const LockUnlockStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // isLocked
  final bool? is_;
}

/// Open/Close state change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/open_close_state
/// Last checked: 2024-12-21
class OpenCloseStateStarter extends Starter {
  const OpenCloseStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // openPercent
  final int? is_;
}

/// Temperature setting change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/temperature_setting_state
/// Last checked: 2024-12-21
class TemperatureSettingStarter extends Starter {
  const TemperatureSettingStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // thermostatMode, thermostatTemperatureSetpoint, etc.
  final dynamic is_;
}

/// Motion detection state starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/motion_detection_state
/// Last checked: 2024-12-21
class MotionDetectionStateStarter extends Starter {
  const MotionDetectionStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // motionDetectionEventInProgress
  final bool? is_;
}

/// Occupancy state change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/occupancy_sensing_state
/// Last checked: 2024-12-21
class OccupancyStateStarter extends Starter {
  const OccupancyStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // occupancy
  final String? is_; // OCCUPIED, UNOCCUPIED
}

/// Energy storage state change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/energy_storage_state
/// Last checked: 2024-12-21
class EnergyStorageStateStarter extends Starter {
  const EnergyStorageStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // isCharging, isPluggedIn, descriptiveCapacityRemaining
  final dynamic is_;
}

/// Timer state change starter
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_state
/// Last checked: 2024-12-21
class TimerStateStarter extends Starter {
  const TimerStateStarter({
    required this.device,
    required this.state,
    this.is_,
  });
  final String device;
  final String state; // timerPaused
  final dynamic is_;
}

// ============================================================================
// Starter Type Enum for UI
// ============================================================================

enum StarterType {
  // Assistant
  /// https://developers.home.google.com/automations/schema/reference/entity/assistant/ok_google_event
  okGoogle('OK Google Command', 'assistant.event.OkGoogle'),

  // Time
  /// https://developers.home.google.com/automations/schema/reference/standard/time_schedule_event
  timeSchedule('Scheduled Time', 'time.schedule'),

  // Home
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_structure/home_presence_state
  homePresence('Home Presence', 'home.state.HomePresence'),

  // Device Events
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/doorbell_press_event
  doorbellPress('Doorbell Press', 'device.event.DoorbellPress'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/motion_detection_event
  motionDetectionEvent(
      'Motion Detected (Event)', 'device.event.MotionDetection'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/person_detection_event
  personDetection('Person Detected', 'device.event.PersonDetection'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/face_familiar_detection_event
  faceFamiliarDetection('Familiar Face', 'device.event.FaceFamiliarDetection'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/face_unfamiliar_detection_event
  faceUnfamiliarDetection(
      'Unfamiliar Face', 'device.event.FaceUnfamiliarDetection'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/animal_other_detection_event
  animalDetection('Animal Detected', 'device.event.AnimalOtherDetection'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/moving_vehicle_detection_event
  movingVehicleDetection(
      'Vehicle Detected', 'device.event.MovingVehicleDetection'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/package_delivered_event
  packageDelivered('Package Delivered', 'device.event.PackageDelivered'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/person_talking_event
  personTalking('Person Talking', 'device.event.PersonTalking'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/sound_event
  soundEvent('Sound Detected', 'device.event.Sound'),

  // Device State Changes
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/on_off_state
  onOffState('On/Off State Change', 'device.state.OnOff'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/brightness_state
  brightnessState('Brightness Change', 'device.state.Brightness'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/lock_unlock_state
  lockUnlockState('Lock State Change', 'device.state.LockUnlock'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/open_close_state
  openCloseState('Open/Close Change', 'device.state.OpenClose'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/temperature_setting_state
  temperatureSettingState(
      'Temperature Change', 'device.state.TemperatureSetting'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/motion_detection_state
  motionDetectionState('Motion State Change', 'device.state.MotionDetection'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/occupancy_sensing_state
  occupancyState('Occupancy Change', 'device.state.OccupancySensing'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/energy_storage_state
  energyStorageState('Energy/Battery Change', 'device.state.EnergyStorage'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_state
  timerState('Timer State Change', 'device.state.Timer'),

  /// Generic device state (no specific link - used for various device.state.* types)
  deviceState('Device State (Generic)', 'device.state');

  const StarterType(this.displayName, this.yamlType);

  final String displayName;
  final String yamlType;

  static StarterType fromStarter(Starter starter) {
    return switch (starter) {
      OkGoogleStarter() => StarterType.okGoogle,
      TimeScheduleStarter() => StarterType.timeSchedule,
      HomePresenceStarter() => StarterType.homePresence,
      DoorbellPressStarter() => StarterType.doorbellPress,
      MotionDetectionEventStarter() => StarterType.motionDetectionEvent,
      PersonDetectionStarter() => StarterType.personDetection,
      FaceFamiliarDetectionStarter() => StarterType.faceFamiliarDetection,
      FaceUnfamiliarDetectionStarter() => StarterType.faceUnfamiliarDetection,
      AnimalDetectionStarter() => StarterType.animalDetection,
      MovingVehicleDetectionStarter() => StarterType.movingVehicleDetection,
      PackageDeliveredStarter() => StarterType.packageDelivered,
      PersonTalkingStarter() => StarterType.personTalking,
      SoundEventStarter() => StarterType.soundEvent,
      OnOffStateStarter() => StarterType.onOffState,
      BrightnessStateStarter() => StarterType.brightnessState,
      LockUnlockStateStarter() => StarterType.lockUnlockState,
      OpenCloseStateStarter() => StarterType.openCloseState,
      TemperatureSettingStarter() => StarterType.temperatureSettingState,
      MotionDetectionStateStarter() => StarterType.motionDetectionState,
      OccupancyStateStarter() => StarterType.occupancyState,
      EnergyStorageStateStarter() => StarterType.energyStorageState,
      TimerStateStarter() => StarterType.timerState,
      DeviceStateStarter() => StarterType.deviceState,
    };
  }

  /// Create a default starter for this type with realistic examples from docs
  Starter createDefault() {
    return switch (this) {
      StarterType.okGoogle =>
        const OkGoogleStarter(eventData: '', is_: 'Movie Night'),
      StarterType.timeSchedule => const TimeScheduleStarter(at: 'sunset'),
      StarterType.homePresence => const HomePresenceStarter(
          state: 'homePresenceMode', is_: HomePresenceMode.away),
      StarterType.doorbellPress =>
        const DoorbellPressStarter(device: 'Doorbell - Front'),
      StarterType.motionDetectionEvent =>
        const MotionDetectionEventStarter(device: 'Camera - Living Room'),
      StarterType.personDetection =>
        const PersonDetectionStarter(device: 'Camera - Living Room'),
      StarterType.faceFamiliarDetection =>
        const FaceFamiliarDetectionStarter(device: 'Camera - Front Door'),
      StarterType.faceUnfamiliarDetection =>
        const FaceUnfamiliarDetectionStarter(device: 'Camera - Front Door'),
      StarterType.animalDetection =>
        const AnimalDetectionStarter(device: 'Camera - Backyard'),
      StarterType.movingVehicleDetection =>
        const MovingVehicleDetectionStarter(device: 'Camera - Driveway'),
      StarterType.packageDelivered =>
        const PackageDeliveredStarter(device: 'Camera - Front Door'),
      StarterType.personTalking =>
        const PersonTalkingStarter(device: 'Camera - Front Door'),
      StarterType.soundEvent =>
        const SoundEventStarter(device: 'Nest Hub - Living Room'),
      StarterType.onOffState => const OnOffStateStarter(
          device: 'Light - Living Room', state: 'on', is_: true),
      StarterType.brightnessState => const BrightnessStateStarter(
          device: 'Light - Living Room', state: 'brightness', is_: 50),
      StarterType.lockUnlockState => const LockUnlockStateStarter(
          device: 'Front Door Lock', state: 'isLocked', is_: false),
      StarterType.openCloseState => const OpenCloseStateStarter(
          device: 'Entrance Door - Entryway', state: 'openPercent', is_: 100),
      StarterType.temperatureSettingState => const TemperatureSettingStarter(
          device: 'Thermostat - Living Room',
          state: 'thermostatMode',
          is_: 'heat'),
      StarterType.motionDetectionState => const MotionDetectionStateStarter(
          device: 'Sensor - Hallway',
          state: 'motionDetectionEventInProgress',
          is_: true),
      StarterType.occupancyState => const OccupancyStateStarter(
          device: 'Sensor - Office', state: 'occupancy', is_: 'OCCUPIED'),
      StarterType.energyStorageState => const EnergyStorageStateStarter(
          device: 'Robot Vacuum - Living Room', state: 'isCharging', is_: true),
      StarterType.timerState => const TimerStateStarter(
          device: 'Washer - Laundry Room', state: 'timerPaused', is_: false),
      StarterType.deviceState => const DeviceStateStarter(
          device: 'Device',
          state: 'on',
          is_: true,
        ),
    };
  }
}
