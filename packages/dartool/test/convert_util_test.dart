import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('ConvertUtil', () {
    test('toInt', () {
      expect(ConvertUtil.toInt(3.7), 3);
      expect(ConvertUtil.toInt('42'), 42);
      expect(ConvertUtil.toInt(true), 1);
      expect(ConvertUtil.toInt('abc'), isNull);
      expect(ConvertUtil.toInt('abc', fallback: 0), 0);
      expect(ConvertUtil.toInt('  '), isNull);
    });

    test('toDouble', () {
      expect(ConvertUtil.toDouble('3.14'), 3.14);
      expect(ConvertUtil.toDouble(2), 2.0);
      expect(ConvertUtil.toDouble('x', fallback: 0.5), 0.5);
    });

    test('toBool', () {
      expect(ConvertUtil.toBool('true'), isTrue);
      expect(ConvertUtil.toBool(1), isTrue);
      expect(ConvertUtil.toBool(0), isFalse);
      expect(ConvertUtil.toBool('maybe'), isNull);
      expect(ConvertUtil.toBool('maybe', fallback: false), isFalse);
    });

    test('toBool Chinese and pinyin tokens', () {
      expect(ConvertUtil.toBool('shi'), isTrue);
      expect(ConvertUtil.toBool('是'), isTrue);
      expect(ConvertUtil.toBool('对'), isTrue);
      expect(ConvertUtil.toBool('fou'), isFalse);
      expect(ConvertUtil.toBool('否'), isFalse);
      expect(ConvertUtil.toBool('错'), isFalse);
      expect(ConvertUtil.toBool(' TRUE '), isTrue);
    });

    test('toBool empty and null fall back', () {
      expect(ConvertUtil.toBool(''), isNull);
      expect(ConvertUtil.toBool('', fallback: true), isTrue);
      expect(ConvertUtil.toBool(null), isNull);
      expect(ConvertUtil.toBool(null, fallback: false), isFalse);
    });

    test('toStringVal', () {
      expect(ConvertUtil.toStringVal(123), '123');
      expect(ConvertUtil.toStringVal(null), '');
      expect(ConvertUtil.toStringVal(null, fallback: 'x'), 'x');
    });

    test('toDateTime', () {
      expect(
        ConvertUtil.toDateTime('2026-09-21 14:05:07'),
        DateTime(2026, 9, 21, 14, 5, 7),
      );
      expect(ConvertUtil.toDateTime('bad'), isNull);
    });

    test('toList', () {
      expect(ConvertUtil.toList<int>([1, 2]), [1, 2]);
      expect(ConvertUtil.toList<int>('x'), isEmpty);
    });
  });
}
