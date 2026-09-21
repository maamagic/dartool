/// Retry helpers  exponential backoff with configurable policies.
///
/// Example:
/// ```dart
/// final result = await RetryUtil.run(
///   () => fetchSomething(),
///   maxAttempts: 3,
///   delay: Duration(milliseconds: 200),
///   backoff: Backoff.exponential,
/// );
/// ```
import 'dart:async';

enum Backoff { constant, linear, exponential }

abstract final class RetryUtil {
  RetryUtil._();

  /// Run [fn] and retry on failure up to [maxAttempts] times.
  ///
  /// [delay] is the base delay between attempts; [backoff] controls how each
  /// subsequent delay grows. [onRetry] is called after each failed attempt
  /// with the error and the attempt number (1-based).
  static Future<T> run<T>(
    Future<T> Function() fn, {
    int maxAttempts = 3,
    Duration delay = const Duration(milliseconds: 500),
    Backoff backoff = Backoff.exponential,
    bool Function(Object error)? retryIf,
    void Function(Object error, int attempt)? onRetry,
  }) async {
    if (maxAttempts < 1) {
      throw ArgumentError('maxAttempts must be >= 1');
    }
    Object? lastError;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await fn();
      } catch (e) {
        lastError = e;
        if (retryIf != null && !retryIf(e)) {
          rethrow;
        }
        if (attempt == maxAttempts) break;
        onRetry?.call(e, attempt);
        final wait = _computeDelay(delay, attempt, backoff);
        await Future<void>.delayed(wait);
      }
    }
    Error.throwWithStackTrace(lastError!, StackTrace.current);
  }

  /// Run a synchronous [fn] with retry (no delay between attempts).
  static T runSync<T>(
    T Function() fn, {
    int maxAttempts = 3,
    Backoff backoff = Backoff.exponential,
    bool Function(Object error)? retryIf,
    void Function(Object error, int attempt)? onRetry,
  }) {
    if (maxAttempts < 1) {
      throw ArgumentError('maxAttempts must be >= 1');
    }
    Object? lastError;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return fn();
      } catch (e) {
        lastError = e;
        if (retryIf != null && !retryIf(e)) {
          rethrow;
        }
        if (attempt == maxAttempts) break;
        onRetry?.call(e, attempt);
      }
    }
    Error.throwWithStackTrace(lastError!, StackTrace.current);
  }

  static Duration _computeDelay(Duration base, int attempt, Backoff policy) {
    switch (policy) {
      case Backoff.constant:
        return base;
      case Backoff.linear:
        return Duration(microseconds: base.inMicroseconds * attempt);
      case Backoff.exponential:
        return Duration(
          microseconds: base.inMicroseconds * (1 << (attempt - 1)),
        );
    }
  }
}
