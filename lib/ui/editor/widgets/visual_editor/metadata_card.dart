import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';
import 'section_header.dart';

/// Card for editing automation metadata (name and description)
class MetadataCard extends StatelessWidget {
  const MetadataCard({
    super.key,
    required this.name,
    required this.description,
    required this.onNameChanged,
    required this.onDescriptionChanged,
  });

  final String name;
  final String description;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'METADATA',
              color: AppTheme.metadataColor,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                labelText: 'Name',
                isDense: true,
              ),
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(
                labelText: 'Description',
                isDense: true,
              ),
              maxLines: 2,
              onChanged: onDescriptionChanged,
            ),
          ],
        ),
      ),
    );
  }
}



