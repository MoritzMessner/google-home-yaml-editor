import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';

import '../../../domain/models/automation.dart';
import '../../../utils/yaml_converter.dart';

/// ViewModel for the automation script editor
class EditorViewModel extends ChangeNotifier {
  EditorViewModel() {
    _replaceScript(AutomationScript.empty());
  }

  late AutomationScript _script;
  AutomationScript get script => _script;

  /// Incremented whenever the whole script is replaced (import, new script).
  /// Widgets that hold their own field state use it as a key to rebuild.
  int _revision = 0;
  int get revision => _revision;

  // Stable ids for list items, parallel to the model lists. List widgets use
  // them as keys so field state follows its item when items are removed or
  // reordered.
  int _nextId = 0;
  late List<List<int>> _starterIds;
  late List<List<int>> _actionIds;

  List<int> starterIds(int automationIndex) =>
      List.unmodifiable(_starterIds[automationIndex]);

  List<int> actionIds(int automationIndex) =>
      List.unmodifiable(_actionIds[automationIndex]);

  void _replaceScript(AutomationScript script) {
    _script = script;
    _starterIds = [
      for (final automation in script.automations)
        [for (final _ in automation.starters) _nextId++],
    ];
    _actionIds = [
      for (final automation in script.automations)
        [for (final _ in automation.actions) _nextId++],
    ];
    _revision++;
  }

  String? _parseError;
  String? get parseError => _parseError;

  /// Get the YAML representation of the current script
  String get yamlOutput => YamlConverter.toYaml(_script);

  // --- Metadata ---

  void updateMetadataName(String name) {
    _script = _script.copyWith(
      metadata: _script.metadata.copyWith(name: name),
    );
    notifyListeners();
  }

  void updateMetadataDescription(String description) {
    _script = _script.copyWith(
      metadata: _script.metadata.copyWith(description: description),
    );
    notifyListeners();
  }

  // --- Starters ---

  void updateStarter(int automationIndex, int starterIndex, Starter starter) {
    final automations = List<Automation>.from(_script.automations);
    final automation = automations[automationIndex];
    final starters = List<Starter>.from(automation.starters);
    starters[starterIndex] = starter;
    automations[automationIndex] = automation.copyWith(starters: starters);
    _script = _script.copyWith(automations: automations);
    notifyListeners();
  }

  void addStarter(int automationIndex) {
    final automations = List<Automation>.from(_script.automations);
    final automation = automations[automationIndex];
    final starters = List<Starter>.from(automation.starters);
    starters.add(const OkGoogleStarter());
    automations[automationIndex] = automation.copyWith(starters: starters);
    _script = _script.copyWith(automations: automations);
    _starterIds[automationIndex].add(_nextId++);
    notifyListeners();
  }

  void removeStarter(int automationIndex, int starterIndex) {
    final automations = List<Automation>.from(_script.automations);
    final automation = automations[automationIndex];
    if (automation.starters.length <= 1) return; // Keep at least one starter
    final starters = List<Starter>.from(automation.starters);
    starters.removeAt(starterIndex);
    automations[automationIndex] = automation.copyWith(starters: starters);
    _script = _script.copyWith(automations: automations);
    _starterIds[automationIndex].removeAt(starterIndex);
    notifyListeners();
  }

  // --- Condition ---

  void setCondition(int automationIndex, Condition? condition) {
    final automations = List<Automation>.from(_script.automations);
    automations[automationIndex] = automations[automationIndex].copyWith(
      condition: condition,
      clearCondition: condition == null,
    );
    _script = _script.copyWith(automations: automations);
    notifyListeners();
  }

  void updateCondition(int automationIndex, Condition condition) {
    setCondition(automationIndex, condition);
  }

  void removeCondition(int automationIndex) {
    setCondition(automationIndex, null);
  }

  // --- Actions ---

  void addAction(int automationIndex, AutomationAction action) {
    final automations = List<Automation>.from(_script.automations);
    final automation = automations[automationIndex];
    final actions = List<AutomationAction>.from(automation.actions);
    actions.add(action);
    automations[automationIndex] = automation.copyWith(actions: actions);
    _script = _script.copyWith(automations: automations);
    _actionIds[automationIndex].add(_nextId++);
    notifyListeners();
  }

  void updateAction(
      int automationIndex, int actionIndex, AutomationAction action) {
    final automations = List<Automation>.from(_script.automations);
    final automation = automations[automationIndex];
    final actions = List<AutomationAction>.from(automation.actions);
    actions[actionIndex] = action;
    automations[automationIndex] = automation.copyWith(actions: actions);
    _script = _script.copyWith(automations: automations);
    notifyListeners();
  }

  void removeAction(int automationIndex, int actionIndex) {
    final automations = List<Automation>.from(_script.automations);
    final automation = automations[automationIndex];
    final actions = List<AutomationAction>.from(automation.actions);
    actions.removeAt(actionIndex);
    automations[automationIndex] = automation.copyWith(actions: actions);
    _script = _script.copyWith(automations: automations);
    _actionIds[automationIndex].removeAt(actionIndex);
    notifyListeners();
  }

  /// Moves the action at [oldIndex] so that it ends up at [newIndex].
  void moveAction(int automationIndex, int oldIndex, int newIndex) {
    final automations = List<Automation>.from(_script.automations);
    final automation = automations[automationIndex];
    final actions = List<AutomationAction>.from(automation.actions);
    final action = actions.removeAt(oldIndex);
    actions.insert(newIndex, action);
    automations[automationIndex] = automation.copyWith(actions: actions);
    _script = _script.copyWith(automations: automations);
    final ids = _actionIds[automationIndex];
    ids.insert(newIndex, ids.removeAt(oldIndex));
    notifyListeners();
  }

  // --- Import YAML ---

  bool importYaml(String yaml) {
    Object? error;
    final parsed = YamlConverter.fromYaml(yaml, onError: (e) => error = e);
    if (parsed != null) {
      _replaceScript(parsed);
      _parseError = null;
      notifyListeners();
      return true;
    } else {
      _parseError = _describeParseError(error);
      notifyListeners();
      return false;
    }
  }

  static String _describeParseError(Object? error) {
    const prefix = 'Failed to parse YAML';
    return switch (error) {
      null => '$prefix. Please check the format.',
      YamlException(:final message, :final span?) =>
        '$prefix (line ${span.start.line + 1}): $message',
      YamlException(:final message) => '$prefix: $message',
      ArgumentError(:final message) => '$prefix: $message',
      _ => '$prefix. Please check the format.',
    };
  }

  void clearParseError() {
    _parseError = null;
    notifyListeners();
  }

  // --- Reset ---

  void newScript() {
    _replaceScript(AutomationScript.empty());
    _parseError = null;
    notifyListeners();
  }
}
