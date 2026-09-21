import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as c;

/// Cryptographic utilities: Base64 / Hex encoding, MD5 / SHA hashing, HMAC
/// and simple XOR obfuscation.
///
/// Example:
/// ```dart
/// CryptoUtil.md5('hello');                           // 5d41402abc4b2a76b9719d911017c592
/// CryptoUtil.sha256('hello');                        // 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824
/// CryptoUtil.base64Encode('hello');                  // aGVsbG8=
/// CryptoUtil.hmacSha256('hello', 'key');              // hmac-sha256 hex
/// CryptoUtil.randomHex(16);                          // 32 hex chars
/// ```
abstract final class CryptoUtil {
  CryptoUtil._();

  static String _hexEncode(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  static String _digestToHex(c.Digest d) => _hexEncode(d.bytes);

  // ---------------------------------------------------------------------------
  // Base64
  // ---------------------------------------------------------------------------

  /// Base64 encode a UTF-8 string.
  static String base64Encode(String input) => base64.encode(utf8.encode(input));

  /// Base64 decode a string back to UTF-8. Returns empty string on failure.
  static String base64Decode(String input) {
    try {
      return utf8.decode(base64.decode(input));
    } catch (_) {
      return '';
    }
  }

  // ---------------------------------------------------------------------------
  // Hex
  // ---------------------------------------------------------------------------

  /// Hex-encode bytes to lowercase hex string.
  static String hexEncode(List<int> bytes) => _hexEncode(bytes);

  /// Hex-encode a UTF-8 string to lowercase hex.
  static String hexEncodeString(String input) => hexEncode(utf8.encode(input));

  /// Hex-decode a string back to bytes. Returns empty list on failure.
  static Uint8List hexDecode(String hex) {
    try {
      final clean = hex.replaceAll(' ', '').replaceAll('\n', '');
      if (clean.length.isOdd) {
        throw const FormatException('odd length hex');
      }
      final bytes = Uint8List(clean.length ~/ 2);
      for (var i = 0; i < bytes.length; i++) {
        bytes[i] = int.parse(clean.substring(i * 2, i * 2 + 2), radix: 16);
      }
      return bytes;
    } catch (_) {
      return Uint8List(0);
    }
  }

  /// Hex-decode a hex string to UTF-8. Returns empty string on failure.
  static String hexDecodeString(String hex) =>
      utf8.decode(hexDecode(hex), allowMalformed: true);

  // ---------------------------------------------------------------------------
  // Hash
  // ---------------------------------------------------------------------------

  /// MD5 hash (32 lowercase hex chars).
  static String md5(String input) =>
      _digestToHex(c.md5.convert(utf8.encode(input)));

  /// SHA-1 hash (40 lowercase hex chars).
  static String sha1(String input) =>
      _digestToHex(c.sha1.convert(utf8.encode(input)));

  /// SHA-224 hash (56 lowercase hex chars).
  static String sha224(String input) =>
      _digestToHex(c.sha224.convert(utf8.encode(input)));

  /// SHA-256 hash (64 lowercase hex chars).
  static String sha256(String input) =>
      _digestToHex(c.sha256.convert(utf8.encode(input)));

  /// SHA-384 hash (96 lowercase hex chars).
  static String sha384(String input) =>
      _digestToHex(c.sha384.convert(utf8.encode(input)));

  /// SHA-512 hash (128 lowercase hex chars).
  static String sha512(String input) =>
      _digestToHex(c.sha512.convert(utf8.encode(input)));

  // ---------------------------------------------------------------------------
  // HMAC
  // ---------------------------------------------------------------------------

  static String _hmac(String input, String key, c.Hash algorithm) =>
      _digestToHex(
        c.Hmac(algorithm, utf8.encode(key)).convert(utf8.encode(input)),
      );

  /// HMAC-SHA1.
  static String hmacSha1(String input, String key) => _hmac(input, key, c.sha1);

  /// HMAC-SHA256.
  static String hmacSha256(String input, String key) =>
      _hmac(input, key, c.sha256);

  /// HMAC-SHA512.
  static String hmacSha512(String input, String key) =>
      _hmac(input, key, c.sha512);

  // ---------------------------------------------------------------------------
  // Simple XOR obfuscation (NOT for security  light masking only)
  // ---------------------------------------------------------------------------

  /// XOR-obfuscate a UTF-8 string with a repeating key, returned as Base64.
  static String xorEncode(String input, String key) {
    if (key.isEmpty) return input;
    final ib = utf8.encode(input);
    final kb = utf8.encode(key);
    final out = Uint8List(ib.length);
    for (var i = 0; i < ib.length; i++) {
      out[i] = ib[i] ^ kb[i % kb.length];
    }
    return base64.encode(out);
  }

  /// Reverse of [xorEncode]. Returns original string.
  static String xorDecode(String input, String key) {
    if (key.isEmpty) return input;
    try {
      final ib = base64.decode(input);
      final kb = utf8.encode(key);
      final out = Uint8List(ib.length);
      for (var i = 0; i < ib.length; i++) {
        out[i] = ib[i] ^ kb[i % kb.length];
      }
      return utf8.decode(out);
    } catch (_) {
      return '';
    }
  }

  // ---------------------------------------------------------------------------
  // Random helpers
  // ---------------------------------------------------------------------------

  static final Random _rand = Random.secure();

  /// Generate a random hex string of [length] * 2 hex chars.
  static String randomHex(int length) {
    if (length <= 0) return '';
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = _rand.nextInt(256);
    }
    return _hexEncode(bytes);
  }
}
