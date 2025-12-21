import 'package:flutter/material.dart';
import '../../../../domain/models/condition.dart';

class WeekdaySelector extends StatelessWidget {
  const WeekdaySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final List<Weekday> selected;
  final ValueChanged<List<Weekday>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Weekdays',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: Weekday.values.map((day) {
            final isSelected = selected.contains(day);
            return FilterChip(
              label: Text(day.value),
              selected: isSelected,
              onSelected: (bool selectedValue) {
                final newSelected = List<Weekday>.from(selected);
                if (selectedValue) {
                  newSelected.add(day);
                } else {
                  newSelected.remove(day);
                }
                // Sort to keep order consistent
                newSelected.sort((a, b) => a.index.compareTo(b.index));
                onChanged(newSelected);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
