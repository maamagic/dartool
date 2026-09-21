/// Common pre-built regex patterns (email, phone, URL, ID card, IP, etc.)
/// plus match / extraction helpers.
abstract final class RegexUtil {
  RegexUtil._();

  /// Email: `name@domain.tld`.
  static final RegExp email = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  /// Mainland China mobile: `1[3-9]xxxxxxxxx`.
  static final RegExp phoneCn = RegExp(r'^1[3-9]\d{9}$');

  /// URL (http / https).
  static final RegExp url = RegExp(
    r'^https?://[\w\-]+(\.[\w\-]+)+([/\w\-._~:/?#\[\]@!$&()*+,;=%]*)?$',
  );

  /// Mainland China ID card (18 digits; last char may be X/x).
  static final RegExp idCard = RegExp(r'^\d{17}[\dXx]$');

  /// IPv4 address.
  static final RegExp ipv4 = RegExp(
    r'^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$',
  );

  /// Pure Chinese characters (simplified / traditional).
  static final RegExp chinese = RegExp(r'^[\u4e00-\u9fa5]+$');

  /// Numeric string (integer or decimal, optional sign).
  static final RegExp number = RegExp(r'^-?\d+(\.\d+)?$');

  /// Whether [input] matches [pattern].
  static bool isMatch(String input, RegExp pattern) => pattern.hasMatch(input);

  /// Extract all matched substrings.
  static List<String> matches(String input, RegExp pattern) =>
      pattern.allMatches(input).map((m) => m[0]!).toList();

  /// Extract the first occurrence of capture group [group] (1-based);
  /// returns `null` if no match.
  static String? extract(String input, RegExp pattern, {int group = 1}) =>
      pattern.firstMatch(input)?.group(group);

  /// Whether [s] is an email.
  static bool isEmail(String s) => email.hasMatch(s);

  /// Whether [s] is a Mainland China mobile number.
  static bool isPhone(String s) => phoneCn.hasMatch(s);

  /// Whether [s] is a URL.
  static bool isUrl(String s) => url.hasMatch(s);

  /// Whether [s] is a Mainland China ID card (format only, not authenticity).
  static bool isIdCard(String s) => idCard.hasMatch(s);

  /// Whether [s] is an IPv4 address.
  static bool isIpv4(String s) => ipv4.hasMatch(s);

  /// Whether [s] consists entirely of Chinese characters.
  static bool isChinese(String s) => chinese.hasMatch(s);

  /// Whether [s] is a numeric string.
  static bool isNumber(String s) => number.hasMatch(s);
}
