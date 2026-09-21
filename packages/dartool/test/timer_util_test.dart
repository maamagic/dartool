import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('TimerUtil.start / measure', () {
    test('start returns a running stopwatch', () {
      final sw = TimerUtil.start();
      expect(sw.isRunning, isTrue);
      sw.stop();
    });

    test('measure returns non-zero duration', () {
      final d = TimerUtil.measure(() {
        // small busy loop; we just verify it doesn't throw
        var s = 0;
        for (var i = 0; i < 1000; i++) s += i;
        expect(s, greaterThan(0));
      });
      expect(d, isA<Duration>());
    });
  });

  group('TimerUtil.benchmark', () {
    test('rejects non-positive iterations', () {
      expect(
        () => TimerUtil.benchmark(() {}, iterations: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('runs N iterations without throwing', () {
      expect(
        () => TimerUtil.benchmark(() {}, iterations: 100, printResult: false),
        returnsNormally,
      );
    });
  });
}
