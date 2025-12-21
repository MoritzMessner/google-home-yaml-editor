/// Action models for Google Home automations
/// Based on https://developers.home.google.com/automations/starters-conditions-and-actions

// ============================================================================
// Actions - Base class
// ============================================================================

sealed class AutomationAction {
  const AutomationAction();
}

// ============================================================================
// Time Actions
// ============================================================================

/// Delay action - adds a pause in automation execution
/// https://developers.home.google.com/automations/schema/reference/standard/delay_action
/// Last checked: 2024-12-19
class DelayAction extends AutomationAction {
  const DelayAction({required this.duration});
  final String
      duration; // Duration format: 30min, 1hour, 20sec, 1hour10min20sec
}

// ============================================================================
// Assistant Actions
// ============================================================================

/// Broadcast a message to Google Home devices
/// https://developers.home.google.com/automations/schema/reference/entity/assistant/broadcast_command
/// Last checked: 2024-12-19
class BroadcastAction extends AutomationAction {
  const BroadcastAction({required this.message});
  final String message;
}

/// Execute an OK Google voice command
/// https://developers.home.google.com/automations/schema/reference/entity/assistant/ok_google_command
/// Last checked: 2024-12-19
class AssistantCommandAction extends AutomationAction {
  const AssistantCommandAction({required this.command});
  final String command;
}

// ============================================================================
// Device Command Actions
// ============================================================================

/// Turn devices on or off
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/on_off_command
/// Last checked: 2024-12-19
class OnOffAction extends AutomationAction {
  const OnOffAction({
    required this.devices,
    required this.on,
  });
  final List<String> devices;
  final bool on;
}

/// Activate or deactivate a scene
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/activate_scene_command
/// Last checked: 2024-12-19
class ActivateSceneAction extends AutomationAction {
  const ActivateSceneAction({
    required this.scene,
    required this.activate,
  });
  final String scene;
  final bool activate;
}

/// Set absolute brightness
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/brightness_absolute_command
/// Last checked: 2024-12-19
class BrightnessAbsoluteAction extends AutomationAction {
  const BrightnessAbsoluteAction({
    required this.devices,
    required this.brightness,
  });
  final List<String> devices;
  final int brightness; // Brightness level as a percentage (0-100)
}

/// Set relative brightness
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/brightness_relative_command
/// Last checked: 2024-12-19
class BrightnessRelativeAction extends AutomationAction {
  const BrightnessRelativeAction({
    required this.devices,
    this.brightnessRelativePercent,
    this.brightnessRelativeWeight,
  });
  final List<String> devices;
  final int? brightnessRelativePercent;
  final int? brightnessRelativeWeight;
}

/// Set color (HSV, RGB, temperature, or named)
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/color_absolute_command
/// Last checked: 2024-12-19
class ColorAbsoluteAction extends AutomationAction {
  const ColorAbsoluteAction({
    required this.devices,
    this.spectrumRGB,
    this.temperature,
  });
  final List<String> devices;
  final int? spectrumRGB; // Color in RGB format (hex without #)
  final int? temperature; // Color temperature in Kelvin
}

/// Set volume level
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_volume_command
/// Last checked: 2024-12-19
class SetVolumeAction extends AutomationAction {
  const SetVolumeAction({
    required this.devices,
    required this.volumeLevel,
  });
  final List<String> devices;
  final int volumeLevel;
}

/// Mute or unmute devices
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/mute_command
/// Last checked: 2024-12-19
class MuteAction extends AutomationAction {
  const MuteAction({
    required this.devices,
    required this.mute,
  });
  final List<String> devices;
  final bool mute;
}

/// Media control: next track
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_next_command
/// Last checked: 2024-12-19
class MediaNextAction extends AutomationAction {
  const MediaNextAction({required this.devices});
  final List<String> devices;
}

/// Media control: previous track
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_previous_command
/// Last checked: 2024-12-19
class MediaPreviousAction extends AutomationAction {
  const MediaPreviousAction({required this.devices});
  final List<String> devices;
}

/// Media control: pause
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_pause_command
/// Last checked: 2024-12-19
class MediaPauseAction extends AutomationAction {
  const MediaPauseAction({required this.devices});
  final List<String> devices;
}

/// Media control: resume
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_resume_command
/// Last checked: 2024-12-19
class MediaResumeAction extends AutomationAction {
  const MediaResumeAction({required this.devices});
  final List<String> devices;
}

/// Media control: stop
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_stop_command
/// Last checked: 2024-12-19
class MediaStopAction extends AutomationAction {
  const MediaStopAction({required this.devices});
  final List<String> devices;
}

/// Media control: shuffle
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_shuffle_command
/// Last checked: 2024-12-19
class MediaShuffleAction extends AutomationAction {
  const MediaShuffleAction({required this.devices});
  final List<String> devices;
}

/// Lock or unlock devices
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/lock_unlock_command
/// Last checked: 2024-12-19
class LockUnlockAction extends AutomationAction {
  const LockUnlockAction({
    required this.devices,
    required this.lock,
  });
  final List<String> devices;
  final bool lock;
}

/// Open or close devices (blinds, garage doors, etc.)
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/open_close_command
/// Last checked: 2024-12-19
class OpenCloseAction extends AutomationAction {
  const OpenCloseAction({
    required this.devices,
    this.openPercent,
    this.openDirection,
  });
  final List<String> devices;
  final int? openPercent; // 0 = fully closed, 100 = fully open
  final String?
      openDirection; // Optional, for devices supporting multiple directions
}

/// Arm or disarm security devices
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/arm_disarm_command
/// Last checked: 2024-12-19
class ArmDisarmAction extends AutomationAction {
  const ArmDisarmAction({
    required this.devices,
    required this.arm,
    this.armLevel,
    this.cancel,
  });
  final List<String> devices;
  final bool arm;
  final String? armLevel; // Cannot be used with cancel
  final bool? cancel; // Cannot be used with armLevel
}

/// Set thermostat mode
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/thermostat_set_mode_command
/// Last checked: 2024-12-19
class ThermostatSetModeAction extends AutomationAction {
  const ThermostatSetModeAction({
    required this.devices,
    required this.thermostatMode,
  });
  final List<String> devices;
  final String thermostatMode; // Available values depend on device
}

/// Set thermostat temperature setpoint
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/thermostat_temperature_setpoint_command
/// Last checked: 2024-12-19
class ThermostatTemperatureSetpointAction extends AutomationAction {
  const ThermostatTemperatureSetpointAction({
    required this.devices,
    required this.thermostatTemperatureSetpoint,
  });
  final List<String> devices;
  final double thermostatTemperatureSetpoint; // Temperature value
}

/// Set thermostat temperature range
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/thermostat_temperature_set_range_command
/// Last checked: 2024-12-19
class ThermostatTemperatureSetRangeAction extends AutomationAction {
  const ThermostatTemperatureSetRangeAction({
    required this.devices,
    required this.thermostatTemperatureSetpointHigh,
    required this.thermostatTemperatureSetpointLow,
  });
  final List<String> devices;
  final double thermostatTemperatureSetpointHigh;
  final double thermostatTemperatureSetpointLow;
}

/// Set fan speed
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_fan_speed_command
/// Last checked: 2024-12-19
class SetFanSpeedAction extends AutomationAction {
  const SetFanSpeedAction({
    required this.devices,
    required this.fanSpeed,
  });
  final List<String> devices;
  final String fanSpeed;
}

/// Set relative fan speed
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_fan_speed_relative_command
/// Last checked: 2024-12-19
class SetFanSpeedRelativeAction extends AutomationAction {
  const SetFanSpeedRelativeAction({
    required this.devices,
    this.fanSpeedRelativePercent,
    this.fanSpeedRelativeWeight,
  });
  final List<String> devices;
  final int? fanSpeedRelativePercent;
  final int? fanSpeedRelativeWeight;
}

/// Reverse fan direction
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/reverse_fan_command
/// Last checked: 2024-12-19
class ReverseFanAction extends AutomationAction {
  const ReverseFanAction({required this.devices});
  final List<String> devices;
}

/// Set humidity level
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_humidity_command
/// Last checked: 2024-12-19
class SetHumidityAction extends AutomationAction {
  const SetHumidityAction({
    required this.devices,
    required this.humidity,
  });
  final List<String> devices;
  final int humidity;
}

/// Set relative humidity
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/humidity_relative_command
/// Last checked: 2024-12-19
class HumidityRelativeAction extends AutomationAction {
  const HumidityRelativeAction({
    required this.devices,
    this.relativeHumidityPercent,
    this.relativeHumidityWeight,
  });
  final List<String> devices;
  final int? relativeHumidityPercent;
  final int? relativeHumidityWeight;
}

/// Start or stop devices
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/start_stop_command
/// Last checked: 2024-12-19
class StartStopAction extends AutomationAction {
  const StartStopAction({
    required this.devices,
    required this.start,
  });
  final List<String> devices;
  final bool start;
}

/// Pause or unpause device operation
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/pause_unpause_command
/// Last checked: 2024-12-19
class PauseUnpauseAction extends AutomationAction {
  const PauseUnpauseAction({
    required this.devices,
    required this.pause,
  });
  final List<String> devices;
  final bool pause;
}

/// Dock device (robot vacuum, etc.)
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/dock_command
/// Last checked: 2024-12-19
class DockAction extends AutomationAction {
  const DockAction({required this.devices});
  final List<String> devices;
}

/// Start or stop charging
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/charge_command
/// Last checked: 2024-12-19
class ChargeAction extends AutomationAction {
  const ChargeAction({
    required this.devices,
    required this.charge,
  });
  final List<String> devices;
  final bool charge;
}

/// Reboot device
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/reboot_command
/// Last checked: 2024-12-19
class RebootAction extends AutomationAction {
  const RebootAction({required this.devices});
  final List<String> devices;
}

/// Fill or drain device
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/fill_command
/// Last checked: 2024-12-19
class FillAction extends AutomationAction {
  const FillAction({
    required this.devices,
    required this.fill,
    this.fillLevel,
  });
  final List<String> devices;
  final bool fill;
  final String? fillLevel;
}

/// Find my device (locate by alert)
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/find_my_device_command
/// Last checked: 2024-12-19
class FindMyDeviceAction extends AutomationAction {
  const FindMyDeviceAction({
    required this.devices,
    this.silence,
  });
  final List<String> devices;
  final bool? silence;
}

/// Set media input
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_input_command
/// Last checked: 2024-12-19
class SetInputAction extends AutomationAction {
  const SetInputAction({
    required this.devices,
    required this.newInput,
  });
  final List<String> devices;
  final String newInput;
}

/// Switch to next input
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/next_input_command
/// Last checked: 2024-12-19
class NextInputAction extends AutomationAction {
  const NextInputAction({required this.devices});
  final List<String> devices;
}

/// Switch to previous input
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/previous_input_command
/// Last checked: 2024-12-19
class PreviousInputAction extends AutomationAction {
  const PreviousInputAction({required this.devices});
  final List<String> devices;
}

/// Select channel
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/select_channel_command
/// Last checked: 2024-12-19
class SelectChannelAction extends AutomationAction {
  const SelectChannelAction({
    required this.devices,
    this.channelCode,
    this.channelName,
    this.channelNumber,
  });
  final List<String> devices;
  final String? channelCode;
  final String? channelName;
  final String? channelNumber;
}

/// Relative channel adjustment
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/relative_channel_command
/// Last checked: 2024-12-19
class RelativeChannelAction extends AutomationAction {
  const RelativeChannelAction({
    required this.devices,
    required this.channelCount,
  });
  final List<String> devices;
  final int channelCount;
}

/// Return to previous channel
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/return_channel_command
/// Last checked: 2024-12-19
class ReturnChannelAction extends AutomationAction {
  const ReturnChannelAction({required this.devices});
  final List<String> devices;
}

/// Rotate device to absolute position
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/rotate_absolute_command
/// Last checked: 2024-12-19
class RotateAbsoluteAction extends AutomationAction {
  const RotateAbsoluteAction({
    required this.devices,
    this.rotationDegree,
    this.rotationPercent,
  });
  final List<String> devices;
  final double? rotationDegree;
  final double? rotationPercent;
}

/// Start a timer
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_start_command
/// Last checked: 2024-12-19
class TimerStartAction extends AutomationAction {
  const TimerStartAction({
    required this.devices,
    required this.duration,
  });
  final List<String> devices;
  final String
      duration; // Duration format: 30min, 1hour, 20sec, 1hour10min20sec
}

/// Adjust timer duration
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_adjust_command
/// Last checked: 2024-12-19
class TimerAdjustAction extends AutomationAction {
  const TimerAdjustAction({
    required this.devices,
    required this.duration,
  });
  final List<String> devices;
  final String
      duration; // Duration format: 30min, 1hour, 20sec, 1hour10min20sec
}

/// Pause timer
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_pause_command
/// Last checked: 2024-12-19
class TimerPauseAction extends AutomationAction {
  const TimerPauseAction({required this.devices});
  final List<String> devices;
}

/// Resume timer
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_resume_command
/// Last checked: 2024-12-19
class TimerResumeAction extends AutomationAction {
  const TimerResumeAction({required this.devices});
  final List<String> devices;
}

/// Cancel timer
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_cancel_command
/// Last checked: 2024-12-19
class TimerCancelAction extends AutomationAction {
  const TimerCancelAction({required this.devices});
  final List<String> devices;
}

/// Light effect: color loop
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/light_effect_color_loop_command
/// Last checked: 2024-12-19
class LightEffectColorLoopAction extends AutomationAction {
  const LightEffectColorLoopAction({
    required this.devices,
    this.duration,
  });
  final List<String> devices;
  final String?
      duration; // Duration format: 30min, 1hour, 20sec, 1hour10min20sec
}

/// Light effect: pulse
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/light_effect_pulse_command
/// Last checked: 2024-12-19
class LightEffectPulseAction extends AutomationAction {
  const LightEffectPulseAction({
    required this.devices,
    this.duration,
  });
  final List<String> devices;
  final String?
      duration; // Duration format: 30min, 1hour, 20sec, 1hour10min20sec
}

/// Light effect: sleep (gradual dim)
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/light_effect_sleep_command
/// Last checked: 2024-12-19
class LightEffectSleepAction extends AutomationAction {
  const LightEffectSleepAction({
    required this.devices,
    this.duration,
  });
  final List<String> devices;
  final String?
      duration; // Duration format: 30min, 1hour, 20sec, 1hour10min20sec
}

/// Light effect: wake (gradual brighten)
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/light_effect_wake_command
/// Last checked: 2024-12-19
class LightEffectWakeAction extends AutomationAction {
  const LightEffectWakeAction({
    required this.devices,
    this.duration,
  });
  final List<String> devices;
  final String?
      duration; // Duration format: 30min, 1hour, 20sec, 1hour10min20sec
}

/// Stop light effect
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/stop_light_effect_command
/// Last checked: 2024-12-19
class StopLightEffectAction extends AutomationAction {
  const StopLightEffectAction({required this.devices});
  final List<String> devices;
}

/// Select application
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/app_select_command
/// Last checked: 2024-12-19
class AppSelectAction extends AutomationAction {
  const AppSelectAction({
    required this.devices,
    required this.applicationName,
  });
  final List<String> devices;
  final String applicationName;
}

/// Install application
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/app_install_command
/// Last checked: 2024-12-19
class AppInstallAction extends AutomationAction {
  const AppInstallAction({
    required this.devices,
    required this.newApplicationName,
  });
  final List<String> devices;
  final String newApplicationName;
}

/// Search for application
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/app_search_command
/// Last checked: 2024-12-19
class AppSearchAction extends AutomationAction {
  const AppSearchAction({
    required this.devices,
    required this.applicationName,
  });
  final List<String> devices;
  final String applicationName;
}

/// Start or stop cooking
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/cook_command
/// Last checked: 2024-12-19
class CookAction extends AutomationAction {
  const CookAction({
    required this.devices,
    required this.start,
    this.cookingMode,
    this.foodPreset,
    this.quantity,
    this.unit,
  });
  final List<String> devices;
  final bool start;
  final String? cookingMode;
  final String? foodPreset;
  final int? quantity;
  final String? unit;
}

/// Dispense items
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/dispense_command
/// Last checked: 2024-12-19
class DispenseAction extends AutomationAction {
  const DispenseAction({
    required this.devices,
    this.amount,
    this.item,
    this.presetName,
    this.unit,
  });
  final List<String> devices;
  final int? amount;
  final String? item;
  final String? presetName;
  final String? unit;
}

/// Enable/disable guest network
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/enable_disable_guest_network_command
/// Last checked: 2024-12-19
class EnableDisableGuestNetworkAction extends AutomationAction {
  const EnableDisableGuestNetworkAction({
    required this.devices,
    required this.enable,
  });
  final List<String> devices;
  final bool enable;
}

/// Enable/disable network profile
/// https://developers.home.google.com/automations/schema/reference/entity/sht_device/enable_disable_network_profile_command
/// Last checked: 2024-12-19
class EnableDisableNetworkProfileAction extends AutomationAction {
  const EnableDisableNetworkProfileAction({
    required this.devices,
    required this.enable,
    required this.profile,
  });
  final List<String> devices;
  final bool enable;
  final String profile;
}

// ============================================================================
// Action Type Enum for UI
// ============================================================================

enum ActionType {
  // Time
  /// https://developers.home.google.com/automations/schema/reference/standard/delay_action
  delay('Delay', 'time.delay'),

  // Assistant
  /// https://developers.home.google.com/automations/schema/reference/entity/assistant/broadcast_command
  broadcast('Broadcast', 'assistant.command.Broadcast'),

  /// https://developers.home.google.com/automations/schema/reference/entity/assistant/ok_google_command
  assistantCommand('OK Google Command', 'assistant.command.OkGoogle'),

  // Device - Basic
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/on_off_command
  onOff('On/Off', 'device.command.OnOff'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/activate_scene_command
  activateScene('Activate Scene', 'device.command.ActivateScene'),

  // Device - Brightness & Color
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/brightness_absolute_command
  brightnessAbsolute('Set Brightness', 'device.command.BrightnessAbsolute'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/brightness_relative_command
  brightnessRelative('Adjust Brightness', 'device.command.BrightnessRelative'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/color_absolute_command
  colorAbsolute('Set Color', 'device.command.ColorAbsolute'),

  // Device - Volume & Media
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_volume_command
  setVolume('Set Volume', 'device.command.SetVolume'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/mute_command
  mute('Mute', 'device.command.Mute'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_next_command
  mediaNext('Media Next', 'device.command.MediaNext'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_previous_command
  mediaPrevious('Media Previous', 'device.command.MediaPrevious'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_pause_command
  mediaPause('Media Pause', 'device.command.MediaPause'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_resume_command
  mediaResume('Media Resume', 'device.command.MediaResume'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_stop_command
  mediaStop('Media Stop', 'device.command.MediaStop'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/media_shuffle_command
  mediaShuffle('Media Shuffle', 'device.command.MediaShuffle'),

  // Device - Security
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/lock_unlock_command
  lockUnlock('Lock/Unlock', 'device.command.LockUnlock'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/arm_disarm_command
  armDisarm('Arm/Disarm', 'device.command.ArmDisarm'),

  // Device - Open/Close
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/open_close_command
  openClose('Open/Close', 'device.command.OpenClose'),

  // Device - Thermostat
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/thermostat_set_mode_command
  thermostatSetMode('Thermostat Mode', 'device.command.ThermostatSetMode'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/thermostat_temperature_setpoint_command
  thermostatTemperatureSetpoint(
      'Thermostat Temperature', 'device.command.ThermostatTemperatureSetpoint'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/thermostat_temperature_set_range_command
  thermostatTemperatureSetRange(
      'Thermostat Range', 'device.command.ThermostatTemperatureSetRange'),

  // Device - Fan
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_fan_speed_command
  setFanSpeed('Set Fan Speed', 'device.command.SetFanSpeed'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_fan_speed_relative_command
  setFanSpeedRelative('Adjust Fan Speed', 'device.command.SetFanSpeedRelative'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/reverse_fan_command
  reverseFan('Reverse Fan', 'device.command.ReverseFan'),

  // Device - Humidity
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_humidity_command
  setHumidity('Set Humidity', 'device.command.SetHumidity'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/humidity_relative_command
  humidityRelative('Adjust Humidity', 'device.command.HumidityRelative'),

  // Device - Operation
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/start_stop_command
  startStop('Start/Stop', 'device.command.StartStop'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/pause_unpause_command
  pauseUnpause('Pause/Unpause', 'device.command.PauseUnpause'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/dock_command
  dock('Dock', 'device.command.Dock'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/charge_command
  charge('Charge', 'device.command.Charge'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/reboot_command
  reboot('Reboot', 'device.command.Reboot'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/fill_command
  fill('Fill', 'device.command.Fill'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/find_my_device_command
  findMyDevice('Find My Device', 'device.command.FindMyDevice'),

  // Device - Input
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/set_input_command
  setInput('Set Input', 'device.command.SetInput'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/next_input_command
  nextInput('Next Input', 'device.command.NextInput'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/previous_input_command
  previousInput('Previous Input', 'device.command.PreviousInput'),

  // Device - Channel
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/select_channel_command
  selectChannel('Select Channel', 'device.command.SelectChannel'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/relative_channel_command
  relativeChannel('Relative Channel', 'device.command.RelativeChannel'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/return_channel_command
  returnChannel('Return Channel', 'device.command.ReturnChannel'),

  // Device - Rotation
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/rotate_absolute_command
  rotateAbsolute('Rotate', 'device.command.RotateAbsolute'),

  // Device - Timer
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_start_command
  timerStart('Start Timer', 'device.command.TimerStart'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_adjust_command
  timerAdjust('Adjust Timer', 'device.command.TimerAdjust'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_pause_command
  timerPause('Pause Timer', 'device.command.TimerPause'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_resume_command
  timerResume('Resume Timer', 'device.command.TimerResume'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/timer_cancel_command
  timerCancel('Cancel Timer', 'device.command.TimerCancel'),

  // Device - Light Effects
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/light_effect_color_loop_command
  lightEffectColorLoop('Color Loop', 'device.command.LightEffectColorLoop'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/light_effect_pulse_command
  lightEffectPulse('Pulse', 'device.command.LightEffectPulse'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/light_effect_sleep_command
  lightEffectSleep('Sleep Effect', 'device.command.LightEffectSleep'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/light_effect_wake_command
  lightEffectWake('Wake Effect', 'device.command.LightEffectWake'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/stop_light_effect_command
  stopLightEffect('Stop Light Effect', 'device.command.StopLightEffect'),

  // Device - App
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/app_select_command
  appSelect('Select App', 'device.command.AppSelect'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/app_install_command
  appInstall('Install App', 'device.command.AppInstall'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/app_search_command
  appSearch('Search App', 'device.command.AppSearch'),

  // Device - Cooking
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/cook_command
  cook('Cook', 'device.command.Cook'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/dispense_command
  dispense('Dispense', 'device.command.Dispense'),

  // Device - Network
  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/enable_disable_guest_network_command
  enableDisableGuestNetwork(
      'Guest Network', 'device.command.EnableDisableGuestNetwork'),

  /// https://developers.home.google.com/automations/schema/reference/entity/sht_device/enable_disable_network_profile_command
  enableDisableNetworkProfile(
      'Network Profile', 'device.command.EnableDisableNetworkProfile');

  const ActionType(this.displayName, this.yamlType);

  final String displayName;
  final String yamlType;

  static ActionType fromAction(AutomationAction action) {
    return switch (action) {
      DelayAction() => ActionType.delay,
      BroadcastAction() => ActionType.broadcast,
      AssistantCommandAction() => ActionType.assistantCommand,
      OnOffAction() => ActionType.onOff,
      ActivateSceneAction() => ActionType.activateScene,
      BrightnessAbsoluteAction() => ActionType.brightnessAbsolute,
      BrightnessRelativeAction() => ActionType.brightnessRelative,
      ColorAbsoluteAction() => ActionType.colorAbsolute,
      SetVolumeAction() => ActionType.setVolume,
      MuteAction() => ActionType.mute,
      MediaNextAction() => ActionType.mediaNext,
      MediaPreviousAction() => ActionType.mediaPrevious,
      MediaPauseAction() => ActionType.mediaPause,
      MediaResumeAction() => ActionType.mediaResume,
      MediaStopAction() => ActionType.mediaStop,
      MediaShuffleAction() => ActionType.mediaShuffle,
      LockUnlockAction() => ActionType.lockUnlock,
      ArmDisarmAction() => ActionType.armDisarm,
      OpenCloseAction() => ActionType.openClose,
      ThermostatSetModeAction() => ActionType.thermostatSetMode,
      ThermostatTemperatureSetpointAction() =>
        ActionType.thermostatTemperatureSetpoint,
      ThermostatTemperatureSetRangeAction() =>
        ActionType.thermostatTemperatureSetRange,
      SetFanSpeedAction() => ActionType.setFanSpeed,
      SetFanSpeedRelativeAction() => ActionType.setFanSpeedRelative,
      ReverseFanAction() => ActionType.reverseFan,
      SetHumidityAction() => ActionType.setHumidity,
      HumidityRelativeAction() => ActionType.humidityRelative,
      StartStopAction() => ActionType.startStop,
      PauseUnpauseAction() => ActionType.pauseUnpause,
      DockAction() => ActionType.dock,
      ChargeAction() => ActionType.charge,
      RebootAction() => ActionType.reboot,
      FillAction() => ActionType.fill,
      FindMyDeviceAction() => ActionType.findMyDevice,
      SetInputAction() => ActionType.setInput,
      NextInputAction() => ActionType.nextInput,
      PreviousInputAction() => ActionType.previousInput,
      SelectChannelAction() => ActionType.selectChannel,
      RelativeChannelAction() => ActionType.relativeChannel,
      ReturnChannelAction() => ActionType.returnChannel,
      RotateAbsoluteAction() => ActionType.rotateAbsolute,
      TimerStartAction() => ActionType.timerStart,
      TimerAdjustAction() => ActionType.timerAdjust,
      TimerPauseAction() => ActionType.timerPause,
      TimerResumeAction() => ActionType.timerResume,
      TimerCancelAction() => ActionType.timerCancel,
      LightEffectColorLoopAction() => ActionType.lightEffectColorLoop,
      LightEffectPulseAction() => ActionType.lightEffectPulse,
      LightEffectSleepAction() => ActionType.lightEffectSleep,
      LightEffectWakeAction() => ActionType.lightEffectWake,
      StopLightEffectAction() => ActionType.stopLightEffect,
      AppSelectAction() => ActionType.appSelect,
      AppInstallAction() => ActionType.appInstall,
      AppSearchAction() => ActionType.appSearch,
      CookAction() => ActionType.cook,
      DispenseAction() => ActionType.dispense,
      EnableDisableGuestNetworkAction() => ActionType.enableDisableGuestNetwork,
      EnableDisableNetworkProfileAction() =>
        ActionType.enableDisableNetworkProfile,
    };
  }

  /// Create a default action for this type with realistic examples from docs
  AutomationAction createDefault() {
    return switch (this) {
      ActionType.delay => const DelayAction(duration: '5s'),
      ActionType.broadcast =>
        const BroadcastAction(message: 'Someone is at the door'),
      ActionType.assistantCommand =>
        const AssistantCommandAction(command: 'Play relaxing music'),
      ActionType.onOff =>
        const OnOffAction(devices: ['Light - Living Room'], on: true),
      ActionType.activateScene => const ActivateSceneAction(
          scene: 'Relaxation Scene - Living Room', activate: true),
      ActionType.brightnessAbsolute => const BrightnessAbsoluteAction(
          devices: ['Light - Living Room'], brightness: 50),
      ActionType.brightnessRelative => const BrightnessRelativeAction(
          devices: ['Light - Living Room'], brightnessRelativePercent: 10),
      ActionType.colorAbsolute => const ColorAbsoluteAction(
          devices: ['Light - Living Room'], temperature: 2700),
      ActionType.setVolume => const SetVolumeAction(
          devices: ['Speaker - Living Room'], volumeLevel: 30),
      ActionType.mute =>
        const MuteAction(devices: ['Speaker - Living Room'], mute: true),
      ActionType.mediaNext =>
        const MediaNextAction(devices: ['Chromecast - Living Room']),
      ActionType.mediaPrevious =>
        const MediaPreviousAction(devices: ['Chromecast - Living Room']),
      ActionType.mediaPause =>
        const MediaPauseAction(devices: ['Chromecast - Living Room']),
      ActionType.mediaResume =>
        const MediaResumeAction(devices: ['Chromecast - Living Room']),
      ActionType.mediaStop =>
        const MediaStopAction(devices: ['Chromecast - Living Room']),
      ActionType.mediaShuffle =>
        const MediaShuffleAction(devices: ['Chromecast - Living Room']),
      ActionType.lockUnlock =>
        const LockUnlockAction(devices: ['Front Door Lock'], lock: true),
      ActionType.armDisarm =>
        const ArmDisarmAction(devices: ['Home Security System'], arm: true),
      ActionType.openClose => const OpenCloseAction(
          devices: ['Blinds - Living Room'], openPercent: 0),
      ActionType.thermostatSetMode => const ThermostatSetModeAction(
          devices: ['Thermostat - Living Room'], thermostatMode: 'heat'),
      ActionType.thermostatTemperatureSetpoint =>
        const ThermostatTemperatureSetpointAction(
            devices: ['Thermostat - Living Room'],
            thermostatTemperatureSetpoint: 21.0),
      ActionType.thermostatTemperatureSetRange =>
        const ThermostatTemperatureSetRangeAction(
            devices: ['Thermostat - Living Room'],
            thermostatTemperatureSetpointHigh: 24.0,
            thermostatTemperatureSetpointLow: 18.0),
      ActionType.setFanSpeed => const SetFanSpeedAction(
          devices: ['Ceiling Fan - Living Room'], fanSpeed: 'medium'),
      ActionType.setFanSpeedRelative => const SetFanSpeedRelativeAction(
          devices: ['Ceiling Fan - Living Room'], fanSpeedRelativePercent: 10),
      ActionType.reverseFan =>
        const ReverseFanAction(devices: ['Ceiling Fan - Living Room']),
      ActionType.setHumidity => const SetHumidityAction(
          devices: ['Humidifier - Bedroom'], humidity: 50),
      ActionType.humidityRelative => const HumidityRelativeAction(
          devices: ['Humidifier - Bedroom'], relativeHumidityPercent: 10),
      ActionType.startStop => const StartStopAction(
          devices: ['Robot Vacuum - Living Room'], start: true),
      ActionType.pauseUnpause => const PauseUnpauseAction(
          devices: ['Washer - Laundry Room'], pause: true),
      ActionType.dock =>
        const DockAction(devices: ['Robot Vacuum - Living Room']),
      ActionType.charge => const ChargeAction(
          devices: ['Robot Vacuum - Living Room'], charge: true),
      ActionType.reboot => const RebootAction(devices: ['Router - Office']),
      ActionType.fill =>
        const FillAction(devices: ['Bathtub - Bathroom'], fill: true),
      ActionType.findMyDevice =>
        const FindMyDeviceAction(devices: ['Phone - John']),
      ActionType.setInput =>
        const SetInputAction(devices: ['TV - Living Room'], newInput: 'HDMI1'),
      ActionType.nextInput =>
        const NextInputAction(devices: ['TV - Living Room']),
      ActionType.previousInput =>
        const PreviousInputAction(devices: ['TV - Living Room']),
      ActionType.selectChannel => const SelectChannelAction(
          devices: ['TV - Living Room'], channelNumber: '123'),
      ActionType.relativeChannel => const RelativeChannelAction(
          devices: ['TV - Living Room'], channelCount: 1),
      ActionType.returnChannel =>
        const ReturnChannelAction(devices: ['TV - Living Room']),
      ActionType.rotateAbsolute => const RotateAbsoluteAction(
          devices: ['Blinds - Living Room'], rotationPercent: 50),
      ActionType.timerStart =>
        const TimerStartAction(devices: ['Oven - Kitchen'], duration: '30m'),
      ActionType.timerAdjust =>
        const TimerAdjustAction(devices: ['Oven - Kitchen'], duration: '5m'),
      ActionType.timerPause =>
        const TimerPauseAction(devices: ['Oven - Kitchen']),
      ActionType.timerResume =>
        const TimerResumeAction(devices: ['Oven - Kitchen']),
      ActionType.timerCancel =>
        const TimerCancelAction(devices: ['Oven - Kitchen']),
      ActionType.lightEffectColorLoop => const LightEffectColorLoopAction(
          devices: ['Light - Living Room'], duration: '30m'),
      ActionType.lightEffectPulse => const LightEffectPulseAction(
          devices: ['Light - Living Room'], duration: '10s'),
      ActionType.lightEffectSleep => const LightEffectSleepAction(
          devices: ['Light - Bedroom'], duration: '30m'),
      ActionType.lightEffectWake => const LightEffectWakeAction(
          devices: ['Light - Bedroom'], duration: '30m'),
      ActionType.stopLightEffect =>
        const StopLightEffectAction(devices: ['Light - Living Room']),
      ActionType.appSelect => const AppSelectAction(
          devices: ['Chromecast - Living Room'], applicationName: 'Netflix'),
      ActionType.appInstall => const AppInstallAction(
          devices: ['Chromecast - Living Room'], newApplicationName: 'YouTube'),
      ActionType.appSearch => const AppSearchAction(
          devices: ['Chromecast - Living Room'], applicationName: 'Netflix'),
      ActionType.cook => const CookAction(
          devices: ['Oven - Kitchen'], start: true, cookingMode: 'BAKE'),
      ActionType.dispense => const DispenseAction(
          devices: ['Water Dispenser - Kitchen'], item: 'water'),
      ActionType.enableDisableGuestNetwork =>
        const EnableDisableGuestNetworkAction(
            devices: ['Router - Office'], enable: true),
      ActionType.enableDisableNetworkProfile =>
        const EnableDisableNetworkProfileAction(
            devices: ['Router - Office'], enable: true, profile: 'Kids'),
    };
  }
}
