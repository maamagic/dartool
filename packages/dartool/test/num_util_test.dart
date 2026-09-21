import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('NumUtil clamp / mapRange', () {
    test('clamp keeps value within bounds', () {
      expect(NumUtil.clamp<int>(5, 0, 10), 5);
      expect(NumUtil.clamp<int>(-1, 0, 10), 0);
      expect(NumUtil.clamp<int>(20, 0, 10), 10);
    });

    test('mapRange linearly maps values', () {
      expect(NumUtil.mapRange(50, 0, 100, 0, 1), 0.5);
      expect(NumUtil.mapRange(0, 0, 100, 10, 20), 10.0);
    });
  });

  group('NumUtil round / floor / ceil', () {
    test('round to decimal places', () {
      expect(NumUtil.round(3.1415, decimal: 2), 3.14);
      expect(NumUtil.round(1234.0, decimal: -2), 1200.0);
      expect(NumUtil.floor(3.99, decimal: 0), 3.0);
      expect(NumUtil.ceil(3.01, decimal: 0), 4.0);
    });
  });

  group('NumUtil min/max/sum/average', () {
    test('works on non-empty list', () {
      expect(NumUtil.min([3, 1, 2]), 1);
      expect(NumUtil.max([3, 1, 2]), 3);
      expect(NumUtil.sum([1, 2, 3]), 6);
      expect(NumUtil.average([1, 2, 3]), 2.0);
    });

    test('empty handling', () {
      expect(NumUtil.min<int>([]), isNull);
      expect(NumUtil.max<int>([]), isNull);
      expect(NumUtil.sum<int>([]), 0);
      expect(NumUtil.average([]), 0.0);
    });
  });

  group('NumUtil parse', () {
    test('parseInt / parseDouble returns fallback', () {
      expect(NumUtil.parseInt('abc', fallback: -1), -1);
      expect(NumUtil.parseInt('  42  '), 42);
      expect(NumUtil.parseDouble('3.14'), 3.14);
      expect(NumUtil.parseDouble(null), isNull);
    });
  });

  group('NumUtil format', () {
    test('formatThousand adds separators', () {
      expect(NumUtil.formatThousand(1234567), '1,234,567');
      expect(NumUtil.formatThousand(1234.5, fractionalDigits: 2), '1,234.50');
      expect(NumUtil.formatThousand(-1234), '-1,234');
    });

    test('formatBytes scales units', () {
      expect(NumUtil.formatBytes(0), '0 B');
      expect(NumUtil.formatBytes(1023), '1023 B');
      expect(NumUtil.formatBytes(1536), '1.5 KB');
      expect(NumUtil.formatBytes(1024 * 1024), '1.0 MB');
    });
  });
}
