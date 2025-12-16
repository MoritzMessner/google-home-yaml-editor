import 'package:flutter/material.dart';

import '../../../../domain/models/automation.dart';
import '../../../core/themes/app_theme.dart';

/// Card for editing a condition
class ConditionCard extends StatelessWidget {
  const ConditionCard({
    super.key,
    required this.condition,
    required this.onChanged,
    required this.onRemove,
  });

  final Condition? condition;
  final ValueChanged<Condition> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (condition == null) {
      return Card(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppTheme.conditionColor.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
          ),
          child: InkWell(
            onTap: () => onChanged(
              const TimeBetweenCondition(after: '00:00', before: '23:59'),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: AppTheme.conditionColor.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add Condition (optional)',
                    style: TextStyle(
                      color: AppTheme.conditionColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: AppTheme.conditionColor, width: 3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    size: 18,
                    color: AppTheme.conditionColor,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Time Condition',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.conditionColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onRemove,
                    tooltip: 'Remove condition',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildConditionFields(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionFields(BuildContext context) {
    return switch (condition!) {
      TimeBetweenCondition(:final after, :final before) => Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: after,
                key: ValueKey('after_$after'),
                decoration: const InputDecoration(
                  labelText: 'After',
                  hintText: 'e.g., 22:00 or sunset',
                  isDense: true,
                  prefixIcon: Icon(Icons.schedule, size: 18),
                ),
                onChanged: (value) => onChanged(
                  TimeBetweenCondition(after: value, before: before),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: before,
                key: ValueKey('before_$before'),
                decoration: const InputDecoration(
                  labelText: 'Before',
                  hintText: 'e.g., 06:00 or sunrise',
                  isDense: true,
                  prefixIcon: Icon(Icons.schedule, size: 18),
                ),
                onChanged: (value) => onChanged(
                  TimeBetweenCondition(after: after, before: value),
                ),
              ),
            ),
          ],
        ),
    };
  }
}

