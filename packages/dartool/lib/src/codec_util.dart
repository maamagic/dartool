/// Hexadecimal and Base64 encoding / decoding.
///
/// Hex is zero-dep; Base64 wraps `dart:convert` with a few convenience APIs.
import 'dart:convert' show base64, utf8;

class HexUtil {
  HexUtil._();

  static const _hex = '0123456789abcdef';

  static String encode(List<int> bytes) {
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(_hex[(b >> 4) & 0xF]);
      sb.write(_hex[b & 0xF]);
    }
    return sb.toString();
  }

  static List<int> decode(String hex) {
    if (hex.isEmpty) return const <int>[];
    if (hex.length.isOdd) {
      throw FormatException('Hex string must have even length', hex);
    }
    final out = List<int>.filled(hex.length ~/ 2, 0);
    for (var i = 0; i < out.length; i++) {
      final hi = _nibble(hex.codeUnitAt(i * 2), hex, i * 2);
      final lo = _nibble(hex.codeUnitAt(i * 2 + 1), hex, i * 2 + 1);
      out[i] = (hi << 4) | lo;
    }
    return out;
  }

  static String stripPrefix(String source) {
    if (source.length >= 2 &&
        source[0] == '0' &&
        (source[1] == 'x' || source[1] == 'X')) {
      return source.substring(2);
    }
    return source;
  }

  static bool isValid(String? hex) {
    if (hex == null || hex.isEmpty) return false;
    if (hex.length.isOdd) return false;
    for (final c in hex.codeUnits) {
      final valid =
          (c >= 0x30 && c <= 0x39) ||
          (c >= 0x41 && c <= 0x46) ||
          (c >= 0x61 && c <= 0x66);
      if (!valid) return false;
    }
    return true;
  }

  static int _nibble(int c, String hex, int index) {
    if (c >= 0x30 && c <= 0x39) return c - 0x30;
    if (c >= 0x41 && c <= 0x46) return c - 0x41 + 10;
    if (c >= 0x61 && c <= 0x66) return c - 0x61 + 10;
    throw FormatException('Invalid hex character', hex, index);
  }
}

class Base64Util {
  Base64Util._();

  static String encode(List<int> bytes) => base64.encode(bytes);

  static String encodeString(String string) =>
      base64.encode(utf8.encode(string));

  static List<int> decode(String string) {
    final cleaned = string.replaceAll(RegExp(r'\s'), '');
    return base64.decode(cleaned);
  }

  static String decodeString(String string) {
    final bytes = decode(string);
    return utf8.decode(bytes);
  }
}
