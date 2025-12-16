/// Represents a complete Google Home automation script
class AutomationScript {
  AutomationScript({
    required this.metadata,
    required this.automations,
  });

  final AutomationMetadata metadata;
  final List<Automation> automations;

  AutomationScript copyWith({
    AutomationMetadata? metadata,
    List<Automation>? automations,
  }) {
    return AutomationScript(
      metadata: metadata ?? this.metadata,
      automations: automations ?? this.automations,
    );
  }

  factory AutomationScript.empty() {
    return AutomationScript(
      metadata: AutomationMetadata(name: 'New Automation', description: ''),
      automations: [Automation.empty()],
    );
  }
}

/// Metadata section of the automation script
class AutomationMetadata {
  AutomationMetadata({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  AutomationMetadata copyWith({
    String? name,
    String? description,
  }) {
    return AutomationMetadata(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

/// A single automation with starters, optional condition, and actions
class Automation {
  Automation({
    required this.starters,
    this.condition,
    required this.actions,
  });

  final List<Starter> starters;
  final Condition? condition;
  final List<AutomationAction> actions;

  Automation copyWith({
    List<Starter>? starters,
    Condition? condition,
    List<AutomationAction>? actions,
    bool clearCondition = false,
  }) {
    return Automation(
      starters: starters ?? this.starters,
      condition: clearCondition ? null : (condition ?? this.condition),
      actions: actions ?? this.actions,
    );
  }

  factory Automation.empty() {
    return Automation(
      starters: [Starter.okGoogle('')],
      actions: [],
    );
  }
}

/// Starter types for automations
sealed class Starter {
  const Starter();

  factory Starter.okGoogle(String query) = OkGoogleStarter;
  factory Starter.deviceState({
    required String device,
    required String state,
    required dynamic value,
  }) = DeviceStateStarter;
}

class OkGoogleStarter extends Starter {
  const OkGoogleStarter(this.query);
  final String query;
}

class DeviceStateStarter extends Starter {
  const DeviceStateStarter({
    required this.device,
    required this.state,
    required this.value,
  });

  final String device;
  final String state;
  final dynamic value;
}

/// Condition types for automations
sealed class Condition {
  const Condition();

  factory Condition.timeBetween({
    required String after,
    required String before,
  }) = TimeBetweenCondition;
}

class TimeBetweenCondition extends Condition {
  const TimeBetweenCondition({
    required this.after,
    required this.before,
  });

  final String after;
  final String before;
}

/// Action types for automations
sealed class AutomationAction {
  const AutomationAction();

  factory AutomationAction.onOff({
    required List<String> devices,
    required bool on,
  }) = OnOffAction;

  factory AutomationAction.brightness({
    required List<String> devices,
    required int brightness,
  }) = BrightnessAction;

  factory AutomationAction.color({
    required List<String> devices,
    required ColorValue color,
  }) = ColorAction;

  factory AutomationAction.delay({
    required String duration,
  }) = DelayAction;
}

class OnOffAction extends AutomationAction {
  const OnOffAction({
    required this.devices,
    required this.on,
  });

  final List<String> devices;
  final bool on;
}

class BrightnessAction extends AutomationAction {
  const BrightnessAction({
    required this.devices,
    required this.brightness,
  });

  final List<String> devices;
  final int brightness;
}

class ColorAction extends AutomationAction {
  const ColorAction({
    required this.devices,
    required this.color,
  });

  final List<String> devices;
  final ColorValue color;
}

class DelayAction extends AutomationAction {
  const DelayAction({
    required this.duration,
  });

  final String duration;
}

/// Color value - can be name or temperature
sealed class ColorValue {
  const ColorValue();

  factory ColorValue.name(String name) = ColorName;
  factory ColorValue.temperature(String temperature) = ColorTemperature;
}

class ColorName extends ColorValue {
  const ColorName(this.name);
  final String name;
}

class ColorTemperature extends ColorValue {
  const ColorTemperature(this.temperature);
  final String temperature;
}

