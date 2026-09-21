import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('ValidateUtil', () {
    test('isNull / notNull', () {
      expect(ValidateUtil.isNull(null), isTrue);
      expect(ValidateUtil.isNotNull(1), isTrue);
      expect(() => ValidateUtil.notNull(null), throwsArgumentError);
      expect(() => ValidateUtil.notNull(1), returnsNormally);
    });

    test('  ', () {
      expect(ValidateUtil.isEmail('a@b.com'), isTrue);
      expect(ValidateUtil.isPhone('13812345678'), isTrue);
      expect(ValidateUtil.isUrl('https://x.com'), isTrue);
      expect(ValidateUtil.isIdCard('11010519491231002X'), isTrue);
      expect(ValidateUtil.isNumeric('123'), isTrue);
      expect(ValidateUtil.isBlank('   '), isTrue);
    });

    test(' /  / require', () {
      expect(ValidateUtil.inRange(5, 1, 10), isTrue);
      expect(ValidateUtil.inRange(11, 1, 10), isFalse);
      expect(ValidateUtil.lengthBetween('hello', 3, 6), isTrue);
      expect(ValidateUtil.lengthBetween('hi', 3, 6), isFalse);
      expect(
        () => ValidateUtil.require(false, 'must be true'),
        throwsArgumentError,
      );
      expect(() => ValidateUtil.require(true), returnsNormally);
    });
  });
}
