import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../view_model/editor_view_model.dart';
import 'visual_editor/visual_editor.dart';
import 'yaml_preview/yaml_preview.dart';

/// Main editor screen with side-by-side visual editor and YAML preview
class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key, required this.viewModel});

  final EditorViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: const _EditorScreenContent(),
    );
  }
}

class _EditorScreenContent extends StatelessWidget {
  const _EditorScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditorViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.home, size: 22),
            const SizedBox(width: 8),
            const Text('Google Home Script Editor'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF444746),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const FaIcon(FontAwesomeIcons.google, size: 16),
              label: const Text('Google Home Web'),
              onPressed: () {
                launchUrl(
                  Uri.parse('https://home.google.com/automations'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Tooltip(
              message: 'Contribute or Issue',
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF444746),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                label: const Text('GitHub'),
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                        'https://github.com/MoritzMessner/google-home-yaml-editor'),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF444746),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.help_outline, size: 18),
              label: const Text('How to use'),
              onPressed: () {
                launchUrl(
                  Uri.parse(
                      'https://github.com/MoritzMessner/google-home-yaml-editor#how-to-use-with-google-home-script-editor'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              onPressed: () => _showImportDialog(context),
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Import YAML'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF444746),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              onPressed: viewModel.newScript,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF444746),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use side-by-side layout for wider screens
          if (constraints.maxWidth >= 800) {
            return Row(
              children: [
                // Visual editor (left panel)
                Expanded(
                  flex: 5,
                  child: Container(
                    child: const VisualEditor(),
                  ),
                ),
                // YAML preview (right panel)
                const Expanded(
                  flex: 4,
                  child: YamlPreview(),
                ),
              ],
            );
          } else {
            // Tab layout for narrower screens
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Visual Editor'),
                      Tab(text: 'YAML'),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        VisualEditor(),
                        YamlPreview(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final viewModel = context.read<EditorViewModel>();
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.upload_file, size: 22),
              SizedBox(width: 8),
              Text('Import YAML'),
            ],
          ),
          content: SizedBox(
            width: 600,
            height: 400,
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                hintText: 'Paste your Google Home automation YAML here...',
                border: OutlineInputBorder(),
              ),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final success = viewModel.importYaml(controller.text);
                Navigator.pop(dialogContext);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Failed to parse YAML. Please check the format.'),
                      backgroundColor: Color(0xFFF38BA8),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('YAML imported successfully!'),
                      backgroundColor: Color(0xFFA6E3A1),
                    ),
                  );
                }
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }
}
