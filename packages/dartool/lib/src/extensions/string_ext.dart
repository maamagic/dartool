import '../regex_util.dart';
import '../str_util.dart';

/// Extension APIs mirroring [StrUtil].
extension DartoolString on String {
  bool get isBlank => StrUtil.isBlank(this);
  bool get isNotBlank => StrUtil.isNotBlank(this);
  bool get isEmptyOrNull => StrUtil.isEmpty(this);
  bool get isNotEmpty => StrUtil.isNotEmpty(this);
  bool get isNumeric => StrUtil.isNumeric(this);
  bool get isAscii => StrUtil.isAscii(this);
  bool get isAlphabetic => StrUtil.isAlphabetic(this);
  bool get isAlphanumeric => StrUtil.isAlphanumeric(this);

  String get capitalize => StrUtil.capitalize(this);
  String get uncapitalize => StrUtil.uncapitalize(this);
  String get trimmed => StrUtil.trim(this);
  String get camelCase => StrUtil.toCamelCase(this);
  String get snakeCase => StrUtil.toSnakeCase(this);
  String get kebabCase => StrUtil.toKebabCase(this);
  String get pascalCase => StrUtil.toPascalCase(this);
  List<String> get words => StrUtil.toWords(this);
  String get reversed => StrUtil.reverse(this);

  bool containsIgnoreCase(String target) =>
      StrUtil.containsIgnoreCase(this, target);
  bool equalsIgnoreCase(String other) => StrUtil.equalsIgnoreCase(this, other);
  bool startsWithIgnoreCase(String prefix) =>
      StrUtil.startsWithIgnoreCase(this, prefix);
  bool endsWithIgnoreCase(String suffix) =>
      StrUtil.endsWithIgnoreCase(this, suffix);

  String truncate(int maxLength, {String ellipsis = '...'}) =>
      StrUtil.truncate(this, maxLength, ellipsis: ellipsis);
  String pad(int width, {String padding = ' ', bool left = true}) => left
      ? StrUtil.padLeft(this, width, padding)
      : StrUtil.padRight(this, width, padding);
  String repeat(int count) => StrUtil.repeat(this, count);
  String hide(int left, int right, {String mask = '****'}) =>
      StrUtil.hide(this, left, right, mask: mask);
  String removePrefix(String prefix) => StrUtil.removePrefix(this, prefix);
  String removeSuffix(String suffix) => StrUtil.removeSuffix(this, suffix);
  String wrap(String wrapper) => StrUtil.wrap(this, wrapper);
  String ifBlank(String fallback) => StrUtil.ifBlank(this, fallback);
  String between(String left, String right) =>
      StrUtil.between(this, left, right);
  List<String> splitAndTrim(String pattern, {bool dropEmpty = true}) =>
      StrUtil.splitAndTrim(this, pattern, dropEmpty: dropEmpty);
  int countChar(String char) => StrUtil.countChar(this, char);

  bool get isEmail => RegexUtil.isEmail(this);
  bool get isPhone => RegexUtil.isPhone(this);
  bool get isUrl => RegexUtil.isUrl(this);
  bool get isIdCard => RegexUtil.isIdCard(this);
  bool get isIpv4 => RegexUtil.isIpv4(this);
  bool get isChinese => RegexUtil.isChinese(this);
}

/// Null-aware convenience on nullable strings.
extension DartoolNullableString on String? {
  bool get isBlank => StrUtil.isBlank(this);
  bool get isNotBlank => StrUtil.isNotBlank(this);
  bool get isEmptyOrNull => StrUtil.isEmpty(this);
  String get orEmpty => this ?? '';
  String orIfBlank(String fallback) => StrUtil.ifBlank(this, fallback);
}
