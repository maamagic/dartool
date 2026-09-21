import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('CsvUtil parse', () {
    test('simple rows', () {
      final rows = CsvUtil.parse('a,b,c\n1,2,3');
      expect(rows, [
        ['a', 'b', 'c'],
        ['1', '2', '3'],
      ]);
    });

    test('CRLF and LF both accepted', () {
      expect(CsvUtil.parse('a,b\r\nc,d'), [
        ['a', 'b'],
        ['c', 'd'],
      ]);
      expect(CsvUtil.parse('a,b\nc,d'), [
        ['a', 'b'],
        ['c', 'd'],
      ]);
    });

    test('quoted fields with embedded delimiter', () {
      final rows = CsvUtil.parse('a,"b,c",d');
      expect(rows.single, ['a', 'b,c', 'd']);
    });

    test('escaped double-quotes inside quoted fields', () {
      final rows = CsvUtil.parse('say,"hello ""world"""');
      expect(rows.single, ['say', 'hello "world"']);
    });

    test('quoted fields preserve embedded newlines', () {
      final rows = CsvUtil.parse('a,"b\nc",d');
      expect(rows.single[1], 'b\nc');
    });

    test('empty input → empty list', () {
      expect(CsvUtil.parse(''), isEmpty);
    });

    test('trailing newline does not add empty row', () {
      expect(CsvUtil.parse('a,b\n'), [
        ['a', 'b'],
      ]);
    });

    test('unclosed quote throws by default', () {
      expect(() => CsvUtil.parse('"unclosed'), throwsFormatException);
    });

    test('allowMalformed tolerates unclosed quote', () {
      expect(CsvUtil.parse('"unclosed', allowMalformed: true), [
        ['unclosed'],
      ]);
    });
  });

  group('CsvUtil encode', () {
    test('round-trip with parse', () {
      final rows = [
        ['hello', 'world'],
        ['1', '2', '3'],
      ];
      final encoded = CsvUtil.encode(rows);
      expect(CsvUtil.parse(encoded), rows);
    });

    test('encodes fields needing quotes', () {
      final rows = [
        ['with,comma', 'with"quote', 'with\nnewline'],
      ];
      final encoded = CsvUtil.encode(rows);
      // re-parse to ensure correctness; exact string form isn't asserted
      expect(CsvUtil.parse(encoded), rows);
    });

    test('no trailing newline in single-row output', () {
      final encoded = CsvUtil.encode([
        ['a', 'b'],
      ]);
      expect(encoded, isNot(endsWith('\n')));
    });
  });
}
