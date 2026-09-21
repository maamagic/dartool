import 'date_util.dart';

/// Safe type-conversion utilities with graceful fallbacks  never throws.
///
/// Converts between `int`, `double`, `bool`, `String`, `DateTime` and `List`,
/// picking sensible defaults when parsing fails.
///
/// Example:
/// ```dart
/// ConvertUtil.toInt('42');       // 42
/// ConvertUtil.toInt('abc');      // null
/// ConvertUtil.toBool('yes');     // true
/// ConvertUtil.toDateTime(1700000000000); // DateTime
/// ```
abstract final class ConvertUtil {
  ConvertUtil._();

  /// Convert [v] to `int`. Returns [fallback] on failure.
  static int? toInt(dynamic v, {int? fallback}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is bool) return v ? 1 : 0;
    if (v is String) {
      final t = v.trim();
      if (t.isEmpty) return fallback;
      return int.tryParse(t) ?? fallback;
    }
    return fallback;
  }

  /// Convert [v] to `double`. Returns [fallback] on failure.
  static double? toDouble(dynamic v, {double? fallback}) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is bool) return v ? 1.0 : 0.0;
    if (v is String) {
      final t = v.trim();
      if (t.isEmpty) return fallback;
      return double.tryParse(t) ?? fallback;
    }
    return fallback;
  }

  /// Convert [v] to `bool`. Returns [fallback] on failure (including `null`,
  /// empty strings and unrecognized values).
  ///
  /// Truthy strings: `true`, `1`, `yes`, `y`, `shi`, `是`, `对`.
  /// Falsy strings: `false`, `0`, `no`, `n`, `fou`, `否`, `错`.
  static bool? toBool(dynamic v, {bool? fallback}) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final t = v.trim().toLowerCase();
      if (t.isEmpty) return fallback;
      if (const {'true', '1', 'yes', 'y', 'shi', '是', '对'}.contains(t)) {
        return true;
      }
      if (const {'false', '0', 'no', 'n', 'fou', '否', '错'}.contains(t)) {
        return false;
      }
      return fallback;
    }
    return fallback;
  }

  /// Convert [v] to `String`. Returns [fallback] (default `''`) when input is `null`.
  static String toStringVal(dynamic v, {String fallback = ''}) =>
      v == null ? fallback : v.toString();

  /// Convert [v] to `DateTime`. Accepts `DateTime`, millisecond timestamps,
  /// and parseable strings. Returns [fallback] on failure.
  static DateTime? toDateTime(dynamic v, {DateTime? fallback}) {
    if (v is DateTime) return v;
    if (v is num) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
    if (v is String) {
      final t = v.trim();
      if (t.isEmpty) return fallback;
      return DateTime.tryParse(t) ?? DateUtil.tryParse(t) ?? fallback;
    }
    return fallback;
  }

  /// Convert [v] to `List<T>`. Returns [fallback] (default `[]`) when input is
  /// not a collection.
  static List<T> toList<T>(dynamic v, {List<T>? fallback}) {
    if (v is List) return v.cast<T>();
    if (v is Iterable) return v.cast<T>().toList();
    return fallback ?? <T>[];
  }
}
