import 'package:flutter/foundation.dart';

import '../../../domain/models/automation.dart';
import '../../../utils/yaml_converter.dart';

/// ViewModel for the automation script editor
class EditorViewModel extends ChangeNotifier {
  EditorViewModel() {
    _script = AutomationScript.empty();
  }

  late AutomationScript _script;
  AutomationScript get script => _script;

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
    notifyListeners();
  }

  void moveAction(int automationIndex, int oldIndex, int newIndex) {
    final automations = List<Automation>.from(_script.automations);
    final automation = automations[automationIndex];
    final actions = List<AutomationAction>.from(automation.actions);
    if (newIndex > oldIndex) newIndex--;
    final action = actions.removeAt(oldIndex);
    actions.insert(newIndex, action);
    automations[automationIndex] = automation.copyWith(actions: actions);
    _script = _script.copyWith(automations: automations);
    notifyListeners();
  }

  // --- Import YAML ---

  bool importYaml(String yaml) {
    final parsed = YamlConverter.fromYaml(yaml);
    if (parsed != null) {
      _script = parsed;
      _parseError = null;
      notifyListeners();
      return true;
    } else {
      _parseError = 'Failed to parse YAML. Please check the format.';
      notifyListeners();
      return false;
    }
  }

  void clearParseError() {
    _parseError = null;
    notifyListeners();
  }

  // --- Reset ---

  void newScript() {
    _script = AutomationScript.empty();
    _parseError = null;
    notifyListeners();
  }
}



