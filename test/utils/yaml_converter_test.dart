import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_home_script_editor/domain/models/automation.dart';
import 'package:google_home_script_editor/utils/yaml_converter.dart';
import 'package:yaml/yaml.dart';

AutomationScript _scriptWith({
  String name = 'Test',
  String description = 'Description',
  String query = 'Hello',
  List<String> devices = const ['Lamp'],
}) {
  return AutomationScript(
    metadata: Metadata(name: name, description: description),
    automations: [
      Automation(
        starters: [OkGoogleStarter(eventData: query)],
        condition: null,
        actions: [OnOffAction(devices: devices, on: true)],
      ),
    ],
  );
}

AutomationScript _roundTrip(AutomationScript script) {
  final yaml = YamlConverter.toYaml(script);
  final parsed = YamlConverter.fromYaml(yaml);
  expect(parsed, isNotNull, reason: 'Generated YAML failed to parse:\n$yaml');
  return parsed!;
}

void main() {
  // Strings that are valid in the editor but have special meaning in YAML.
  const trickyStrings = [
    'Movie: Night',
    '# not a comment',
    'trailing ',
    ' leading',
    'true',
    'false',
    'null',
    '~',
    'yes',
    'On',
    'off',
    '123',
    '1.50',
    '007',
    '0x1F',
    '- Lamp',
    '[Lamp]',
    '{Lamp}',
    '*Lamp',
    '&Lamp',
    '!Lamp',
    '|Lamp',
    '>Lamp',
    '%Lamp',
    '@Lamp',
    '`Lamp',
    "It's",
    'Say "hi"',
    r'C:\path\to',
    'line one\nline two',
    'tab\there',
    'Lamp, Kitchen',
    'Lamp ?',
    'zero\u0000width',
    'next\u0085line',
    'c1\u009Fcontrol',
    'byte\uFEFForder',
    'non\uFFFEchar',
  ];

  group('YamlConverter quoting', () {
    for (final value in trickyStrings) {
      test('round-trips metadata name ${_describe(value)}', () {
        final parsed = _roundTrip(_scriptWith(name: value));
        expect(parsed.metadata.name, value);
      });

      test('round-trips metadata description ${_describe(value)}', () {
        final parsed = _roundTrip(_scriptWith(description: value));
        expect(parsed.metadata.description, value);
      });

      test('round-trips OK Google query ${_describe(value)}', () {
        final parsed = _roundTrip(_scriptWith(query: value));
        final starter = parsed.automations.single.starters.single;
        expect(starter, isA<OkGoogleStarter>());
        expect((starter as OkGoogleStarter).eventData, value);
      });

      test('round-trips device name ${_describe(value)}', () {
        final parsed = _roundTrip(_scriptWith(devices: [value]));
        final action = parsed.automations.single.actions.single;
        expect(action, isA<OnOffAction>());
        expect((action as OnOffAction).devices, [value]);
      });
    }

    test('device names stay strings in the generated YAML', () {
      final yaml = YamlConverter.toYaml(
        _scriptWith(devices: ['true', '123', 'null']),
      );
      final doc = loadYaml(yaml) as YamlMap;
      final devices = doc['automations'][0]['actions'][0]['devices'] as List;
      expect(devices, everyElement(isA<String>()));
    });
  });

  group('YamlConverter examples', () {
    final examples = Directory('examples')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.yaml'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    test('examples directory is not empty', () {
      expect(examples, isNotEmpty);
    });

    for (final file in examples) {
      test('parses and stably re-serializes ${file.path}', () {
        final parsed = YamlConverter.fromYaml(file.readAsStringSync());
        expect(parsed, isNotNull);

        final first = YamlConverter.toYaml(parsed!);
        expect(() => loadYaml(first), returnsNormally);

        final second = YamlConverter.toYaml(YamlConverter.fromYaml(first)!);
        expect(second, first);
      });

      test('keeps every field of ${file.path}', () {
        final source = file.readAsStringSync();
        final output = YamlConverter.toYaml(YamlConverter.fromYaml(source)!);
        expect(_normalize(loadYaml(output)), _normalize(loadYaml(source)));
      });
    }
  });

  group('YamlConverter colors', () {
    test('writes color temperature in Kelvin notation', () {
      const script = AutomationScript(
        metadata: Metadata(name: 'Test', description: ''),
        automations: [
          Automation(
            starters: [OkGoogleStarter(eventData: 'Warm')],
            condition: null,
            actions: [
              ColorAbsoluteAction(devices: ['Lamp'], temperature: 2700),
            ],
          ),
        ],
      );

      final yaml = YamlConverter.toYaml(script);
      expect(yaml, contains('temperature: 2700K'));

      final action = _roundTrip(script).automations.single.actions.single
          as ColorAbsoluteAction;
      expect(action.temperature, 2700);
    });
  });

  group('YamlConverter times and weekdays', () {
    test('round-trips schedule time and weekdays', () {
      const script = AutomationScript(
        metadata: Metadata(name: 'Test', description: ''),
        automations: [
          Automation(
            starters: [
              TimeScheduleStarter(
                at: '6:00 pm',
                weekdays: [Weekday.monday, Weekday.friday],
              ),
            ],
            condition: TimeBetweenCondition(after: '18:00', before: '23:59'),
            actions: [DelayAction(duration: '5min')],
          ),
        ],
      );

      final parsed = _roundTrip(script).automations.single;
      final starter = parsed.starters.single as TimeScheduleStarter;
      expect(starter.at, '6:00 pm');
      expect(starter.weekdays, [Weekday.monday, Weekday.friday]);

      final condition = parsed.condition as TimeBetweenCondition;
      expect(condition.after, '18:00');
      expect(condition.before, '23:59');

      expect((parsed.actions.single as DelayAction).duration, '5min');
    });

    test('accepts short and full weekday names', () {
      const yaml = '''
metadata:
  name: Test
  description: ""
automations:
  - starters:
      - type: time.schedule
        at: sunrise
        weekdays:
          - MON
          - TUESDAY
          - wednesday
    actions: []
''';
      final starter = YamlConverter.fromYaml(yaml)!
          .automations
          .single
          .starters
          .single as TimeScheduleStarter;
      expect(
        starter.weekdays,
        [Weekday.monday, Weekday.tuesday, Weekday.wednesday],
      );
    });
  });

  group('YamlConverter unsupported content', () {
    List<String> warningsFor(String automation) {
      final warnings = <String>[];
      final script = YamlConverter.fromYaml(
        'metadata:\n  name: T\n  description: ""\nautomations:\n$automation',
        onWarning: warnings.add,
      );
      expect(script, isNotNull);
      return warnings;
    }

    test('keeps automation names', () {
      const yaml = '''
metadata:
  name: T
  description: ""
automations:
  - name: Movie Night an
    starters:
      - type: assistant.event.OkGoogle
        eventData: query
        is: Filmabend
    actions: []
  - starters:
      - type: assistant.event.OkGoogle
        eventData: query
        is: Ende
    actions: []
''';
      final script = YamlConverter.fromYaml(yaml)!;
      expect(script.automations.map((a) => a.name), ['Movie Night an', null]);

      final output = YamlConverter.toYaml(script);
      expect(output, contains('  - name: Movie Night an\n    starters:\n'));
      expect(output, contains('  - starters:\n'));
      expect(YamlConverter.fromYaml(output)!.automations.first.name,
          'Movie Night an');
    });

    test('keeps the trait of generic device.state starters', () {
      const yaml = '''
metadata:
  name: T
  description: ""
automations:
  - starters:
      - type: device.state.MediaState
        device: TV
        state: playbackState
        is: PLAYING
    condition:
      type: device.state.Volume
      device: Speaker
      state: currentVolume
      is: 10
    actions: []
''';
      final output = YamlConverter.toYaml(YamlConverter.fromYaml(yaml)!);
      expect(output, contains('type: device.state.MediaState'));
      expect(output, contains('type: device.state.Volume'));
    });

    test('warns about dropped actions', () {
      final warnings = warningsFor('''
  - starters:
      - type: assistant.event.OkGoogle
        eventData: query
        is: Hi
    actions:
      - type: device.command.SomethingNew
        devices: [Lamp]
''');
      expect(warnings, [contains('device.command.SomethingNew')]);
    });

    test('warns about dropped starters', () {
      final warnings = warningsFor('''
  - starters:
      - type: device.event.SomethingNew
        device: Doorbell
    actions: []
''');
      expect(warnings, [contains('device.event.SomethingNew')]);
    });

    test('warns about logical conditions', () {
      final warnings = warningsFor('''
  - starters:
      - type: assistant.event.OkGoogle
        eventData: query
        is: Hi
    condition:
      type: and
      conditions:
        - type: time.between
          after: sunset
    actions: []
''');
      expect(warnings, [contains('and')]);
    });

    test('warns about unsupported comparison fields', () {
      final warnings = warningsFor('''
  - starters:
      - type: assistant.event.OkGoogle
        eventData: query
        is: Hi
        suppressFor: 1hour
    condition:
      type: device.state.Volume
      device: Speaker
      state: currentVolume
      greaterThan: 10
    actions: []
''');
      expect(warnings, hasLength(2));
      expect(warnings, contains(contains('suppressFor')));
      expect(warnings, contains(contains('greaterThan')));
    });

    test('examples import without warnings', () {
      for (final file in Directory('examples')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.yaml'))) {
        final warnings = <String>[];
        YamlConverter.fromYaml(
          file.readAsStringSync(),
          onWarning: warnings.add,
        );
        expect(warnings, isEmpty, reason: file.path);
      }
    });
  });

  group('YamlConverter.fromYaml', () {
    test('reports the underlying error through onError', () {
      Object? error;
      YamlConverter.fromYaml('metadata: [unclosed', onError: (e) => error = e);
      expect(error, isNotNull);
    });

    test('returns null for invalid YAML', () {
      expect(YamlConverter.fromYaml('metadata: [unclosed'), isNull);
    });

    test('returns null for empty input', () {
      expect(YamlConverter.fromYaml(''), isNull);
    });
  });
}

/// Converts parsed YAML to plain maps and lists with string scalars, so
/// that `80` and `"80"` compare equal.
Object? _normalize(Object? node) => switch (node) {
      Map() => {
          for (final e in node.entries) e.key.toString(): _normalize(e.value),
        },
      List() => [for (final e in node) _normalize(e)],
      null => null,
      _ => node.toString(),
    };

/// Test name for [value] with invisible characters spelled out.
String _describe(String value) {
  final visible = value.runes.map((rune) {
    final invisible =
        rune < 0x20 || (rune >= 0x7F && rune <= 0x9F) || rune >= 0xFEFF;
    return invisible
        ? '\\u{${rune.toRadixString(16)}}'
        : String.fromCharCode(rune);
  }).join();
  return '"$visible"';
}
