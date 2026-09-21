/// Safe error / exception inspection helpers. Designed so you can feed
/// literally `Object?` (as you get from catch blocks) and always get a
/// readable string without crashing.
class ExceptionUtil {
  ExceptionUtil._();

  /// Extract a readable message from [value], whatever it is.
  ///
  /// Handles [Exception], [Error], [String], [DateTime], [Type], and any
  /// object with a `toString` that returns something non-trivial. Returns
  /// an empty string for null.
  static String stringify(Object? value) {
    if (value == null) return '';
    if (value is Exception) {
      final msg = value.toString();
      return _cleanException(msg);
    }
    if (value is Error) {
      final msg = value.toString();
      return msg.isEmpty ? value.runtimeType.toString() : msg;
    }
    if (value is String) return value;
    final s = value.toString();
    if (s == value.runtimeType.toString()) return value.runtimeType.toString();
    return s;
  }

  /// One-line summary — [stringify] prefixed with the runtime type.
  static String summarize(Object? value) {
    if (value == null) return 'null';
    final msg = stringify(value);
    final t = value.runtimeType;
    return msg.isEmpty ? t.toString() : '$t: $msg';
  }

  static String _cleanException(String raw) {
    // Exception.toString() usually returns "Exception: message". Strip
    // the redundant prefix when it is exactly "Exception:".
    const prefix = 'Exception:';
    final trimmed = raw.trim();
    if (trimmed.startsWith(prefix)) {
      return trimmed.substring(prefix.length).trim();
    }
    return trimmed;
  }

  /// Pretty-format a [StackTrace] into a readable block. Returns an empty
  /// string for null.
  static String formatStackTrace(StackTrace? stack) {
    if (stack == null) return '';
    final lines = stack.toString().split('\n');
    final buf = StringBuffer();
    var shown = 0;
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      buf.writeln('  $line');
      shown++;
      if (shown >= 20) {
        buf.writeln('  ... (truncated, ${lines.length - shown} more)');
        break;
      }
    }
    return buf.toString().trimRight();
  }

  /// Run [fn], returning its result. If it throws, return the result of
  /// [onError] instead (defaults to null).
  static T? tryCatch<T>(
    T Function() fn, {
    T? Function(Object error, StackTrace stack)? onError,
  }) {
    try {
      return fn();
    } catch (e, st) {
      if (onError != null) return onError(e, st);
      return null;
    }
  }

  /// Async version of [tryCatch].
  static Future<T?> tryCatchAsync<T>(
    Future<T> Function() fn, {
    T? Function(Object error, StackTrace stack)? onError,
  }) async {
    try {
      return await fn();
    } catch (e, st) {
      if (onError != null) return onError(e, st);
      return null;
    }
  }
}
