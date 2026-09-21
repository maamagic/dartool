import 'package:flutter/foundation.dart';

/// Log levels.
enum LogLevel { debug, info, warn, error }

/// Log output callback signature.
typedef LogOutput = void Function(String line);

/// Lightweight logging utility.
///
/// Outputs via [debugPrint] by default (gracefully degrades in release builds).
/// Supports level filtering and per-call tags. Replace [output] to wire in a
/// custom logging pipeline.
abstract final class LogUtil {
  LogUtil._();

  /// Minimum level that will be printed; lower levels are filtered out.
  static LogLevel minLevel = LogLevel.debug;

  /// Actual output callback — override to integrate a custom logger.
  static LogOutput output = _defaultOutput;

  static void _defaultOutput(String line) => debugPrint(line);

  /// Print at `debug` level.
  static void debug(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag);

  /// Print at `info` level.
  static void info(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag);

  /// Print at `warn` level.
  static void warn(String message, {String? tag}) =>
      _log(LogLevel.warn, message, tag);

  /// Print at `error` level.
  static void error(String message, {String? tag}) =>
      _log(LogLevel.error, message, tag);

  static void _log(LogLevel level, String message, String? tag) {
    if (level.index < minLevel.index) return;
    final t = tag == null ? '' : '[$tag] ';
    output('[${level.name.toUpperCase()}] $t$message');
  }
}
