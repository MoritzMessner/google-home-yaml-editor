import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../view_model/editor_view_model.dart';

/// Panel showing the YAML output of the automation script
class YamlPreview extends StatelessWidget {
  const YamlPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditorViewModel>();
    final yaml = viewModel.yamlOutput;

    return Container(
      color: const Color(0xFF252535),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF3D3D4D)),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.code,
                  size: 18,
                  color: Color(0xFF89B4FA),
                ),
                const SizedBox(width: 8),
                const Text(
                  'YAML Output',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF89B4FA),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () => _copyToClipboard(context, yaml),
                  tooltip: 'Copy to clipboard',
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),

          // YAML content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                yaml,
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFFCDD6F4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String yaml) {
    Clipboard.setData(ClipboardData(text: yaml));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        width: 200,
      ),
    );
  }
}

