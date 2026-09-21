import 'package:dartool/src/regex_util.dart';
import 'package:dartool/src/str_util.dart';

/// Data validation utilities: null / blank checks, email / phone / URL /
/// ID card format checks, range / length checks, and mandatory
/// [require] assertions.
///
/// Example:
/// ```dart
/// ValidateUtil.isEmail('a@b.com');        // true
/// ValidateUtil.isPhone('13800138000');    // true
/// ValidateUtil.inRange(5, 0, 10);         // true
/// ValidateUtil.notNull(value);            // throws if null
/// ```
abstract final class ValidateUtil {
  ValidateUtil._();

  /// Whether [v] is `null`.
  static bool isNull(Object? v) => v == null;

  /// Whether [v] is NOT `null`.
  static bool isNotNull(Object? v) => v != null;

  /// Assert [v] is non-null; throws [ArgumentError] otherwise.
  static void notNull(Object? v, [String? name]) {
    if (v == null) throw ArgumentError.notNull(name ?? 'value');
  }

  /// Whether [v] is blank (null / empty / whitespace only).
  static bool isBlank(String? v) => StrUtil.isBlank(v);

  /// Whether [v] is non-blank.
  static bool isNotBlank(String? v) => StrUtil.isNotBlank(v);

  /// Whether [v] is an email.
  static bool isEmail(String v) => RegexUtil.isEmail(v);

  /// Whether [v] is a Mainland China mobile number.
  static bool isPhone(String v) => RegexUtil.isPhone(v);

  /// Whether [v] is a URL.
  static bool isUrl(String v) => RegexUtil.isUrl(v);

  /// Whether [v] is a Mainland China ID card (format only).
  static bool isIdCard(String v) => RegexUtil.isIdCard(v);

  /// Whether [v] is a numeric string.
  static bool isNumeric(String v) => StrUtil.isNumeric(v);

  /// Whether [v] is within the closed interval `[min, max]`.
  static bool inRange(num v, num min, num max) => v >= min && v <= max;

  /// Whether [v]'s length is within the closed interval `[min, max]`.
  static bool lengthBetween(String v, int min, int max) =>
      v.length >= min && v.length <= max;

  /// Assert [condition] is `true`; throws [ArgumentError] otherwise.
  static void require(bool condition, [String? message]) {
    if (!condition) {
      throw ArgumentError(message ?? 'validation failed');
    }
  }
}
