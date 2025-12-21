/// Core automation script models
/// Based on https://developers.home.google.com/automations/starters-conditions-and-actions

import 'action.dart';
import 'condition.dart';
import 'starter.dart';

// ============================================================================
// Script & Metadata
// ============================================================================

class AutomationScript {
  const AutomationScript({
    required this.metadata,
    required this.automations,
  });

  final Metadata metadata;
  final List<Automation> automations;

  factory AutomationScript.empty() => AutomationScript(
        metadata: const Metadata(name: '', description: ''),
        automations: [
          Automation(
            starters: const [OkGoogleStarter()],
            condition: null,
            actions: const [],
          ),
        ],
      );

  AutomationScript copyWith({
    Metadata? metadata,
    List<Automation>? automations,
  }) {
    return AutomationScript(
      metadata: metadata ?? this.metadata,
      automations: automations ?? this.automations,
    );
  }
}

class Metadata {
  const Metadata({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  Metadata copyWith({String? name, String? description}) {
    return Metadata(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

// ============================================================================
// Automation
// ============================================================================

class Automation {
  const Automation({
    required this.starters,
    required this.condition,
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
}
