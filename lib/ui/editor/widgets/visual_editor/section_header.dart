import 'package:flutter/material.dart';

/// A styled section header with optional add button
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.color,
    this.onAdd,
    this.addTooltip,
  });

  final String title;
  final Color color;
  final VoidCallback? onAdd;
  final String? addTooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (onAdd != null)
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: onAdd,
              tooltip: addTooltip ?? 'Add',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              style: IconButton.styleFrom(
                foregroundColor: color,
              ),
            ),
        ],
      ),
    );
  }
}



