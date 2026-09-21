import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('PerfUtil.measure', () {
    test('returns a non-negative Duration', () {
      final d = PerfUtil.measure(() {});
      expect(d, isA<Duration>());
      expect(d.inMicroseconds, greaterThanOrEqualTo(0));
    });

    test('slower work yields bigger duration', () {
      final fast = PerfUtil.measure(() {});
      final slow = PerfUtil.measure(() {
        var s = 0;
        for (var i = 0; i < 100000; i++) s += i;
        // reference to keep the optimizer from dropping the loop
        if (s < -1) throw 0;
      });
      expect(slow.inMicroseconds, greaterThanOrEqualTo(fast.inMicroseconds));
    });
  });

  group('PerfUtil.benchmark', () {
    test('returns min/max/avg all non-negative', () {
      final stats = PerfUtil.benchmark(() {
        var s = 0;
        for (var i = 0; i < 1000; i++) s += i;
        if (s < -1) throw 0;
      }, times: 10);
      expect(stats.min.inMicroseconds, greaterThanOrEqualTo(0));
      expect(
        stats.max.inMicroseconds,
        greaterThanOrEqualTo(stats.min.inMicroseconds),
      );
      expect(stats.avgMs, greaterThanOrEqualTo(0));
    });
  });
}
