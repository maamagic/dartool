/// 类型转换工具类。
///
/// 将字符串、数字、布尔等类型互相转换，均提供兜底值，避免抛出异常。
library;

import 'date_util.dart';

/// Utility methods for converting between common types (int, double, bool,
/// String, DateTime, List) with safe fallbacks.
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

  /// 转为 `int`；失败返回 [fallback]。
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

  /// 转为 `double`；失败返回 [fallback]。
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

  /// 转为 `bool`；无法识别时返回 [fallback]。
  ///
  /// 字符串识别：`true/1/yes/y/是` → true，`false/0/no/n/否` → false。
  static bool? toBool(dynamic v, {bool? fallback}) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final t = v.trim().toLowerCase();
      if (const {'true', '1', 'yes', 'y', '是'}.contains(t)) return true;
      if (const {'false', '0', 'no', 'n', '否'}.contains(t)) return false;
      return fallback;
    }
    return fallback;
  }

  /// 转为字符串；`null` 返回 [fallback]。
  static String toStringVal(dynamic v, {String fallback = ''}) =>
      v == null ? fallback : v.toString();

  /// 转为时间；支持 `DateTime` / 毫秒时间戳 / 常见字符串格式。
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

  /// 转为 `List<T>`；非集合返回 [fallback]（默认为空列表）。
  static List<T> toList<T>(dynamic v, {List<T>? fallback}) {
    if (v is List) return v.cast<T>();
    if (v is Iterable) return v.cast<T>().toList();
    return fallback ?? <T>[];
  }
}
