import 'package:yaml/yaml.dart';

import '../domain/models/automation.dart';

/// Utility class for converting between AutomationScript and YAML
class YamlConverter {
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
      _writeAutomation(buffer, automation);
    }

    return buffer.toString();
  }

  static void _writeAutomation(StringBuffer buffer, Automation automation) {
    // Starters
    buffer.writeln('  - starters:');
    for (final starter in automation.starters) {
      _writeStarter(buffer, starter);
    }

    // Condition
    if (automation.condition != null) {
      buffer.writeln();
      _writeCondition(buffer, automation.condition!);
    }

    // Actions
    if (automation.actions.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('    actions:');
      for (final action in automation.actions) {
        _writeAction(buffer, action);
      }
    }
  }

  static void _writeStarter(StringBuffer buffer, Starter starter) {
    switch (starter) {
      case OkGoogleStarter(:final query):
        buffer.writeln('      - type: assistant.event.OkGoogle');
        buffer.writeln('        eventData: query');
        buffer.writeln('        is: "$query"');
      case DeviceStateStarter(:final device, :final state, :final value):
        buffer.writeln('      - type: device.state.OnOff');
        buffer.writeln('        device: $device');
        buffer.writeln('        state: $state');
        buffer.writeln('        is: $value');
    }
  }

  static void _writeCondition(StringBuffer buffer, Condition condition) {
    switch (condition) {
      case TimeBetweenCondition(:final after, :final before):
        buffer.writeln('    condition:');
        buffer.writeln('      type: time.between');
        buffer.writeln('      after: $after');
        buffer.writeln('      before: $before');
    }
  }

  static void _writeAction(StringBuffer buffer, AutomationAction action) {
    switch (action) {
      case OnOffAction(:final devices, :final on):
        buffer.writeln('      - type: device.command.OnOff');
        buffer.writeln('        devices:');
        for (final device in devices) {
          buffer.writeln('          - $device');
        }
        buffer.writeln('        on: $on');

      case BrightnessAction(:final devices, :final brightness):
        buffer.writeln('      - type: device.command.BrightnessAbsolute');
        buffer.writeln('        devices:');
        for (final device in devices) {
          buffer.writeln('          - $device');
        }
        buffer.writeln('        brightness: $brightness');

      case ColorAction(:final devices, :final color):
        buffer.writeln('      - type: device.command.ColorAbsolute');
        buffer.writeln('        devices:');
        for (final device in devices) {
          buffer.writeln('          - $device');
        }
        buffer.writeln('        color:');
        switch (color) {
          case ColorName(:final name):
            buffer.writeln('          name: "$name"');
          case ColorTemperature(:final temperature):
            buffer.writeln('          temperature: $temperature');
        }

      case DelayAction(:final duration):
        buffer.writeln('      - type: time.delay');
        buffer.writeln('        for: $duration');
    }
  }

  /// Parse YAML string to AutomationScript
  static AutomationScript? fromYaml(String yamlString) {
    try {
      final doc = loadYaml(yamlString);
      if (doc is! YamlMap) return null;

      final metadata = _parseMetadata(doc['metadata']);
      final automations = _parseAutomations(doc['automations']);

      return AutomationScript(
        metadata: metadata,
        automations: automations,
      );
    } catch (e) {
      return null;
    }
  }

  static AutomationMetadata _parseMetadata(dynamic data) {
    if (data is! YamlMap) {
      return AutomationMetadata(name: 'Untitled', description: '');
    }
    return AutomationMetadata(
      name: data['name']?.toString() ?? 'Untitled',
      description: data['description']?.toString() ?? '',
    );
  }

  static List<Automation> _parseAutomations(dynamic data) {
    if (data is! YamlList) return [];

    return data.map((item) {
      if (item is! YamlMap) return Automation.empty();

      final starters = _parseStarters(item['starters']);
      final condition = _parseCondition(item['condition']);
      final actions = _parseActions(item['actions']);

      return Automation(
        starters: starters,
        condition: condition,
        actions: actions,
      );
    }).toList();
  }

  static List<Starter> _parseStarters(dynamic data) {
    if (data is! YamlList) return [];

    return data.map<Starter>((item) {
      if (item is! YamlMap) return const OkGoogleStarter('');

      final type = item['type']?.toString() ?? '';

      if (type == 'assistant.event.OkGoogle') {
        return OkGoogleStarter(item['is']?.toString() ?? '');
      } else if (type == 'device.state.OnOff') {
        return DeviceStateStarter(
          device: item['device']?.toString() ?? '',
          state: item['state']?.toString() ?? 'on',
          value: item['is'] ?? true,
        );
      }

      return const OkGoogleStarter('');
    }).toList();
  }

  static Condition? _parseCondition(dynamic data) {
    if (data is! YamlMap) return null;

    final type = data['type']?.toString() ?? '';

    if (type == 'time.between') {
      return TimeBetweenCondition(
        after: data['after']?.toString() ?? '00:00',
        before: data['before']?.toString() ?? '23:59',
      );
    }

    return null;
  }

  static List<AutomationAction> _parseActions(dynamic data) {
    if (data is! YamlList) return [];

    return data.map<AutomationAction>((item) {
      if (item is! YamlMap) {
        return const OnOffAction(devices: [], on: false);
      }

      final type = item['type']?.toString() ?? '';
      final devices = _parseDevices(item['devices']);

      switch (type) {
        case 'device.command.OnOff':
          return OnOffAction(
            devices: devices,
            on: item['on'] == true,
          );

        case 'device.command.BrightnessAbsolute':
          return BrightnessAction(
            devices: devices,
            brightness: (item['brightness'] as num?)?.toInt() ?? 100,
          );

        case 'device.command.ColorAbsolute':
          final color = _parseColor(item['color']);
          return ColorAction(devices: devices, color: color);

        case 'time.delay':
          return DelayAction(duration: item['for']?.toString() ?? '1sec');

        default:
          return const OnOffAction(devices: [], on: false);
      }
    }).toList();
  }

  static List<String> _parseDevices(dynamic data) {
    if (data is! YamlList) return [];
    return data.map((d) => d.toString()).toList();
  }

  static ColorValue _parseColor(dynamic data) {
    if (data is! YamlMap) return const ColorName('warm white');

    if (data['name'] != null) {
      return ColorName(data['name'].toString());
    } else if (data['temperature'] != null) {
      return ColorTemperature(data['temperature'].toString());
    }

    return const ColorName('warm white');
  }
}

