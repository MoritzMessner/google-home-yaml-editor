import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_home_script_editor/domain/models/automation.dart';
import 'package:google_home_script_editor/ui/editor/view_model/editor_view_model.dart';
import 'package:google_home_script_editor/ui/editor/widgets/visual_editor/visual_editor.dart';
import 'package:provider/provider.dart';

Future<void> _pumpEditor(WidgetTester tester, EditorViewModel viewModel) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider.value(
          value: viewModel,
          child: const VisualEditor(),
        ),
      ),
    ),
  );
}

/// Texts currently shown in editable text fields.
List<String> _fieldTexts(WidgetTester tester) => tester
    .widgetList<EditableText>(find.byType(EditableText))
    .map((e) => e.controller.text)
    .toList();

void main() {
  testWidgets('removing an action keeps the remaining fields in sync',
      (tester) async {
    final viewModel = EditorViewModel()
      ..addAction(0, const DelayAction(duration: '1min'))
      ..addAction(0, const DelayAction(duration: '2min'));
    await _pumpEditor(tester, viewModel);
    expect(_fieldTexts(tester), containsAll(['1min', '2min']));

    viewModel.removeAction(0, 0);
    await tester.pump();

    expect(_fieldTexts(tester), contains('2min'));
    expect(_fieldTexts(tester), isNot(contains('1min')));
  });

  testWidgets('moving an action moves its field values', (tester) async {
    final viewModel = EditorViewModel()
      ..addAction(0, const DelayAction(duration: '1min'))
      ..addAction(0, const DelayAction(duration: '2min'));
    await _pumpEditor(tester, viewModel);

    viewModel.moveAction(0, 0, 1);
    await tester.pump();

    final texts = _fieldTexts(tester);
    expect(texts.indexOf('2min'), lessThan(texts.indexOf('1min')));
  });

  testWidgets('removing a starter keeps the remaining fields in sync',
      (tester) async {
    final viewModel = EditorViewModel()
      ..updateStarter(0, 0, const OkGoogleStarter(eventData: 'first'))
      ..addStarter(0)
      ..updateStarter(0, 1, const OkGoogleStarter(eventData: 'second'));
    await _pumpEditor(tester, viewModel);

    viewModel.removeStarter(0, 0);
    await tester.pump();

    expect(_fieldTexts(tester), contains('second'));
    expect(_fieldTexts(tester), isNot(contains('first')));
  });

  testWidgets('importing YAML updates all fields', (tester) async {
    final viewModel = EditorViewModel()
      ..updateMetadataName('Old name')
      ..updateStarter(0, 0, const OkGoogleStarter(eventData: 'old query'));
    await _pumpEditor(tester, viewModel);

    viewModel.importYaml('''
metadata:
  name: New name
  description: ""
automations:
  - starters:
      - type: assistant.event.OkGoogle
        eventData: query
        is: new query
    actions: []
''');
    await tester.pump();

    final texts = _fieldTexts(tester);
    expect(texts, containsAll(['New name', 'new query']));
    expect(texts, isNot(contains('Old name')));
    expect(texts, isNot(contains('old query')));
  });

  testWidgets('numbers and booleans typed as state values stay typed',
      (tester) async {
    final viewModel = EditorViewModel()
      ..updateStarter(
        0,
        0,
        const DeviceStateStarter(device: 'Thermostat', state: 'temp', is_: ''),
      );
    await _pumpEditor(tester, viewModel);

    final valueField = find.widgetWithText(TextFormField, 'Value');
    await tester.enterText(valueField, '21');
    await tester.pump();
    expect(viewModel.yamlOutput, contains('is: 21\n'));

    await tester.enterText(valueField, 'true');
    await tester.pump();
    expect(viewModel.yamlOutput, contains('is: true\n'));
  });

  testWidgets('typing keeps focus on the edited field', (tester) async {
    final viewModel = EditorViewModel()
      ..addAction(0, const DelayAction(duration: '1min'));
    await _pumpEditor(tester, viewModel);

    final field = find.widgetWithText(TextFormField, '1min');
    await tester.enterText(field, '15min');
    await tester.pump();

    final editable = tester.widget<EditableText>(
      find.descendant(
        of: find.widgetWithText(TextFormField, '15min'),
        matching: find.byType(EditableText),
      ),
    );
    expect(editable.focusNode.hasFocus, isTrue);
    expect(
      (viewModel.script.automations.single.actions.single as DelayAction)
          .duration,
      '15min',
    );
  });
}
