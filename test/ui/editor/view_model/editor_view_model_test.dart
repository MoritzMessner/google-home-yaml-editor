import 'package:flutter_test/flutter_test.dart';
import 'package:google_home_script_editor/domain/models/automation.dart';
import 'package:google_home_script_editor/ui/editor/view_model/editor_view_model.dart';

void main() {
  group('EditorViewModel.importYaml', () {
    test('replaces the script on valid YAML', () {
      final viewModel = EditorViewModel();
      final success = viewModel.importYaml('''
metadata:
  name: Imported
  description: ""
automations:
  - starters:
      - type: assistant.event.OkGoogle
        eventData: query
        is: Hello
    actions: []
''');

      expect(success, isTrue);
      expect(viewModel.parseError, isNull);
      expect(viewModel.script.metadata.name, 'Imported');
    });

    test('reports the line of a syntax error', () {
      final viewModel = EditorViewModel();
      final success = viewModel.importYaml('metadata:\n  name: [unclosed\n');

      expect(success, isFalse);
      expect(viewModel.parseError, contains('line'));
    });

    test('reports unknown enum values', () {
      final viewModel = EditorViewModel();
      final success = viewModel.importYaml('''
metadata:
  name: Test
  description: ""
automations:
  - starters:
      - type: time.schedule
        at: sunrise
        weekdays:
          - FUNDAY
    actions: []
''');

      expect(success, isFalse);
      expect(viewModel.parseError, contains('FUNDAY'));
    });

    test('keeps the previous script on failure', () {
      final viewModel = EditorViewModel()..updateMetadataName('Keep me');
      viewModel.importYaml('metadata: [unclosed');
      expect(viewModel.script.metadata.name, 'Keep me');
    });
  });

  group('EditorViewModel editing', () {
    test('keeps at least one starter', () {
      final viewModel = EditorViewModel();
      viewModel.removeStarter(0, 0);
      expect(viewModel.script.automations.single.starters, hasLength(1));
    });

    test('moves an action to its final index', () {
      final viewModel = EditorViewModel()
        ..addAction(0, const DelayAction(duration: '1min'))
        ..addAction(0, const DelayAction(duration: '2min'))
        ..addAction(0, const DelayAction(duration: '3min'));

      viewModel.moveAction(0, 0, 2);

      final durations = viewModel.script.automations.single.actions
          .cast<DelayAction>()
          .map((a) => a.duration);
      expect(durations, ['2min', '3min', '1min']);

      viewModel.moveAction(0, 2, 0);
      final restored = viewModel.script.automations.single.actions
          .cast<DelayAction>()
          .map((a) => a.duration);
      expect(restored, ['1min', '2min', '3min']);
    });

    test('item ids follow their items', () {
      final viewModel = EditorViewModel()
        ..addAction(0, const DelayAction(duration: '1min'))
        ..addAction(0, const DelayAction(duration: '2min'))
        ..addAction(0, const DelayAction(duration: '3min'))
        ..addStarter(0);
      final [first, second, third] = viewModel.actionIds(0);

      viewModel
        ..moveAction(0, 0, 2)
        ..removeAction(0, 0)
        ..updateAction(0, 0, const DelayAction(duration: '4min'));

      expect(viewModel.actionIds(0), [third, first]);
      expect(viewModel.starterIds(0), hasLength(2));
      expect({...viewModel.starterIds(0), first, third}, hasLength(4));
    });

    test('replacing the script bumps the revision and renews ids', () {
      final viewModel = EditorViewModel();
      final revision = viewModel.revision;
      final starterIds = viewModel.starterIds(0);

      viewModel.newScript();

      expect(viewModel.revision, greaterThan(revision));
      expect(viewModel.starterIds(0), isNot(starterIds));
    });

    test('yamlOutput reflects metadata changes', () {
      final viewModel = EditorViewModel()..updateMetadataName('Movie: Night');
      expect(viewModel.yamlOutput, contains('name: "Movie: Night"'));
    });
  });
}
