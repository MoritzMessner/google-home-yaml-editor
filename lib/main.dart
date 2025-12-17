import 'package:flutter/material.dart';

import 'ui/core/themes/app_theme.dart';
import 'ui/editor/view_model/editor_view_model.dart';
import 'ui/editor/widgets/editor_screen.dart';

void main() {
  runApp(const GoogleHomeScriptEditorApp());
}

class GoogleHomeScriptEditorApp extends StatelessWidget {
  const GoogleHomeScriptEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Home Script Editor',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: EditorScreen(viewModel: EditorViewModel()),
    );
  }
}



