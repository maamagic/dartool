import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('RegexUtil 常用正则', () {
    test('email', () {
      expect(RegexUtil.isEmail('user@example.com'), isTrue);
      expect(RegexUtil.isEmail('a.b+c@sub.domain.org'), isTrue);
      expect(RegexUtil.isEmail('not-an-email'), isFalse);
    });

    test('phone', () {
      expect(RegexUtil.isPhone('13812345678'), isTrue);
      expect(RegexUtil.isPhone('12345'), isFalse);
    });

    test('url', () {
      expect(RegexUtil.isUrl('https://example.com/path?q=1'), isTrue);
      expect(RegexUtil.isUrl('ftp://x.com'), isFalse);
    });

    test('idCard', () {
      expect(RegexUtil.isIdCard('11010519491231002X'), isTrue);
      expect(RegexUtil.isIdCard('123'), isFalse);
    });

    test('ipv4 / chinese / number', () {
      expect(RegexUtil.isIpv4('192.168.1.1'), isTrue);
      expect(RegexUtil.isIpv4('999.1.1.1'), isFalse);
      expect(RegexUtil.isChinese('你好世界'), isTrue);
      expect(RegexUtil.isNumber('-12.5'), isTrue);
      expect(RegexUtil.isNumber('12a'), isFalse);
    });
  });

  group('RegexUtil 提取', () {
    test('matches / extract', () {
      expect(RegexUtil.matches('a1b22', RegExp(r'\d+')), ['1', '22']);
      expect(
        RegexUtil.extract('order 123 done', RegExp(r'order (\d+)')),
        '123',
      );
      expect(RegexUtil.extract('nothing', RegExp(r'order (\d+)')), isNull);
    });
  });
}
