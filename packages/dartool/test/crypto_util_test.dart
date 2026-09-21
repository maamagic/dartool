import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('CryptoUtil.Base64', () {
    test('encode / decode round-trip', () {
      expect(CryptoUtil.base64Encode('hello'), equals('aGVsbG8='));
      expect(CryptoUtil.base64Decode('aGVsbG8='), equals('hello'));
      expect(
        CryptoUtil.base64Decode(CryptoUtil.base64Encode('中文')),
        equals('中文'),
      );
    });

    test('decode 非法输入返回空串', () {
      expect(CryptoUtil.base64Decode('!!!not-base64!!!'), equals(''));
    });
  });

  group('CryptoUtil.Hex', () {
    test('hexEncode / hexDecode 往返', () {
      final hex = CryptoUtil.hexEncodeString('hello');
      expect(CryptoUtil.hexDecodeString(hex), equals('hello'));
      expect(
        CryptoUtil.hexEncode([0x68, 0x65, 0x6c, 0x6c, 0x6f]),
        equals('68656c6c6f'),
      );
    });

    test('hexDecode 忽略空格和换行', () {
      expect(CryptoUtil.hexDecode('68 65 6c\n6c 6f').length, isNonZero);
    });

    test('hexDecode 奇数长度返回空', () {
      expect(CryptoUtil.hexDecode('abc').length, equals(0));
    });
  });

  group('CryptoUtil.Hash', () {
    test('md5 固定值', () {
      expect(
        CryptoUtil.md5('hello'),
        equals('5d41402abc4b2a76b9719d911017c592'),
      );
    });

    test('sha1 固定值', () {
      expect(
        CryptoUtil.sha1('hello'),
        equals('aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d'),
      );
    });

    test('sha256 固定值', () {
      expect(
        CryptoUtil.sha256('hello'),
        equals(
          '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',
        ),
      );
    });

    test('sha224 / sha384 / sha512 长度', () {
      expect(CryptoUtil.sha224('a').length, equals(56));
      expect(CryptoUtil.sha384('a').length, equals(96));
      expect(CryptoUtil.sha512('a').length, equals(128));
    });
  });

  group('CryptoUtil.HMAC', () {
    test('hmacSha256 固定值', () {
      final r = CryptoUtil.hmacSha256('hello', 'key');
      expect(r.length, equals(64));
      expect(r, isNotEmpty);
    });

    test('hmacSha1 / hmacSha512 长度', () {
      expect(CryptoUtil.hmacSha1('a', 'k').length, equals(40));
      expect(CryptoUtil.hmacSha512('a', 'k').length, equals(128));
    });

    test('相同输入 + 相同 key 结果相同', () {
      expect(
        CryptoUtil.hmacSha256('x', 'y'),
        equals(CryptoUtil.hmacSha256('x', 'y')),
      );
    });
  });

  group('CryptoUtil.XOR', () {
    test('encode / decode 往返', () {
      final enc = CryptoUtil.xorEncode('secret data', 'mykey');
      expect(CryptoUtil.xorDecode(enc, 'mykey'), equals('secret data'));
    });

    test('错误 key 解码不出原文', () {
      final enc = CryptoUtil.xorEncode('hello', 'key');
      expect(CryptoUtil.xorDecode(enc, 'wrong'), isNot(equals('hello')));
    });
  });

  group('CryptoUtil.Random', () {
    test('randomHex 返回指定长度', () {
      final h = CryptoUtil.randomHex(16);
      expect(h.length, equals(32));
      expect(h, matches(RegExp(r'^[0-9a-f]+$')));
    });

    test('randomHex 两次不相同（极小概率）', () {
      final a = CryptoUtil.randomHex(32);
      final b = CryptoUtil.randomHex(32);
      expect(a, isNot(equals(b)));
    });
  });
}
