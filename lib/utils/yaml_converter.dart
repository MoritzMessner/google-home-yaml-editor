import 'package:yaml/yaml.dart';

import '../domain/models/automation.dart';
import '../domain/models/condition.dart';
import '../domain/models/starter.dart';

/// Converts between AutomationScript and YAML format
class YamlConverter {
  YamlConverter._();

  /// Convert AutomationScript to YAML string
  static String toYaml(AutomationScript script) {
    final buffer = StringBuffer();

    // Metadata
    buffer.writeln('metadata:');
    buffer.writeln('  name: ${script.metadata.name}');
    buffer.writeln('  description: ${script.metadata.description}');
    buffer.writeln();

    // Automations
    buffer.writeln('automations:');
    for (final automation in script.automations) {
      buffer.writeln('  - starters:');
      for (final starter in automation.starters) {
        _writeStarter(buffer, starter);
      }

      if (automation.condition != null) {
        buffer.writeln('    condition:');
        _writeCondition(buffer, automation.condition!);
      }

      buffer.writeln('    actions:');
      for (final action in automation.actions) {
        _writeAction(buffer, action);
      }
    }

    return buffer.toString();
  }

  /// Parse YAML string to AutomationScript
  static AutomationScript? fromYaml(String yaml) {
    try {
      final doc = loadYaml(yaml) as YamlMap?;
      if (doc == null) return null;

      final metadataYaml = doc['metadata'] as YamlMap?;
      final metadata = Metadata(
        name: metadataYaml?['name']?.toString() ?? '',
        description: metadataYaml?['description']?.toString() ?? '',
      );

      final automationsYaml = doc['automations'] as YamlList?;
      final automations = <Automation>[];

      if (automationsYaml != null) {
        for (final automationYaml in automationsYaml) {
          final startersYaml = automationYaml['starters'] as YamlList?;
          final starters = <Starter>[];

          if (startersYaml != null) {
            for (final starterYaml in startersYaml) {
              final starter = _parseStarter(starterYaml as YamlMap);
              if (starter != null) starters.add(starter);
            }
          }

          if (starters.isEmpty) {
            starters.add(const OkGoogleStarter());
          }

          final conditionYaml = automationYaml['condition'] as YamlMap?;
          final condition =
              conditionYaml != null ? _parseCondition(conditionYaml) : null;

          final actionsYaml = automationYaml['actions'] as YamlList?;
          final actions = <AutomationAction>[];

          if (actionsYaml != null) {
            for (final actionYaml in actionsYaml) {
              final action = _parseAction(actionYaml as YamlMap);
              if (action != null) actions.add(action);
            }
          }

          automations.add(Automation(
            starters: starters,
            condition: condition,
            actions: actions,
          ));
        }
      }

      if (automations.isEmpty) {
        automations.add(const Automation(
          starters: [OkGoogleStarter()],
          condition: null,
          actions: [],
        ));
      }

      return AutomationScript(
        metadata: metadata,
        automations: automations,
      );
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // Writing Helpers
  // ============================================================================

  static void _writeStarter(StringBuffer buffer, Starter starter) {
    switch (starter) {
      // Assistant events
      case OkGoogleStarter(:final eventData):
        buffer.writeln('      - type: assistant.event.OkGoogle');
        buffer.writeln('        eventData: query');
        buffer.writeln('        is: ${_quote(eventData)}');

      // Time events
      case TimeScheduleStarter(:final at, :final weekdays):
        buffer.writeln('      - type: time.schedule');
        buffer.writeln('        at: $at');
        if (weekdays != null && weekdays.isNotEmpty) {
          buffer.writeln('        weekdays:');
          for (final day in weekdays) {
            buffer.writeln('          - ${_quote(day.value)}');
          }
        }

      // Home state
      case HomePresenceStarter(:final state, :final is_):
        buffer.writeln('      - type: home.state.HomePresence');
        buffer.writeln('        state: $state');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      // Device events
      case DoorbellPressStarter(:final device):
        buffer.writeln('      - type: device.event.DoorbellPress');
        buffer.writeln('        device: ${_quote(device)}');

      case MotionDetectionEventStarter(:final device):
        buffer.writeln('      - type: device.event.MotionDetection');
        buffer.writeln('        device: ${_quote(device)}');

      case PersonDetectionStarter(:final device):
        buffer.writeln('      - type: device.event.PersonDetection');
        buffer.writeln('        device: ${_quote(device)}');

      case FaceFamiliarDetectionStarter(:final device):
        buffer.writeln('      - type: device.event.FaceFamiliarDetection');
        buffer.writeln('        device: ${_quote(device)}');

      case FaceUnfamiliarDetectionStarter(:final device):
        buffer.writeln('      - type: device.event.FaceUnfamiliarDetection');
        buffer.writeln('        device: ${_quote(device)}');

      case AnimalDetectionStarter(:final device):
        buffer.writeln('      - type: device.event.AnimalOtherDetection');
        buffer.writeln('        device: ${_quote(device)}');

      case MovingVehicleDetectionStarter(:final device):
        buffer.writeln('      - type: device.event.MovingVehicleDetection');
        buffer.writeln('        device: ${_quote(device)}');

      case PackageDeliveredStarter(:final device):
        buffer.writeln('      - type: device.event.PackageDelivered');
        buffer.writeln('        device: ${_quote(device)}');

      case PersonTalkingStarter(:final device):
        buffer.writeln('      - type: device.event.PersonTalking');
        buffer.writeln('        device: ${_quote(device)}');

      case SoundEventStarter(:final device):
        buffer.writeln('      - type: device.event.Sound');
        buffer.writeln('        device: ${_quote(device)}');

      // Device state changes
      case OnOffStateStarter(:final device, :final is_):
        buffer.writeln('      - type: device.state.OnOff');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: on');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case BrightnessStateStarter(:final device, :final is_):
        buffer.writeln('      - type: device.state.Brightness');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: brightness');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case LockUnlockStateStarter(:final device, :final is_):
        buffer.writeln('      - type: device.state.LockUnlock');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: isLocked');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case OpenCloseStateStarter(:final device, :final is_):
        buffer.writeln('      - type: device.state.OpenClose');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: openPercent');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case TemperatureSettingStarter(:final device, :final state, :final is_):
        buffer.writeln('      - type: device.state.TemperatureSetting');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: $state');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case MotionDetectionStateStarter(:final device, :final is_):
        buffer.writeln('      - type: device.state.MotionDetection');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: motionDetected');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case OccupancyStateStarter(:final device, :final is_):
        buffer.writeln('      - type: device.state.OccupancySensing');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: occupancy');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case EnergyStorageStateStarter(:final device, :final state, :final is_):
        buffer.writeln('      - type: device.state.EnergyStorage');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: $state');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case TimerStateStarter(:final device, :final state, :final is_):
        buffer.writeln('      - type: device.state.Timer');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: $state');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');

      case DeviceStateStarter(:final device, :final state, :final is_):
        buffer.writeln('      - type: device.state');
        buffer.writeln('        device: ${_quote(device)}');
        buffer.writeln('        state: $state');
        if (is_ != null) buffer.writeln('        is: ${_formatValue(is_)}');
    }
  }

  static void _writeCondition(StringBuffer buffer, Condition condition,
      {int indent = 6}) {
    final prefix = ' ' * indent;
    switch (condition) {
      case TimeBetweenCondition(:final after, :final before, :final weekdays):
        buffer.writeln('${prefix}type: time.between');
        if (after != null) buffer.writeln('${prefix}after: $after');
        if (before != null) buffer.writeln('${prefix}before: $before');
        if (weekdays != null && weekdays.isNotEmpty) {
          buffer.writeln('${prefix}weekdays:');
          for (final day in weekdays) {
            buffer.writeln('$prefix  - ${_quote(day.value)}');
          }
        }

      case HomePresenceCondition(:final state, :final is_):
        buffer.writeln('${prefix}type: home.state.HomePresence');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case OnOffCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.OnOff');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: on');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case BrightnessCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.Brightness');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: brightness');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case VolumeCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.Volume');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case LockUnlockCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.LockUnlock');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: isLocked');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case OpenCloseCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.OpenClose');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: openPercent');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case TemperatureSettingCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.TemperatureSetting');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case ArmDisarmCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.ArmDisarm');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case DockCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.Dock');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: isDocked');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case StartStopCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.StartStop');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: isRunning');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case FanSpeedCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.FanSpeed');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case HumiditySettingCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.HumiditySetting');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case FillCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.Fill');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case EnergyStorageCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.EnergyStorage');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case MotionDetectionCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.MotionDetection');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: motionDetected');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case OccupancySensingCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.OccupancySensing');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: occupancy');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case OnlineCondition(:final device, :final is_):
        buffer.writeln('${prefix}type: device.state.Online');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: online');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case TimerCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.Timer');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case MediaStateCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.MediaState');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case SensorStateCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state.SensorState');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');

      case DeviceStateCondition(:final device, :final state, :final is_):
        buffer.writeln('${prefix}type: device.state');
        buffer.writeln('${prefix}device: ${_quote(device)}');
        buffer.writeln('${prefix}state: $state');
        if (is_ != null) buffer.writeln('${prefix}is: ${_formatValue(is_)}');
    }
  }

  static void _writeAction(StringBuffer buffer, AutomationAction action) {
    switch (action) {
      case DelayAction(:final duration):
        buffer.writeln('      - type: time.delay');
        buffer.writeln('        for: $duration');

      case BroadcastAction(:final message):
        buffer.writeln('      - type: assistant.command.Broadcast');
        buffer.writeln('        message: ${_quote(message)}');

      case AssistantCommandAction(:final devices, :final command):
        buffer.writeln('      - type: assistant.command.OkGoogle');
        _writeDevices(buffer, devices);
        buffer.writeln('        okGoogle: ${_quote(command)}');

      case OnOffAction(:final devices, :final on):
        buffer.writeln('      - type: device.command.OnOff');
        _writeDevices(buffer, devices);
        buffer.writeln('        on: $on');

      case ActivateSceneAction(:final scene, :final activate):
        buffer.writeln('      - type: device.command.ActivateScene');
        buffer.writeln('        scene: ${_quote(scene)}');
        buffer.writeln('        activate: $activate');

      case BrightnessAbsoluteAction(:final devices, :final brightness):
        buffer.writeln('      - type: device.command.BrightnessAbsolute');
        _writeDevices(buffer, devices);
        buffer.writeln('        brightness: $brightness');

      case BrightnessRelativeAction(
          :final devices,
          :final brightnessRelativePercent,
          :final brightnessRelativeWeight
        ):
        buffer.writeln('      - type: device.command.BrightnessRelative');
        _writeDevices(buffer, devices);
        if (brightnessRelativePercent != null) {
          buffer.writeln(
              '        brightnessRelativePercent: $brightnessRelativePercent');
        }
        if (brightnessRelativeWeight != null) {
          buffer.writeln(
              '        brightnessRelativeWeight: $brightnessRelativeWeight');
        }

      case ColorAbsoluteAction(
          :final devices,
          :final spectrumRGB,
          :final temperature
        ):
        buffer.writeln('      - type: device.command.ColorAbsolute');
        _writeDevices(buffer, devices);
        buffer.writeln('        color:');
        if (spectrumRGB != null) {
          buffer.writeln('          spectrumRGB: $spectrumRGB');
        }
        if (temperature != null) {
          buffer.writeln('          temperature: $temperature');
        }

      case SetVolumeAction(:final devices, :final volumeLevel):
        buffer.writeln('      - type: device.command.SetVolume');
        _writeDevices(buffer, devices);
        buffer.writeln('        volumeLevel: $volumeLevel');

      case MuteAction(:final devices, :final mute):
        buffer.writeln('      - type: device.command.Mute');
        _writeDevices(buffer, devices);
        buffer.writeln('        mute: $mute');

      case MediaNextAction(:final devices):
        buffer.writeln('      - type: device.command.MediaNext');
        _writeDevices(buffer, devices);

      case MediaPreviousAction(:final devices):
        buffer.writeln('      - type: device.command.MediaPrevious');
        _writeDevices(buffer, devices);

      case MediaPauseAction(:final devices):
        buffer.writeln('      - type: device.command.MediaPause');
        _writeDevices(buffer, devices);

      case MediaResumeAction(:final devices):
        buffer.writeln('      - type: device.command.MediaResume');
        _writeDevices(buffer, devices);

      case MediaStopAction(:final devices):
        buffer.writeln('      - type: device.command.MediaStop');
        _writeDevices(buffer, devices);

      case MediaShuffleAction(:final devices):
        buffer.writeln('      - type: device.command.MediaShuffle');
        _writeDevices(buffer, devices);

      case LockUnlockAction(:final devices, :final lock):
        buffer.writeln('      - type: device.command.LockUnlock');
        _writeDevices(buffer, devices);
        buffer.writeln('        lock: $lock');

      case ArmDisarmAction(
          :final devices,
          :final arm,
          :final armLevel,
          :final cancel
        ):
        buffer.writeln('      - type: device.command.ArmDisarm');
        _writeDevices(buffer, devices);
        buffer.writeln('        arm: $arm');
        if (armLevel != null) {
          buffer.writeln('        armLevel: ${_quote(armLevel)}');
        }
        if (cancel != null) {
          buffer.writeln('        cancel: $cancel');
        }

      case OpenCloseAction(
          :final devices,
          :final openPercent,
          :final openDirection
        ):
        buffer.writeln('      - type: device.command.OpenClose');
        _writeDevices(buffer, devices);
        if (openPercent != null) {
          buffer.writeln('        openPercent: $openPercent');
        }
        if (openDirection != null) {
          buffer.writeln('        openDirection: ${_quote(openDirection)}');
        }

      case ThermostatSetModeAction(:final devices, :final thermostatMode):
        buffer.writeln('      - type: device.command.ThermostatSetMode');
        _writeDevices(buffer, devices);
        buffer.writeln('        thermostatMode: ${_quote(thermostatMode)}');

      case ThermostatTemperatureSetpointAction(
          :final devices,
          :final thermostatTemperatureSetpoint
        ):
        buffer.writeln(
            '      - type: device.command.ThermostatTemperatureSetpoint');
        _writeDevices(buffer, devices);
        buffer.writeln(
            '        thermostatTemperatureSetpoint: $thermostatTemperatureSetpoint');

      case ThermostatTemperatureSetRangeAction(
          :final devices,
          :final thermostatTemperatureSetpointHigh,
          :final thermostatTemperatureSetpointLow
        ):
        buffer.writeln(
            '      - type: device.command.ThermostatTemperatureSetRange');
        _writeDevices(buffer, devices);
        buffer.writeln(
            '        thermostatTemperatureSetpointHigh: $thermostatTemperatureSetpointHigh');
        buffer.writeln(
            '        thermostatTemperatureSetpointLow: $thermostatTemperatureSetpointLow');

      case SetFanSpeedAction(:final devices, :final fanSpeed):
        buffer.writeln('      - type: device.command.SetFanSpeed');
        _writeDevices(buffer, devices);
        buffer.writeln('        fanSpeed: ${_quote(fanSpeed)}');

      case SetFanSpeedRelativeAction(
          :final devices,
          :final fanSpeedRelativePercent,
          :final fanSpeedRelativeWeight
        ):
        buffer.writeln('      - type: device.command.SetFanSpeedRelative');
        _writeDevices(buffer, devices);
        if (fanSpeedRelativePercent != null) {
          buffer.writeln(
              '        fanSpeedRelativePercent: $fanSpeedRelativePercent');
        }
        if (fanSpeedRelativeWeight != null) {
          buffer.writeln(
              '        fanSpeedRelativeWeight: $fanSpeedRelativeWeight');
        }

      case ReverseFanAction(:final devices):
        buffer.writeln('      - type: device.command.ReverseFan');
        _writeDevices(buffer, devices);

      case SetHumidityAction(:final devices, :final humidity):
        buffer.writeln('      - type: device.command.SetHumidity');
        _writeDevices(buffer, devices);
        buffer.writeln('        humidity: $humidity');

      case HumidityRelativeAction(
          :final devices,
          :final relativeHumidityPercent,
          :final relativeHumidityWeight
        ):
        buffer.writeln('      - type: device.command.HumidityRelative');
        _writeDevices(buffer, devices);
        if (relativeHumidityPercent != null) {
          buffer.writeln(
              '        relativeHumidityPercent: $relativeHumidityPercent');
        }
        if (relativeHumidityWeight != null) {
          buffer.writeln(
              '        relativeHumidityWeight: $relativeHumidityWeight');
        }

      case StartStopAction(:final devices, :final start):
        buffer.writeln('      - type: device.command.StartStop');
        _writeDevices(buffer, devices);
        buffer.writeln('        start: $start');

      case PauseUnpauseAction(:final devices, :final pause):
        buffer.writeln('      - type: device.command.PauseUnpause');
        _writeDevices(buffer, devices);
        buffer.writeln('        pause: $pause');

      case DockAction(:final devices):
        buffer.writeln('      - type: device.command.Dock');
        _writeDevices(buffer, devices);

      case ChargeAction(:final devices, :final charge):
        buffer.writeln('      - type: device.command.Charge');
        _writeDevices(buffer, devices);
        buffer.writeln('        charge: $charge');

      case RebootAction(:final devices):
        buffer.writeln('      - type: device.command.Reboot');
        _writeDevices(buffer, devices);

      case FillAction(:final devices, :final fill, :final fillLevel):
        buffer.writeln('      - type: device.command.Fill');
        _writeDevices(buffer, devices);
        buffer.writeln('        fill: $fill');
        if (fillLevel != null) {
          buffer.writeln('        fillLevel: ${_quote(fillLevel)}');
        }

      case FindMyDeviceAction(:final devices, :final silence):
        buffer.writeln('      - type: device.command.FindMyDevice');
        _writeDevices(buffer, devices);
        if (silence != null) {
          buffer.writeln('        silence: $silence');
        }

      case SetInputAction(:final devices, :final newInput):
        buffer.writeln('      - type: device.command.SetInput');
        _writeDevices(buffer, devices);
        buffer.writeln('        newInput: ${_quote(newInput)}');

      case NextInputAction(:final devices):
        buffer.writeln('      - type: device.command.NextInput');
        _writeDevices(buffer, devices);

      case PreviousInputAction(:final devices):
        buffer.writeln('      - type: device.command.PreviousInput');
        _writeDevices(buffer, devices);

      case SelectChannelAction(
          :final devices,
          :final channelCode,
          :final channelName,
          :final channelNumber
        ):
        buffer.writeln('      - type: device.command.SelectChannel');
        _writeDevices(buffer, devices);
        if (channelCode != null) {
          buffer.writeln('        channelCode: ${_quote(channelCode)}');
        }
        if (channelName != null) {
          buffer.writeln('        channelName: ${_quote(channelName)}');
        }
        if (channelNumber != null) {
          buffer.writeln('        channelNumber: ${_quote(channelNumber)}');
        }

      case RelativeChannelAction(:final devices, :final channelCount):
        buffer.writeln('      - type: device.command.RelativeChannel');
        _writeDevices(buffer, devices);
        buffer.writeln('        channelCount: $channelCount');

      case ReturnChannelAction(:final devices):
        buffer.writeln('      - type: device.command.ReturnChannel');
        _writeDevices(buffer, devices);

      case RotateAbsoluteAction(
          :final devices,
          :final rotationDegree,
          :final rotationPercent
        ):
        buffer.writeln('      - type: device.command.RotateAbsolute');
        _writeDevices(buffer, devices);
        if (rotationDegree != null) {
          buffer.writeln('        rotationDegree: $rotationDegree');
        }
        if (rotationPercent != null) {
          buffer.writeln('        rotationPercent: $rotationPercent');
        }

      case TimerStartAction(:final devices, :final duration):
        buffer.writeln('      - type: device.command.TimerStart');
        _writeDevices(buffer, devices);
        buffer.writeln('        duration: $duration');

      case TimerAdjustAction(:final devices, :final duration):
        buffer.writeln('      - type: device.command.TimerAdjust');
        _writeDevices(buffer, devices);
        buffer.writeln('        duration: $duration');

      case TimerPauseAction(:final devices):
        buffer.writeln('      - type: device.command.TimerPause');
        _writeDevices(buffer, devices);

      case TimerResumeAction(:final devices):
        buffer.writeln('      - type: device.command.TimerResume');
        _writeDevices(buffer, devices);

      case TimerCancelAction(:final devices):
        buffer.writeln('      - type: device.command.TimerCancel');
        _writeDevices(buffer, devices);

      case LightEffectColorLoopAction(:final devices, :final duration):
        buffer.writeln('      - type: device.command.LightEffectColorLoop');
        _writeDevices(buffer, devices);
        if (duration != null) {
          buffer.writeln('        duration: $duration');
        }

      case LightEffectPulseAction(:final devices, :final duration):
        buffer.writeln('      - type: device.command.LightEffectPulse');
        _writeDevices(buffer, devices);
        if (duration != null) {
          buffer.writeln('        duration: $duration');
        }

      case LightEffectSleepAction(:final devices, :final duration):
        buffer.writeln('      - type: device.command.LightEffectSleep');
        _writeDevices(buffer, devices);
        if (duration != null) {
          buffer.writeln('        duration: $duration');
        }

      case LightEffectWakeAction(:final devices, :final duration):
        buffer.writeln('      - type: device.command.LightEffectWake');
        _writeDevices(buffer, devices);
        if (duration != null) {
          buffer.writeln('        duration: $duration');
        }

      case StopLightEffectAction(:final devices):
        buffer.writeln('      - type: device.command.StopLightEffect');
        _writeDevices(buffer, devices);

      case AppSelectAction(:final devices, :final applicationName):
        buffer.writeln('      - type: device.command.AppSelect');
        _writeDevices(buffer, devices);
        buffer.writeln('        applicationName: ${_quote(applicationName)}');

      case AppInstallAction(:final devices, :final newApplicationName):
        buffer.writeln('      - type: device.command.AppInstall');
        _writeDevices(buffer, devices);
        buffer.writeln(
            '        newApplicationName: ${_quote(newApplicationName)}');

      case AppSearchAction(:final devices, :final applicationName):
        buffer.writeln('      - type: device.command.AppSearch');
        _writeDevices(buffer, devices);
        buffer.writeln('        applicationName: ${_quote(applicationName)}');

      case CookAction(
          :final devices,
          :final start,
          :final cookingMode,
          :final foodPreset,
          :final quantity,
          :final unit
        ):
        buffer.writeln('      - type: device.command.Cook');
        _writeDevices(buffer, devices);
        buffer.writeln('        start: $start');
        if (cookingMode != null) {
          buffer.writeln('        cookingMode: ${_quote(cookingMode)}');
        }
        if (foodPreset != null) {
          buffer.writeln('        foodPreset: ${_quote(foodPreset)}');
        }
        if (quantity != null) {
          buffer.writeln('        quantity: $quantity');
        }
        if (unit != null) {
          buffer.writeln('        unit: ${_quote(unit)}');
        }

      case DispenseAction(
          :final devices,
          :final amount,
          :final item,
          :final presetName,
          :final unit
        ):
        buffer.writeln('      - type: device.command.Dispense');
        _writeDevices(buffer, devices);
        if (amount != null) {
          buffer.writeln('        amount: $amount');
        }
        if (item != null) {
          buffer.writeln('        item: ${_quote(item)}');
        }
        if (presetName != null) {
          buffer.writeln('        presetName: ${_quote(presetName)}');
        }
        if (unit != null) {
          buffer.writeln('        unit: ${_quote(unit)}');
        }

      case EnableDisableGuestNetworkAction(:final devices, :final enable):
        buffer
            .writeln('      - type: device.command.EnableDisableGuestNetwork');
        _writeDevices(buffer, devices);
        buffer.writeln('        enable: $enable');

      case EnableDisableNetworkProfileAction(
          :final devices,
          :final enable,
          :final profile
        ):
        buffer.writeln(
            '      - type: device.command.EnableDisableNetworkProfile');
        _writeDevices(buffer, devices);
        buffer.writeln('        enable: $enable');
        buffer.writeln('        profile: ${_quote(profile)}');
    }
  }

  static void _writeDevices(StringBuffer buffer, List<String> devices) {
    if (devices.isEmpty) {
      buffer.writeln('        devices: []');
    } else if (devices.length == 1) {
      buffer.writeln('        devices:');
      buffer.writeln('          - ${_quote(devices.first)}');
    } else {
      buffer.writeln('        devices:');
      for (final device in devices) {
        buffer.writeln('          - ${_quote(device)}');
      }
    }
  }

  static String _quote(String value) {
    if (value.isEmpty) return '""';
    if (value.contains(':') ||
        value.contains('#') ||
        value.contains("'") ||
        value.contains('"') ||
        value.contains('\n') ||
        value.startsWith(' ') ||
        value.endsWith(' ')) {
      // Use double quotes and escape internal double quotes
      final escaped = value.replaceAll('"', '\\"');
      return '"$escaped"';
    }
    return value;
  }

  static String _formatValue(dynamic value) {
    if (value == null) return '';
    // Handle enum types by converting to their string value
    if (value is HomePresenceMode) return _quote(value.value);
    if (value is OccupancyState) return _quote(value.value);
    if (value is PlaybackState) return _quote(value.value);
    if (value is ThermostatMode) return _quote(value.value);
    if (value is EnergyCapacityLevel) return _quote(value.value);
    if (value is Weekday) return _quote(value.value);
    if (value is String) return _quote(value);
    return value.toString();
  }

  // ============================================================================
  // Parsing Helpers
  // ============================================================================

  static Starter? _parseStarter(YamlMap yaml) {
    final type = yaml['type']?.toString();
    final device = yaml['device']?.toString() ?? '';
    final state = yaml['state']?.toString() ?? '';
    final isValue = yaml['is'];

    switch (type) {
      // Assistant events
      case 'assistant.event.OkGoogle':
        // The command is stored in 'is' in correct YAML, but we map it to eventData in our model
        return OkGoogleStarter(
            eventData: yaml['is']?.toString() ??
                yaml['eventData']?.toString() ??
                yaml['query']?.toString() ??
                '');

      // Time events
      case 'time.schedule':
        final weekdaysYaml = yaml['weekdays'] as YamlList?;
        List<Weekday>? weekdays;
        if (weekdaysYaml != null) {
          weekdays = weekdaysYaml
              .map((d) => Weekday.fromString(d?.toString()))
              .whereType<Weekday>()
              .toList();
        }
        return TimeScheduleStarter(
          at: yaml['at']?.toString() ?? '8:00 am',
          weekdays: weekdays,
        );

      // Home state
      case 'home.state.HomePresence':
        return HomePresenceStarter(
          state: state.isEmpty ? 'homePresenceMode' : state,
          is_: HomePresenceMode.fromString(isValue?.toString() ?? 'HOME'),
        );

      // Device events
      case 'device.event.DoorbellPress':
        return DoorbellPressStarter(device: device);

      case 'device.event.MotionDetection':
        return MotionDetectionEventStarter(device: device);

      case 'device.event.PersonDetection':
        return PersonDetectionStarter(device: device);

      case 'device.event.FaceFamiliarDetection':
        return FaceFamiliarDetectionStarter(device: device);

      case 'device.event.FaceUnfamiliarDetection':
        return FaceUnfamiliarDetectionStarter(device: device);

      case 'device.event.AnimalOtherDetection':
        return AnimalDetectionStarter(device: device);

      case 'device.event.MovingVehicleDetection':
        return MovingVehicleDetectionStarter(device: device);

      case 'device.event.PackageDelivered':
        return PackageDeliveredStarter(device: device);

      case 'device.event.PersonTalking':
        return PersonTalkingStarter(device: device);

      case 'device.event.Sound':
        return SoundEventStarter(device: device);

      // Device state changes
      case 'device.state.OnOff':
        return OnOffStateStarter(
            device: device,
            state: state.isEmpty ? 'on' : state,
            is_: isValue == true);

      case 'device.state.Brightness':
        return BrightnessStateStarter(
            device: device,
            state: state.isEmpty ? 'brightness' : state,
            is_: _parseInt(isValue) ?? 100);

      case 'device.state.LockUnlock':
        return LockUnlockStateStarter(
            device: device,
            state: state.isEmpty ? 'isLocked' : state,
            is_: isValue == true);

      case 'device.state.OpenClose':
        return OpenCloseStateStarter(
            device: device,
            state: state.isEmpty ? 'openPercent' : state,
            is_: _parseInt(isValue) ?? 100);

      case 'device.state.TemperatureSetting':
        return TemperatureSettingStarter(
            device: device, state: state, is_: isValue);

      case 'device.state.MotionDetection':
        return MotionDetectionStateStarter(
            device: device,
            state: state.isEmpty ? 'motionDetectionEventInProgress' : state,
            is_: isValue == true);

      case 'device.state.OccupancySensing':
        return OccupancyStateStarter(
            device: device,
            state: state.isEmpty ? 'occupancy' : state,
            is_: isValue?.toString() ?? 'OCCUPIED');

      case 'device.state.EnergyStorage':
        return EnergyStorageStateStarter(
            device: device, state: state, is_: isValue);

      case 'device.state.Timer':
        return TimerStateStarter(device: device, state: state, is_: isValue);

      default:
        // Generic device state starter
        if (type?.startsWith('device.state') == true) {
          return DeviceStateStarter(device: device, state: state, is_: isValue);
        }
        return null;
    }
  }

  static Condition? _parseCondition(YamlMap yaml) {
    final type = yaml['type']?.toString();
    final device = yaml['device']?.toString() ?? '';
    final state = yaml['state']?.toString() ?? '';
    final isValue = yaml['is'];

    switch (type) {
      case 'time.between':
        final weekdaysYaml = yaml['weekdays'] as YamlList?;
        List<Weekday>? weekdays;
        if (weekdaysYaml != null) {
          weekdays = weekdaysYaml
              .map((d) => Weekday.fromString(d?.toString()))
              .whereType<Weekday>()
              .toList();
        }
        return TimeBetweenCondition(
          after: yaml['after']?.toString(),
          before: yaml['before']?.toString(),
          weekdays: weekdays,
        );

      case 'home.state.HomePresence':
        return HomePresenceCondition(
          state: state.isEmpty ? 'homePresenceMode' : state,
          is_: HomePresenceMode.fromString(isValue?.toString() ?? 'HOME'),
        );

      case 'device.state.OnOff':
        return OnOffCondition(
            device: device,
            state: state.isEmpty ? 'on' : state,
            is_: isValue == true);

      case 'device.state.Brightness':
        return BrightnessCondition(
            device: device,
            state: state.isEmpty ? 'brightness' : state,
            is_: _parseInt(isValue) ?? 100);

      case 'device.state.Volume':
        return VolumeCondition(
            device: device,
            state: state.isEmpty ? 'currentVolume' : state,
            is_: _parseInt(isValue) ?? 50);

      case 'device.state.LockUnlock':
        return LockUnlockCondition(
            device: device,
            state: state.isEmpty ? 'isLocked' : state,
            is_: isValue == true);

      case 'device.state.OpenClose':
        return OpenCloseCondition(
            device: device,
            state: state.isEmpty ? 'openPercent' : state,
            is_: _parseInt(isValue) ?? 100);

      case 'device.state.TemperatureSetting':
        // Handle thermostatMode as enum, temperature values as double
        dynamic parsedValue = isValue;
        if (state == 'thermostatMode' && isValue != null) {
          parsedValue = ThermostatMode.fromString(isValue.toString());
        } else if (isValue != null &&
            (state == 'thermostatTemperatureSetpoint' ||
                state == 'thermostatTemperatureAmbient')) {
          parsedValue = _parseDouble(isValue);
        }
        return TemperatureSettingCondition(
            device: device, state: state, is_: parsedValue);

      case 'device.state.ArmDisarm':
        return ArmDisarmCondition(device: device, state: state, is_: isValue);

      case 'device.state.Dock':
        return DockCondition(
            device: device,
            state: state.isEmpty ? 'isDocked' : state,
            is_: isValue == true);

      case 'device.state.StartStop':
        return StartStopCondition(
            device: device,
            state: state.isEmpty ? 'isRunning' : state,
            is_: isValue == true);

      case 'device.state.FanSpeed':
        return FanSpeedCondition(device: device, state: state, is_: isValue);

      case 'device.state.HumiditySetting':
        return HumiditySettingCondition(
            device: device, state: state, is_: isValue);

      case 'device.state.Fill':
        return FillCondition(device: device, state: state, is_: isValue);

      case 'device.state.EnergyStorage':
        // Handle descriptiveCapacityRemaining as enum, boolean states as bool
        dynamic parsedValue = isValue;
        if (state == 'descriptiveCapacityRemaining' && isValue != null) {
          parsedValue = EnergyCapacityLevel.fromString(isValue.toString());
        } else if (isValue != null &&
            (state == 'isCharging' || state == 'isPluggedIn')) {
          parsedValue =
              isValue == true || isValue.toString().toLowerCase() == 'true';
        }
        return EnergyStorageCondition(
            device: device, state: state, is_: parsedValue);

      case 'device.state.MotionDetection':
        return MotionDetectionCondition(
            device: device,
            state: state.isEmpty ? 'motionDetectionEventInProgress' : state,
            is_: isValue == true);

      case 'device.state.OccupancySensing':
        return OccupancySensingCondition(
            device: device,
            state: state.isEmpty ? 'occupancy' : state,
            is_: OccupancyState.fromString(isValue?.toString() ?? 'OCCUPIED'));

      case 'device.state.Online':
        return OnlineCondition(
            device: device,
            state: state.isEmpty ? 'online' : state,
            is_: isValue == true);

      case 'device.state.Timer':
        return TimerCondition(device: device, state: state, is_: isValue);

      case 'device.state.MediaState':
        dynamic parsedValue = isValue;
        if (state == 'playbackState' && isValue != null) {
          parsedValue = PlaybackState.fromString(isValue.toString());
        }
        return MediaStateCondition(
            device: device, state: state, is_: parsedValue);

      case 'device.state.SensorState':
        return SensorStateCondition(device: device, state: state, is_: isValue);

      default:
        // Generic device state condition
        if (type?.startsWith('device.state') == true) {
          return DeviceStateCondition(
              device: device, state: state, is_: isValue);
        }
        return null;
    }
  }

  static AutomationAction? _parseAction(YamlMap yaml) {
    final type = yaml['type']?.toString();
    final devices = _parseDevices(yaml['devices']);

    switch (type) {
      case 'time.delay':
        return DelayAction(duration: yaml['for']?.toString() ?? '10s');

      case 'assistant.command.Broadcast':
        return BroadcastAction(message: yaml['message']?.toString() ?? '');

      case 'assistant.command.OkGoogle':
        return AssistantCommandAction(
            devices: devices,
            command: yaml['okGoogle']?.toString() ??
                yaml['command']?.toString() ??
                '');

      case 'device.command.OnOff':
        return OnOffAction(
          devices: devices,
          on: yaml['on'] == true,
        );

      case 'device.command.ActivateScene':
        return ActivateSceneAction(
          scene: yaml['scene']?.toString() ?? '',
          activate: yaml['activate'] != false,
        );

      case 'device.command.BrightnessAbsolute':
        return BrightnessAbsoluteAction(
          devices: devices,
          brightness: _parseInt(yaml['brightness']) ?? 100,
        );

      case 'device.command.BrightnessRelative':
        return BrightnessRelativeAction(
          devices: devices,
          brightnessRelativePercent:
              _parseInt(yaml['brightnessRelativePercent']),
          brightnessRelativeWeight: _parseInt(yaml['brightnessRelativeWeight']),
        );

      case 'device.command.ColorAbsolute':
        final colorYaml = yaml['color'] as YamlMap?;
        return ColorAbsoluteAction(
          devices: devices,
          spectrumRGB: _parseInt(colorYaml?['spectrumRGB']),
          temperature: _parseColorTemperature(colorYaml?['temperature']),
        );

      case 'device.command.SetVolume':
        return SetVolumeAction(
          devices: devices,
          volumeLevel: _parseInt(yaml['volumeLevel']) ?? 50,
        );

      case 'device.command.Mute':
        return MuteAction(
          devices: devices,
          mute: yaml['mute'] == true,
        );

      case 'device.command.MediaNext':
        return MediaNextAction(devices: devices);

      case 'device.command.MediaPrevious':
        return MediaPreviousAction(devices: devices);

      case 'device.command.MediaPause':
        return MediaPauseAction(devices: devices);

      case 'device.command.MediaResume':
        return MediaResumeAction(devices: devices);

      case 'device.command.MediaStop':
        return MediaStopAction(devices: devices);

      case 'device.command.MediaShuffle':
        return MediaShuffleAction(devices: devices);

      case 'device.command.LockUnlock':
        return LockUnlockAction(
          devices: devices,
          lock: yaml['lock'] == true,
        );

      case 'device.command.ArmDisarm':
        return ArmDisarmAction(
          devices: devices,
          arm: yaml['arm'] == true,
          armLevel: yaml['armLevel']?.toString(),
          cancel: yaml['cancel'] as bool?,
        );

      case 'device.command.OpenClose':
        return OpenCloseAction(
          devices: devices,
          openPercent: _parseInt(yaml['openPercent']),
          openDirection: yaml['openDirection']?.toString(),
        );

      case 'device.command.ThermostatSetMode':
        return ThermostatSetModeAction(
          devices: devices,
          thermostatMode: yaml['thermostatMode']?.toString() ?? 'heat',
        );

      case 'device.command.ThermostatTemperatureSetpoint':
        return ThermostatTemperatureSetpointAction(
          devices: devices,
          thermostatTemperatureSetpoint:
              _parseDouble(yaml['thermostatTemperatureSetpoint']) ?? 21.0,
        );

      case 'device.command.ThermostatTemperatureSetRange':
        return ThermostatTemperatureSetRangeAction(
          devices: devices,
          thermostatTemperatureSetpointHigh:
              _parseDouble(yaml['thermostatTemperatureSetpointHigh']) ?? 24.0,
          thermostatTemperatureSetpointLow:
              _parseDouble(yaml['thermostatTemperatureSetpointLow']) ?? 18.0,
        );

      case 'device.command.SetFanSpeed':
        return SetFanSpeedAction(
          devices: devices,
          fanSpeed: yaml['fanSpeed']?.toString() ?? 'medium',
        );

      case 'device.command.SetFanSpeedRelative':
        return SetFanSpeedRelativeAction(
          devices: devices,
          fanSpeedRelativePercent: _parseInt(yaml['fanSpeedRelativePercent']),
          fanSpeedRelativeWeight: _parseInt(yaml['fanSpeedRelativeWeight']),
        );

      case 'device.command.ReverseFan':
        return ReverseFanAction(devices: devices);

      case 'device.command.SetHumidity':
        return SetHumidityAction(
          devices: devices,
          humidity: _parseInt(yaml['humidity']) ?? 50,
        );

      case 'device.command.HumidityRelative':
        return HumidityRelativeAction(
          devices: devices,
          relativeHumidityPercent: _parseInt(yaml['relativeHumidityPercent']),
          relativeHumidityWeight: _parseInt(yaml['relativeHumidityWeight']),
        );

      case 'device.command.StartStop':
        return StartStopAction(
          devices: devices,
          start: yaml['start'] == true,
        );

      case 'device.command.PauseUnpause':
        return PauseUnpauseAction(
          devices: devices,
          pause: yaml['pause'] == true,
        );

      case 'device.command.Dock':
        return DockAction(devices: devices);

      case 'device.command.Charge':
        return ChargeAction(
          devices: devices,
          charge: yaml['charge'] == true,
        );

      case 'device.command.Reboot':
        return RebootAction(devices: devices);

      case 'device.command.Fill':
        return FillAction(
          devices: devices,
          fill: yaml['fill'] == true,
          fillLevel: yaml['fillLevel']?.toString(),
        );

      case 'device.command.FindMyDevice':
        return FindMyDeviceAction(
          devices: devices,
          silence: yaml['silence'] as bool?,
        );

      case 'device.command.SetInput':
        return SetInputAction(
          devices: devices,
          newInput: yaml['newInput']?.toString() ?? '',
        );

      case 'device.command.NextInput':
        return NextInputAction(devices: devices);

      case 'device.command.PreviousInput':
        return PreviousInputAction(devices: devices);

      case 'device.command.SelectChannel':
        return SelectChannelAction(
          devices: devices,
          channelCode: yaml['channelCode']?.toString(),
          channelName: yaml['channelName']?.toString(),
          channelNumber: yaml['channelNumber']?.toString(),
        );

      case 'device.command.RelativeChannel':
        return RelativeChannelAction(
          devices: devices,
          channelCount: _parseInt(yaml['channelCount']) ?? 1,
        );

      case 'device.command.ReturnChannel':
        return ReturnChannelAction(devices: devices);

      case 'device.command.RotateAbsolute':
        return RotateAbsoluteAction(
          devices: devices,
          rotationDegree: _parseDouble(yaml['rotationDegree']),
          rotationPercent: _parseDouble(yaml['rotationPercent']),
        );

      case 'device.command.TimerStart':
        return TimerStartAction(
          devices: devices,
          duration: yaml['duration']?.toString() ?? '10m',
        );

      case 'device.command.TimerAdjust':
        return TimerAdjustAction(
          devices: devices,
          duration: yaml['duration']?.toString() ?? '5m',
        );

      case 'device.command.TimerPause':
        return TimerPauseAction(devices: devices);

      case 'device.command.TimerResume':
        return TimerResumeAction(devices: devices);

      case 'device.command.TimerCancel':
        return TimerCancelAction(devices: devices);

      case 'device.command.LightEffectColorLoop':
        return LightEffectColorLoopAction(
          devices: devices,
          duration: yaml['duration']?.toString(),
        );

      case 'device.command.LightEffectPulse':
        return LightEffectPulseAction(
          devices: devices,
          duration: yaml['duration']?.toString(),
        );

      case 'device.command.LightEffectSleep':
        return LightEffectSleepAction(
          devices: devices,
          duration: yaml['duration']?.toString(),
        );

      case 'device.command.LightEffectWake':
        return LightEffectWakeAction(
          devices: devices,
          duration: yaml['duration']?.toString(),
        );

      case 'device.command.StopLightEffect':
        return StopLightEffectAction(devices: devices);

      case 'device.command.AppSelect':
        return AppSelectAction(
          devices: devices,
          applicationName: yaml['applicationName']?.toString() ?? '',
        );

      case 'device.command.AppInstall':
        return AppInstallAction(
          devices: devices,
          newApplicationName: yaml['newApplicationName']?.toString() ?? '',
        );

      case 'device.command.AppSearch':
        return AppSearchAction(
          devices: devices,
          applicationName: yaml['applicationName']?.toString() ?? '',
        );

      case 'device.command.Cook':
        return CookAction(
          devices: devices,
          start: yaml['start'] == true,
          cookingMode: yaml['cookingMode']?.toString(),
          foodPreset: yaml['foodPreset']?.toString(),
          quantity: _parseInt(yaml['quantity']),
          unit: yaml['unit']?.toString(),
        );

      case 'device.command.Dispense':
        return DispenseAction(
          devices: devices,
          amount: _parseInt(yaml['amount']),
          item: yaml['item']?.toString(),
          presetName: yaml['presetName']?.toString(),
          unit: yaml['unit']?.toString(),
        );

      case 'device.command.EnableDisableGuestNetwork':
        return EnableDisableGuestNetworkAction(
          devices: devices,
          enable: yaml['enable'] == true,
        );

      case 'device.command.EnableDisableNetworkProfile':
        return EnableDisableNetworkProfileAction(
          devices: devices,
          enable: yaml['enable'] == true,
          profile: yaml['profile']?.toString() ?? '',
        );

      default:
        return null;
    }
  }

  static List<String> _parseDevices(dynamic devicesYaml) {
    if (devicesYaml == null) return [];
    if (devicesYaml is YamlList) {
      return devicesYaml.map((e) => e.toString()).toList();
    }
    if (devicesYaml is String) {
      return [devicesYaml];
    }
    return [];
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseColorTemperature(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      if (value.toUpperCase().endsWith('K')) {
        return int.tryParse(value.substring(0, value.length - 1));
      }
      return int.tryParse(value);
    }
    return null;
  }
}
