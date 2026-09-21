/// Tiny leveled logger  pure Dart, zero deps, mirrors common loggers.
///
/// ```dart
/// LogUtil.d('cache hit for user 123');
/// LogUtil.i('network', 'connected');
/// LogUtil.e('api', 'timeout', error: e);
/// ```
import 'dart:io';

enum LogLevel { verbose, debug, info, warning, error, none }

typedef LogFormatter =
    String Function(
      LogLevel level,
      String tag,
      String message,
      Object? error,
      StackTrace? st,
    );

abstract final class LogUtil {
  LogUtil._();

  static LogLevel _level = LogLevel.debug;
  static LogLevel get level => _level;
  static set level(LogLevel v) => _level = v;

  static LogFormatter _formatter = _defaultFormatter;
  static set formatter(LogFormatter f) => _formatter = f;
  static void resetFormatter() => _formatter = _defaultFormatter;

  static void v([
    String tag = '',
    String message = '',
    Object? error,
    StackTrace? st,
  ]) => _log(LogLevel.verbose, tag, message, error, st);
  static void d([
    String tag = '',
    String message = '',
    Object? error,
    StackTrace? st,
  ]) => _log(LogLevel.debug, tag, message, error, st);
  static void i([
    String tag = '',
    String message = '',
    Object? error,
    StackTrace? st,
  ]) => _log(LogLevel.info, tag, message, error, st);
  static void w([
    String tag = '',
    String message = '',
    Object? error,
    StackTrace? st,
  ]) => _log(LogLevel.warning, tag, message, error, st);
  static void e([
    String tag = '',
    String message = '',
    Object? error,
    StackTrace? st,
  ]) => _log(LogLevel.error, tag, message, error, st);

  static void _log(
    LogLevel lvl,
    String tag,
    String msg,
    Object? error,
    StackTrace? st,
  ) {
    if (lvl.index < _level.index) return;
    final line = _formatter(lvl, tag, msg, error, st);
    if (lvl.index >= LogLevel.warning.index) {
      stderr.writeln(line);
    } else {
      stdout.writeln(line);
    }
  }

  static String _defaultFormatter(
    LogLevel lvl,
    String tag,
    String msg,
    Object? error,
    StackTrace? st,
  ) {
    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
    final lvlStr = lvl.name.toUpperCase().padRight(7);
    final tagStr = tag.isEmpty ? '' : ' [$tag]';
    final buffer = StringBuffer('$time $lvlStr$tagStr $msg');
    if (error != null) buffer.writeln('  error: $error');
    if (st != null) buffer.write('  $st');
    return buffer.toString();
  }
}
