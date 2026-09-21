/// String utilities.
///
/// Null-safe helpers for blank-checking, case conversion, naming-style
/// conversion (camelCase / snake_case / kebab-case), padding, truncation,
/// masking, and more. All methods handle `null` gracefully.
abstract final class StrUtil {
  StrUtil._();

  /// Whether [str] is `null`, empty, or consists only of whitespace.
  static bool isBlank(String? str) => str == null || str.trim().isEmpty;

  /// Whether [str] is non-blank (inverse of [isBlank]).
  static bool isNotBlank(String? str) => !isBlank(str);

  /// Whether [str] is `null` or the empty string `''` (whitespace is NOT ignored).
  static bool isEmpty(String? str) => str == null || str.isEmpty;

  /// Whether [str] is non-empty (inverse of [isEmpty]).
  static bool isNotEmpty(String? str) => !isEmpty(str);

  /// Whether [str] contains only decimal digits `0-9`.
  static bool isNumeric(String? str) {
    if (isBlank(str)) return false;
    return str!.trim().runes.every((r) => r >= 0x30 && r <= 0x39);
  }

  /// Null-safe uppercase conversion; returns `''` when input is `null`.
  static String toUpperCase(String? str) => str?.toUpperCase() ?? '';

  /// Null-safe lowercase conversion; returns `''` when input is `null`.
  static String toLowerCase(String? str) => str?.toLowerCase() ?? '';

  /// Convert `snake_case` / `kebab-case` / space-separated strings to camelCase.
  ///
  /// Example: `hello_world` / `hello-world` / `hello world` → `helloWorld`.
  static String toCamelCase(String str) {
    if (str.isEmpty) return str;
    final parts = str
        .split(RegExp(r'[_\-\s]+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    final first = parts.first;
    final lowerFirst =
        first[0].toLowerCase() + first.substring(1).toLowerCase();
    final rest = parts
        .skip(1)
        .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
        .join();
    return lowerFirst + rest;
  }

  /// Convert camelCase to `snake_case`.
  ///
  /// Example: `helloWorld` → `hello_world`.
  static String toSnakeCase(String str) {
    if (str.isEmpty) return str;
    final runes = str.runes.toList();
    final sb = StringBuffer();
    for (var i = 0; i < runes.length; i++) {
      final ch = String.fromCharCode(runes[i]);
      if (i > 0 && ch == ch.toUpperCase() && ch != ch.toLowerCase()) {
        sb.write('_');
      }
      sb.write(ch.toLowerCase());
    }
    return sb.toString();
  }

  /// Convert camelCase to `kebab-case`.
  ///
  /// Example: `helloWorld` → `hello-world`.
  static String toKebabCase(String str) =>
      toSnakeCase(str).replaceAll('_', '-');

  /// Null-safe whitespace trimming.
  static String trim(String? str) => str?.trim() ?? '';

  /// Remove leading whitespace only.
  static String trimStart(String? str) =>
      str?.replaceFirst(RegExp(r'^\s+'), '') ?? '';

  /// Remove trailing whitespace only.
  static String trimEnd(String? str) =>
      str?.replaceFirst(RegExp(r'\s+$'), '') ?? '';

  /// Truncate [str] to [maxLength]; append [ellipsis] when truncated.
  static String truncate(String str, int maxLength, {String ellipsis = '...'}) {
    if (maxLength < 0) throw ArgumentError.value(maxLength, 'maxLength');
    if (str.length <= maxLength) return str;
    return str.substring(0, maxLength) + ellipsis;
  }

  /// Pad on the left to reach [width].
  static String padLeft(String str, int width, [String padding = ' ']) =>
      str.padLeft(width, padding);

  /// Pad on the right to reach [width].
  static String padRight(String str, int width, [String padding = ' ']) =>
      str.padRight(width, padding);

  /// Repeat [str] [count] times.
  static String repeat(String str, int count) => str * count;

  /// Uppercase the first character; keep the rest unchanged.
  static String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  /// Lowercase the first character; keep the rest unchanged.
  static String uncapitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toLowerCase() + str.substring(1);
  }

  /// Case-insensitive substring check.
  static bool containsIgnoreCase(String source, String target) =>
      source.toLowerCase().contains(target.toLowerCase());

  /// Case-insensitive equality check (both nullable).
  static bool equalsIgnoreCase(String? a, String? b) =>
      (a ?? '').toLowerCase() == (b ?? '').toLowerCase();

  /// Mask the middle part of [str], keeping [left] leading and [right]
  /// trailing characters.
  ///
  /// Example: `hide('13812345678', 3, 4)` → `138****5678`.
  static String hide(String str, int left, int right, {String mask = '****'}) {
    if (str.length <= left + right) return mask;
    return str.substring(0, left) + mask + str.substring(str.length - right);
  }
}
