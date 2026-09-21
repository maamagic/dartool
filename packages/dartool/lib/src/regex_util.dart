/// 正则表达式工具类。
///
/// 内置常用校验正则（邮箱、手机号、URL、身份证、IP 等），并提供
/// 匹配、提取等便捷方法。
abstract final class RegexUtil {
  RegexUtil._();

  /// 邮箱：`name@domain.tld`。
  static final RegExp email = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  /// 中国大陆手机号：`1[3-9]xxxxxxxxx`。
  static final RegExp phoneCn = RegExp(r'^1[3-9]\d{9}$');

  /// URL（http/https）。
  static final RegExp url = RegExp(
    r'^https?://[\w\-]+(\.[\w\-]+)+([/\w\-._~:/?#\[\]@!$&()*+,;=%]*)?$',
  );

  /// 中国居民身份证（18 位，末位可为数字或 X/x）。
  static final RegExp idCard = RegExp(r'^\d{17}[\dXx]$');

  /// IPv4 地址。
  static final RegExp ipv4 = RegExp(
    r'^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$',
  );

  /// 纯中文（简体/繁体汉字）。
  static final RegExp chinese = RegExp(r'^[\u4e00-\u9fa5]+$');

  /// 数字（整数或小数，可带负号）。
  static final RegExp number = RegExp(r'^-?\d+(\.\d+)?$');

  /// 判断 [input] 是否匹配 [pattern]。
  static bool isMatch(String input, RegExp pattern) => pattern.hasMatch(input);

  /// 提取所有匹配片段。
  static List<String> matches(String input, RegExp pattern) =>
      pattern.allMatches(input).map((m) => m[0]!).toList();

  /// 提取第一个匹配的指定捕获组（[group] 从 1 开始）；无匹配返回 `null`。
  static String? extract(String input, RegExp pattern, {int group = 1}) =>
      pattern.firstMatch(input)?.group(group);

  /// 是否邮箱。
  static bool isEmail(String s) => email.hasMatch(s);

  /// 是否中国大陆手机号。
  static bool isPhone(String s) => phoneCn.hasMatch(s);

  /// 是否 URL。
  static bool isUrl(String s) => url.hasMatch(s);

  /// 是否中国居民身份证（格式校验，非真伪校验）。
  static bool isIdCard(String s) => idCard.hasMatch(s);

  /// 是否 IPv4。
  static bool isIpv4(String s) => ipv4.hasMatch(s);

  /// 是否纯中文。
  static bool isChinese(String s) => chinese.hasMatch(s);

  /// 是否数字。
  static bool isNumber(String s) => number.hasMatch(s);
}
