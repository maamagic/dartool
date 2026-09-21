import 'dart:convert' show utf8;
import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('HexUtil', () {
    test('encode produces lowercase hex', () {
      expect(HexUtil.encode(const [0x00, 0xFF, 0xAB, 0x12]), '00ffab12');
      expect(HexUtil.encode(const <int>[]), '');
    });

    test('decode is inverse of encode', () {
      const bytes = [1, 2, 3, 4, 15, 16, 127, 128, 255];
      expect(HexUtil.decode(HexUtil.encode(bytes)), bytes);
    });

    test('decode accepts uppercase', () {
      expect(HexUtil.decode('DEADBEEF'), [0xDE, 0xAD, 0xBE, 0xEF]);
      expect(HexUtil.decode('DeadBeef'), [0xDE, 0xAD, 0xBE, 0xEF]);
    });

    test('decode throws on odd length / invalid chars', () {
      expect(() => HexUtil.decode('abc'), throwsFormatException);
      expect(() => HexUtil.decode('zz'), throwsFormatException);
    });

    test('stripPrefix removes 0x / 0X', () {
      expect(HexUtil.stripPrefix('0xff'), 'ff');
      expect(HexUtil.stripPrefix('0XFF'), 'FF');
      expect(HexUtil.stripPrefix('ff'), 'ff');
    });

    test('isValid', () {
      expect(HexUtil.isValid('ff00AA'), isTrue);
      expect(HexUtil.isValid('ff0'), isFalse);
      expect(HexUtil.isValid(null), isFalse);
      expect(HexUtil.isValid(''), isFalse);
    });
  });

  group('Base64Util', () {
    test('round-trip bytes', () {
      final original = utf8.encode('hello world ');
      final encoded = Base64Util.encode(original);
      expect(Base64Util.decode(encoded), original);
    });

    test('encodeString / decodeString round-trip UTF-8', () {
      const text = 'dartool   encoding test';
      final b64 = Base64Util.encodeString(text);
      expect(Base64Util.decodeString(b64), text);
    });

    test('decode tolerates whitespace', () {
      final b64 = 'SGVs\nbG8g V29ybGQ=';
      expect(Base64Util.decodeString(b64), 'Hello World');
    });
  });
}
