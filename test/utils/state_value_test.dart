import 'package:flutter_test/flutter_test.dart';
import 'package:google_home_script_editor/utils/state_value.dart';

void main() {
  group('parseStateValue', () {
    test('parses integers', () => expect(parseStateValue('21'), 21));
    test('parses negative numbers', () => expect(parseStateValue('-5'), -5));
    test('parses decimals', () => expect(parseStateValue('21.5'), 21.5));
    test('parses booleans', () {
      expect(parseStateValue('true'), true);
      expect(parseStateValue('False'), false);
    });
    test('trims surrounding whitespace', () {
      expect(parseStateValue(' 50 '), 50);
    });
    test('keeps other text as string', () {
      expect(parseStateValue('heat'), 'heat');
      expect(parseStateValue('MEDIUM'), 'MEDIUM');
      expect(parseStateValue(''), '');
    });
  });
}
