import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('JsonUtil.encode', () {
    test('encode simple values', () {
      expect(JsonUtil.encode({'a': 1}), '{"a":1}');
      expect(JsonUtil.encode([1, 2, 3]), '[1,2,3]');
      expect(JsonUtil.encode(null), isNull);
    });

    test('pretty print uses indentation', () {
      final out = JsonUtil.encode({
        'a': 1,
        'b': [2, 3],
      }, pretty: true);
      expect(out, contains('\n'));
      expect(out, contains('  '));
    });
  });

  group('JsonUtil.decode', () {
    test('returns map / list / scalar', () {
      expect(JsonUtil.decode('{"a":1}'), {'a': 1});
      expect(JsonUtil.decode('[1,2]'), [1, 2]);
      expect(JsonUtil.decode('"hi"'), 'hi');
    });

    test('returns fallback on invalid input', () {
      expect(JsonUtil.decode('not-json', fallback: 'x'), 'x');
      expect(JsonUtil.decode('', fallback: 42), 42);
      expect(JsonUtil.decode(null), isNull);
    });

    test('decodeMap / decodeList', () {
      expect(JsonUtil.decodeMap('{"a":1}'), isA<Map<String, dynamic>>());
      expect(JsonUtil.decodeList('[1,2]'), isA<List<dynamic>>());
      expect(
        JsonUtil.decodeMap('bad', fallback: <String, dynamic>{}),
        <String, dynamic>{},
      );
      expect(
        JsonUtil.decodeList('bad', fallback: const <dynamic>[]),
        const <dynamic>[],
      );
    });
  });

  group('JsonUtil.pretty / isValid', () {
    test('pretty indents valid JSON', () {
      final p = JsonUtil.pretty('{"a":1,"b":[2,3]}');
      expect(p, contains('\n'));
      expect(p, contains('  "a"'));
    });

    test('pretty returns original on invalid JSON', () {
      expect(JsonUtil.pretty('not-json'), 'not-json');
    });

    test('isValid', () {
      expect(JsonUtil.isValid('{"a":1}'), isTrue);
      expect(JsonUtil.isValid('[1,2]'), isTrue);
      expect(JsonUtil.isValid(''), isFalse);
      expect(JsonUtil.isValid(null), isFalse);
      expect(JsonUtil.isValid('not-json'), isFalse);
    });
  });
}
