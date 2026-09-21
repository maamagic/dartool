/// Tiny benchmark utilities  useful inside tests or CLI tools.
///
/// Not to be confused with the full [TimerUtil.stopwatch] family; these are
/// intentionally one-liners. Works on native and web runtimes.
library;

import 'console_writer_io.dart'
    if (dart.library.js_interop) 'console_writer_web.dart'
    as console;

abstract final class PerfUtil {
  PerfUtil._();

  /// Run [fn] a single time and return the wall-clock duration.
  static Duration measure(void Function() fn) {
    final stopwatch = Stopwatch()..start();
    fn();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Run [fn] [times] times, return the min / max / average duration.
  static BenchmarkStats benchmark(void Function() fn, {int times = 1000}) {
    if (times < 1) {
      throw ArgumentError('times must be >= 1');
    }
    final samples = List<Duration>.filled(times, Duration.zero);
    for (var i = 0; i < times; i++) {
      final sw = Stopwatch()..start();
      fn();
      sw.stop();
      samples[i] = sw.elapsed;
    }
    final total = samples.fold<int>(0, (s, d) => s + d.inMicroseconds);
    return BenchmarkStats(
      min: samples.reduce(
        (a, b) => a.inMicroseconds < b.inMicroseconds ? a : b,
      ),
      max: samples.reduce(
        (a, b) => a.inMicroseconds > b.inMicroseconds ? a : b,
      ),
      avgUs: total / times,
    );
  }

  /// Print a formatted benchmark result to the console.
  static void report(String label, void Function() fn, {int times = 1000}) {
    final stats = benchmark(fn, times: times);
    console.consoleWriteLine(
      '[$label] ${stats.minMs.toStringAsFixed(3)}ms min '
      '${stats.maxMs.toStringAsFixed(3)}ms max '
      '${stats.avgMs.toStringAsFixed(3)}ms avg over $times runs',
      isError: false,
    );
  }
}

/// Min / max / average timings produced by [PerfUtil.benchmark].
class BenchmarkStats {
  BenchmarkStats({required this.min, required this.max, required this.avgUs});

  final Duration min;
  final Duration max;
  final double avgUs;

  double get minMs => min.inMicroseconds / 1000;
  double get maxMs => max.inMicroseconds / 1000;
  double get avgMs => avgUs / 1000;

  @override
  String toString() =>
      'BenchmarkStats(min: ${minMs}ms, max: ${maxMs}ms, avg: ${avgMs}ms)';
}
