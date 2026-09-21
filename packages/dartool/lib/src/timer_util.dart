import 'dart:async';
import 'dart:io';

/// Simple stopwatch wrapper and benchmark helpers.
abstract final class TimerUtil {
  TimerUtil._();

  // ---------------------------------------------------------------------------
  // Stopwatch builder
  // ---------------------------------------------------------------------------

  /// Create a started [Stopwatch].
  static Stopwatch start() => Stopwatch()..start();

  // ---------------------------------------------------------------------------
  // Benchmark
  // ---------------------------------------------------------------------------

  /// Run [action] and return the elapsed duration.
  static Duration measure(void Function() action) {
    final sw = Stopwatch()..start();
    action();
    sw.stop();
    return sw.elapsed;
  }

  /// Run [action] for [iterations] times and print/return summary.
  ///
  /// Example output: `Ran 1000 iterations in 256ms (avg 256s each)`.
  static Duration benchmark(
    void Function() action, {
    int iterations = 1000,
    bool printResult = true,
  }) {
    if (iterations <= 0) {
      throw ArgumentError.value(iterations, 'iterations', 'must be > 0');
    }
    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      action();
    }
    sw.stop();

    final total = sw.elapsed;
    final avgUs = total.inMicroseconds / iterations;
    if (printResult) {
      final avgStr = avgUs >= 1000
          ? '${(avgUs / 1000).toStringAsFixed(2)}ms'
          : '${avgUs.toStringAsFixed(1)}s';
      stdout.writeln(
        'Ran $iterations iterations in ${_fmt(total)} (avg $avgStr each)',
      );
    }
    return total;
  }

  // ---------------------------------------------------------------------------
  // Future helpers
  // ---------------------------------------------------------------------------

  /// Sleep for [duration] (short alias for `Future.delayed`).
  static Future<void> sleep(Duration duration) => Future.delayed(duration);

  /// Execute [action] with a minimum delay of [minDuration] from when this
  /// function was called; useful for making skeleton-loaders feel natural.
  static Future<T> withMinDelay<T>(
    FutureOr<T> Function() action,
    Duration minDuration,
  ) async {
    final sw = Stopwatch()..start();
    final result = await action();
    final remaining = minDuration - sw.elapsed;
    if (remaining.inMicroseconds > 0) {
      await Future<void>.delayed(remaining);
    }
    return result;
  }

  static String _fmt(Duration d) {
    if (d.inMilliseconds < 1000) return '${d.inMilliseconds}ms';
    return '${(d.inMicroseconds / 1e6).toStringAsFixed(2)}s';
  }
}
