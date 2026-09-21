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

  /// Convert `snake_case` / `kebab-case` / space-separated / PascalCase
  /// strings to camelCase.
  ///
  /// Example: `hello_world` / `hello-world` / `HelloWorld` �?`helloWorld`.
  static String toCamelCase(String str) {
    final words = _splitWords(str);
    if (words.isEmpty) return '';
    final first = words.first.toLowerCase();
    final rest = words
        .skip(1)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join();
    return first + rest;
  }

  /// Convert any casing form to `snake_case`.
  ///
  /// Example: `HelloWorld` / `hello-world` �?`hello_world`.
  static String toSnakeCase(String str) =>
      _splitWords(str).map((w) => w.toLowerCase()).join('_');

  /// Convert any casing form to `kebab-case`.
  ///
  /// Example: `HelloWorld` / `hello_world` �?`hello-world`.
  static String toKebabCase(String str) =>
      _splitWords(str).map((w) => w.toLowerCase()).join('-');

  /// Convert any casing form to `PascalCase`.
  ///
  /// Example: `hello_world` / `hello-world` �?`HelloWorld`.
  static String toPascalCase(String str) => _splitWords(
    str,
  ).map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase()).join();

  /// Split [str] into individual words, honouring `_`, `-`, whitespace and
  /// camelCase / PascalCase boundaries.
  ///
  /// Example: `helloWorld-foo_bar` �?`['hello', 'World', 'foo', 'bar']`.
  static List<String> toWords(String str) => _splitWords(str);

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  /// Tokenize any string into a clean list of lowercased words.
  static List<String> _splitWords(String str) {
    if (str.isEmpty) return const <String>[];
    // First split on explicit separators
    final withSeparators = str.split(RegExp(r'[_\-\s]+'));
    final out = <String>[];
    final upper = RegExp(r'[A-Z]');
    for (final raw in withSeparators) {
      if (raw.isEmpty) continue;
      // Split camelCase / PascalCase boundaries
      final buffer = StringBuffer();
      for (var i = 0; i < raw.length; i++) {
        final ch = raw[i];
        if (i > 0 && upper.hasMatch(ch) && !upper.hasMatch(raw[i - 1])) {
          out.add(buffer.toString());
          buffer.clear();
        }
        buffer.write(ch);
      }
      if (buffer.isNotEmpty) out.add(buffer.toString());
    }
    // Drop entries that became empty after splitting
    return out.where((w) => w.isNotEmpty).toList();
  }

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
  /// Example: `hide('13812345678', 3, 4)` �?`138****5678`.
  static String hide(String str, int left, int right, {String mask = '****'}) {
    if (str.length <= left + right) return mask;
    return str.substring(0, left) + mask + str.substring(str.length - right);
  }

  // ---------------------------------------------------------------------------
  // Character-type checks
  // ---------------------------------------------------------------------------

  /// Whether [str] consists only of ASCII printable characters (code points
  /// 0x20 through 0x7E).
  static bool isAscii(String? str) {
    if (str == null || str.isEmpty) return false;
    return str.runes.every((r) => r >= 0x20 && r <= 0x7E);
  }

  /// Whether every rune of [str] is a Unicode letter (alphabetic).
  static bool isAlphabetic(String? str) {
    if (str == null || str.isEmpty) return false;
    return str.runes.every((r) => _isLetter(r));
  }

  /// Whether every rune of [str] is a Unicode letter or decimal digit.
  static bool isAlphanumeric(String? str) {
    if (str == null || str.isEmpty) return false;
    return str.runes.every((r) => _isLetter(r) || (r >= 0x30 && r <= 0x39));
  }

  static bool _isLetter(int r) {
    // A-Z, a-z, plus Latin-1 supplement letters.
    return (r >= 0x41 && r <= 0x5A) ||
        (r >= 0x61 && r <= 0x7A) ||
        (r >= 0xC0 && r <= 0xFF && r != 0xD7 && r != 0xF7);
  }

  // ---------------------------------------------------------------------------
  // StartsWith / endsWith (case-insensitive)
  // ---------------------------------------------------------------------------

  /// Case-insensitive `startsWith`.
  static bool startsWithIgnoreCase(String str, String prefix) {
    if (prefix.length > str.length) return false;
    return str.substring(0, prefix.length).toLowerCase() ==
        prefix.toLowerCase();
  }

  /// Case-insensitive `endsWith`.
  static bool endsWithIgnoreCase(String str, String suffix) {
    if (suffix.length > str.length) return false;
    return str.substring(str.length - suffix.length).toLowerCase() ==
        suffix.toLowerCase();
  }

  // ---------------------------------------------------------------------------
  // Split / join helpers
  // ---------------------------------------------------------------------------

  /// Split [str] by [pattern] and trim each piece; empty strings are dropped
  /// when [dropEmpty] is `true`.
  static List<String> splitAndTrim(
    String str,
    String pattern, {
    bool dropEmpty = true,
  }) {
    final parts = str.split(pattern).map((s) => s.trim());
    if (dropEmpty) return parts.where((s) => s.isNotEmpty).toList();
    return parts.toList();
  }

  /// Join the non-blank items of [parts] with [separator].
  static String join(Iterable<String?> parts, [String separator = '']) {
    final list = parts.where((s) => s != null && s.isNotEmpty).cast<String>();
    return list.join(separator);
  }

  // ---------------------------------------------------------------------------
  // Manipulation
  // ---------------------------------------------------------------------------

  /// Reverse [str].
  static String reverse(String str) =>
      String.fromCharCodes(str.runes.toList().reversed);

  /// Count how many times [char] appears in [str].
  static int countChar(String str, String char) {
    if (char.isEmpty || char.length > 1) {
      throw ArgumentError.value(char, 'char', 'must be a single character');
    }
    var n = 0;
    for (var i = 0; i < str.length; i++) {
      if (str[i] == char) n++;
    }
    return n;
  }

  /// Remove [prefix] from the start of [str] if present.
  static String removePrefix(String str, String prefix) {
    if (prefix.isEmpty) return str;
    if (str.startsWith(prefix)) return str.substring(prefix.length);
    return str;
  }

  /// Remove [suffix] from the end of [str] if present.
  static String removeSuffix(String str, String suffix) {
    if (suffix.isEmpty) return str;
    if (str.endsWith(suffix))
      return str.substring(0, str.length - suffix.length);
    return str;
  }

  /// Wrap [str] with [wrapper] on both sides.
  static String wrap(String str, String wrapper) => '$wrapper$str$wrapper';

  /// Return [str] if non-blank, otherwise [fallback].
  static String ifBlank(String? str, String fallback) =>
      isBlank(str) ? fallback : str!;

  /// Return the substring between the first occurrence of [left] and the
  /// following occurrence of [right]. Returns `''` if not found.
  static String between(String str, String left, String right) {
    final li = str.indexOf(left);
    if (li < 0) return '';
    final start = li + left.length;
    final ri = str.indexOf(right, start);
    if (ri < 0) return '';
    return str.substring(start, ri);
  }

  static String padCenter(String str, int width, [String padding = ' ']) {
    if (str.length >= width) return str;
    final total = width - str.length;
    final left = total ~/ 2;
    final right = total - left;
    return padding * left + str + padding * right;
  }

  static List<String> chunked(String str, int size) {
    if (size <= 0 || str.isEmpty) return const <String>[];
    final chunks = <String>[];
    for (var i = 0; i < str.length; i += size) {
      chunks.add(str.substring(i, (i + size).clamp(0, str.length)));
    }
    return chunks;
  }

  static String hideEmail(String email, [String mask = '****']) {
    final at = email.indexOf('@');
    if (at <= 1) return email;
    final prefix = email.substring(0, 1);
    return '$prefix$mask${email.substring(at)}';
  }

  static String hidePhone(
    String phone, {
    int keepLeft = 3,
    int keepRight = 4,
    String mask = '****',
  }) {
    if (phone.length <= keepLeft + keepRight) return phone;
    return '${phone.substring(0, keepLeft)}$mask${phone.substring(phone.length - keepRight)}';
  }
}
