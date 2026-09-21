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
library;

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
        final wait = computeDelay(delay, attempt, backoff);
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

  /// Saturation ceiling for delay microseconds.
  ///
  /// 2^53 - 1 is the largest integer represented exactly on every platform
  /// (about 285 years of microseconds), which is an effective "forever" wait;
  /// using it instead of the int64 max keeps the constant representable on
  /// the web.
  static const int _maxMicroseconds = 9007199254740991;

  static int _saturatedMultiply(int a, int b) {
    if (a == 0 || b == 0) return 0;
    if (a > _maxMicroseconds ~/ b.abs()) return _maxMicroseconds;
    return a * b;
  }

  /// Delay to wait after failed [attempt] (1-based) under [policy].
  ///
  /// Exposed so custom retry loops can reuse the same growth curve. The
  /// result is always non-negative: the exponential shift is capped at 62
  /// and multiplication saturates at the maximum [Duration] microsecond
  /// value instead of overflowing.
  static Duration computeDelay(Duration base, int attempt, Backoff policy) {
    switch (policy) {
      case Backoff.constant:
        return base;
      case Backoff.linear:
        return Duration(
          microseconds: _saturatedMultiply(base.inMicroseconds, attempt),
        );
      case Backoff.exponential:
        // Cap the exponent at 62 and grow the factor by doubling instead
        // of shifting: JS bitwise operators truncate to 32 bits, so
        // `1 << 62` would silently wrap to `1 << 30` on the web. Powers of
        // two are exact IEEE doubles, so the factor itself stays precise.
        final exponent = attempt - 1 > 62 ? 62 : attempt - 1;
        var factor = 1;
        for (var i = 0; i < exponent; i++) {
          factor *= 2;
        }
        return Duration(
          microseconds: _saturatedMultiply(base.inMicroseconds, factor),
        );
    }
  }
}
