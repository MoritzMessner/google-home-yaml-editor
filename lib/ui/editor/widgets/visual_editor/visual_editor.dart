import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/automation.dart';
import '../../../core/themes/app_theme.dart';
import '../../view_model/editor_view_model.dart';
import 'action_card.dart';
import 'condition_card.dart';
import 'metadata_card.dart';
import 'section_header.dart';
import 'starter_card.dart';

/// The visual editor panel showing editable cards for each part of the automation
class VisualEditor extends StatelessWidget {
  const VisualEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditorViewModel>();
    final script = viewModel.script;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Metadata section
        MetadataCard(
          name: script.metadata.name,
          description: script.metadata.description,
          onNameChanged: viewModel.updateMetadataName,
          onDescriptionChanged: viewModel.updateMetadataDescription,
        ),

        const SizedBox(height: 24),

        // Automations
        for (int i = 0; i < script.automations.length; i++)
          _AutomationSection(
            automation: script.automations[i],
            automationIndex: i,
          ),
      ],
    );
  }
}

class _AutomationSection extends StatelessWidget {
  const _AutomationSection({
    required this.automation,
    required this.automationIndex,
  });

  final Automation automation;
  final int automationIndex;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EditorViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Starters section
        SectionHeader(
          title: 'TRIGGERS',
          color: AppTheme.starterColor,
          onAdd: () => viewModel.addStarter(automationIndex),
          addTooltip: 'Add trigger',
        ),
        for (int i = 0; i < automation.starters.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: StarterCard(
              starter: automation.starters[i],
              canRemove: automation.starters.length > 1,
              onChanged: (starter) =>
                  viewModel.updateStarter(automationIndex, i, starter),
              onRemove: () => viewModel.removeStarter(automationIndex, i),
            ),
          ),

        const SizedBox(height: 16),

        // Condition section
        const SectionHeader(
          title: 'CONDITION (optional)',
          color: AppTheme.conditionColor,
        ),
        ConditionCard(
          condition: automation.condition,
          onChanged: (condition) =>
              viewModel.updateCondition(automationIndex, condition),
          onRemove: () => viewModel.removeCondition(automationIndex),
        ),

        const SizedBox(height: 16),

        // Actions section
        SectionHeader(
          title: 'ACTIONS',
          color: AppTheme.actionColor,
          onAdd: () => viewModel.addAction(
            automationIndex,
            const OnOffAction(devices: [], on: true),
          ),
          addTooltip: 'Add action',
        ),
        if (automation.actions.isEmpty)
          Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppTheme.actionColor.withValues(alpha: 0.5),
                    width: 3,
                  ),
                ),
              ),
              child: InkWell(
                onTap: () => viewModel.addAction(
                  automationIndex,
                  const OnOffAction(devices: [], on: true),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppTheme.actionColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add an action',
                        style: TextStyle(
                          color: AppTheme.actionColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: automation.actions.length,
            onReorder: (oldIndex, newIndex) =>
                viewModel.moveAction(automationIndex, oldIndex, newIndex),
            itemBuilder: (context, index) {
              return Padding(
                key: ValueKey('action_$index'),
                padding: const EdgeInsets.only(bottom: 8),
                child: ActionCard(
                  action: automation.actions[index],
                  index: index,
                  onChanged: (action) =>
                      viewModel.updateAction(automationIndex, index, action),
                  onRemove: () =>
                      viewModel.removeAction(automationIndex, index),
                ),
              );
            },
          ),
      ],
    );
  }
}



