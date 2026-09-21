import 'dart:convert';

/// JSON encode / decode utilities with safe fallbacks and pretty printing.
///
/// Uses `dart:convert` from the standard library  no extra dependencies.
abstract final class JsonUtil {
  JsonUtil._();

  /// Encode [value] to a JSON string.
  ///
  /// Returns `null` when [value] is `null`. Set [pretty] to `true` for
  /// indented output (2-space indentation).
  static String? encode(Object? value, {bool pretty = false}) {
    if (value == null) return null;
    final encoder = pretty ? JsonEncoder.withIndent('  ') : const JsonEncoder();
    return encoder.convert(value);
  }

  /// Safely decode a JSON string; returns [fallback] on any failure.
  static dynamic decode(String? source, {dynamic fallback}) {
    if (source == null || source.trim().isEmpty) return fallback;
    try {
      return json.decode(source);
    } catch (_) {
      return fallback;
    }
  }

  /// Decode [source] as a `Map<String, dynamic>`, or [fallback] on failure.
  static Map<String, dynamic>? decodeMap(
    String? source, {
    Map<String, dynamic>? fallback,
  }) {
    final r = decode(source, fallback: fallback);
    if (r is Map<String, dynamic>) return r;
    if (r is Map) return Map<String, dynamic>.from(r);
    return fallback;
  }

  /// Decode [source] as a `List<dynamic>`, or [fallback] on failure.
  static List<dynamic>? decodeList(String? source, {List<dynamic>? fallback}) {
    final r = decode(source, fallback: fallback);
    if (r is List<dynamic>) return r;
    if (r is List) return List<dynamic>.from(r);
    return fallback;
  }

  /// Pretty-print a JSON string (indent with 2 spaces).
  ///
  /// Returns the original [source] unchanged if parsing fails.
  static String pretty(String source) {
    final obj = decode(source);
    if (obj == null) return source;
    return const JsonEncoder.withIndent('  ').convert(obj);
  }

  /// Whether [source] parses as valid JSON.
  static bool isValid(String? source) {
    if (source == null || source.trim().isEmpty) return false;
    try {
      json.decode(source);
      return true;
    } catch (_) {
      return false;
    }
  }
}
