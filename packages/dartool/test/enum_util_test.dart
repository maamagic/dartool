import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

enum Color { red, green, blue }

void main() {
  final values = Color.values;

  group('EnumUtil', () {
    test('byName / byNameOrThrow', () {
      expect(EnumUtil.byName(values, 'green'), Color.green);
      expect(EnumUtil.byName(values, 'pink'), isNull);
      expect(EnumUtil.byNameOrThrow(values, 'blue'), Color.blue);
      expect(() => EnumUtil.byNameOrThrow(values, 'pink'), throwsArgumentError);
    });

    test('byIndex', () {
      expect(EnumUtil.byIndex(values, 0), Color.red);
      expect(EnumUtil.byIndex(values, 99), isNull);
      expect(EnumUtil.byIndex(values, -1), isNull);
    });

    test('names / contains', () {
      expect(EnumUtil.names(values), ['red', 'green', 'blue']);
      expect(EnumUtil.contains(values, 'red'), isTrue);
      expect(EnumUtil.contains(values, 'pink'), isFalse);
    });
  });
}
