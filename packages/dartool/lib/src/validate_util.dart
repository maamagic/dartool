/// 数据校验工具类。
///
/// 复用 [StrUtil] / [RegexUtil] 的判定，并提供抛异常的强制校验方法，
/// 适合在方法入口做参数防御。
library;

import 'regex_util.dart';
import 'str_util.dart';

abstract final class ValidateUtil {
  ValidateUtil._();

  /// 值是否为 `null`。
  static bool isNull(Object? v) => v == null;

  /// 值是否非 `null`。
  static bool isNotNull(Object? v) => v != null;

  /// 强制值非空，否则抛 [ArgumentError]。
  static void notNull(Object? v, [String? name]) {
    if (v == null) throw ArgumentError.notNull(name ?? 'value');
  }

  /// 字符串是否空白。
  static bool isBlank(String? v) => StrUtil.isBlank(v);

  /// 字符串是否非空白。
  static bool isNotBlank(String? v) => StrUtil.isNotBlank(v);

  /// 是否邮箱。
  static bool isEmail(String v) => RegexUtil.isEmail(v);

  /// 是否中国大陆手机号。
  static bool isPhone(String v) => RegexUtil.isPhone(v);

  /// 是否 URL。
  static bool isUrl(String v) => RegexUtil.isUrl(v);

  /// 是否中国居民身份证（格式校验）。
  static bool isIdCard(String v) => RegexUtil.isIdCard(v);

  /// 是否数字字符串。
  static bool isNumeric(String v) => StrUtil.isNumeric(v);

  /// 数值是否在闭区间 `[min, max]` 内。
  static bool inRange(num v, num min, num max) => v >= min && v <= max;

  /// 字符串长度是否在闭区间 `[min, max]` 内。
  static bool lengthBetween(String v, int min, int max) =>
      v.length >= min && v.length <= max;

  /// 强制 [condition] 为真，否则抛 [ArgumentError]（可带 [message]）。
  static void require(bool condition, [String? message]) {
    if (!condition) {
      throw ArgumentError(message ?? 'validation failed');
    }
  }
}
