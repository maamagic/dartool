import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('UrlUtil encode / decode', () {
    test('encode / decode round-trip', () {
      const input = 'hello world + you';
      expect(UrlUtil.decode(UrlUtil.encode(input)), input);
    });

    test('decode returns fallback on malformed percent', () {
      expect(UrlUtil.decode('%E0%A4%A', fallback: '??'), '??');
    });
  });

  group('UrlUtil query helpers', () {
    test('queryOf extracts query part', () {
      expect(UrlUtil.queryOf('https://a.com/x?y=1&z=2'), 'y=1&z=2');
      expect(UrlUtil.queryOf('https://a.com/x'), '');
    });

    test('parseQuery decodes params', () {
      final m = UrlUtil.parseQuery('a=1&b=hello%20world');
      expect(m, {'a': '1', 'b': 'hello world'});
    });

    test('buildQuery escapes values', () {
      expect(UrlUtil.buildQuery({'a': 1, 'b': 'x y'}), 'a=1&b=x%20y');
    });

    test('appendQuery appends or replaces', () {
      expect(
        UrlUtil.appendQuery('https://a.com/p', {'x': 1}),
        'https://a.com/p?x=1',
      );
      expect(
        UrlUtil.appendQuery('https://a.com/p?x=1', {'y': 2}),
        'https://a.com/p?x=1&y=2',
      );
    });
  });

  group('UrlUtil misc', () {
    test('tryParse returns null on bad input', () {
      expect(UrlUtil.tryParse('not a uri'), isNull);
    });

    test('extensionOf extracts file extension', () {
      expect(UrlUtil.extensionOf('https://a.com/foo/bar.png?v=1'), 'png');
      expect(UrlUtil.extensionOf('https://a.com/foo'), '');
    });
  });
}
