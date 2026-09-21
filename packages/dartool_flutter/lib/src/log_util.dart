import 'package:flutter/foundation.dart';

/// 日志级别。
enum LogLevel { debug, info, warn, error }

/// 日志输出回调类型。
typedef LogOutput = void Function(String line);

/// 轻量日志工具类。
///
/// 默认经 [debugPrint] 输出（release 自动降级），支持分级过滤与标签。
/// 可通过替换 [output] 接入自定义日志通道。
abstract final class LogUtil {
  LogUtil._();

  /// 最低输出级别，低于该级别的日志被过滤。
  static LogLevel minLevel = LogLevel.debug;

  /// 实际输出回调，可替换以接入自定义日志系统。
  static LogOutput output = _defaultOutput;

  static void _defaultOutput(String line) => debugPrint(line);

  /// 输出 debug 级日志。
  static void debug(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag);

  /// 输出 info 级日志。
  static void info(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag);

  /// 输出 warn 级日志。
  static void warn(String message, {String? tag}) =>
      _log(LogLevel.warn, message, tag);

  /// 输出 error 级日志。
  static void error(String message, {String? tag}) =>
      _log(LogLevel.error, message, tag);

  static void _log(LogLevel level, String message, String? tag) {
    if (level.index < minLevel.index) return;
    final t = tag == null ? '' : '[$tag] ';
    output('[${level.name.toUpperCase()}] $t$message');
  }
}
