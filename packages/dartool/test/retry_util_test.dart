import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('RetryUtil', () {
    test('succeeds on first attempt', () async {
      var calls = 0;
      final result = await RetryUtil.run<int>(
        () async {
          calls++;
          return 42;
        },
        maxAttempts: 3,
        delay: Duration.zero,
      );
      expect(result, 42);
      expect(calls, 1);
    });

    test('retries and eventually succeeds', () async {
      var calls = 0;
      final result = await RetryUtil.run<int>(
        () async {
          calls++;
          if (calls < 3) throw StateError('fail');
          return calls;
        },
        maxAttempts: 3,
        delay: Duration.zero,
      );
      expect(result, 3);
      expect(calls, 3);
    });

    test('throws after exhausting attempts', () async {
      expect(
        () => RetryUtil.run<void>(
          () async => throw StateError('always fail'),
          maxAttempts: 2,
          delay: Duration.zero,
        ),
        throwsStateError,
      );
    });

    test('retryIf filters which errors are retried', () async {
      var calls = 0;
      Future<void> fn() async {
        calls++;
        if (calls == 1) throw FormatException('bad');
        throw StateError('stop');
      }

      await expectLater(
        RetryUtil.run<void>(
          fn,
          maxAttempts: 3,
          delay: Duration.zero,
          retryIf: (e) => e is FormatException,
        ),
        throwsStateError,
      );
      expect(calls, 2);
    });

    test('onRetry is invoked after each failed attempt', () async {
      final errors = <Object>[];
      final attempts = <int>[];
      await RetryUtil.run<int>(
        () async => throw StateError('nope'),
        maxAttempts: 2,
        delay: Duration.zero,
        onRetry: (e, a) {
          errors.add(e);
          attempts.add(a);
        },
      ).catchError((_) => 0);

      expect(errors.length, 1);
      expect(attempts, [1]);
    });

    test('runSync also retries', () {
      var calls = 0;
      final result = RetryUtil.runSync<int>(() {
        calls++;
        if (calls < 2) throw StateError('fail');
        return calls;
      }, maxAttempts: 3);
      expect(result, 2);
      expect(calls, 2);
    });

    test('exponential backoff grows the delay', () async {
      var calls = 0;
      final delays = <int>[];
      Stopwatch? sw;
      await RetryUtil.run<int>(
        () async {
          calls++;
          if (sw != null) delays.add(sw!.elapsedMilliseconds);
          sw = Stopwatch()..start();
          if (calls < 3) throw StateError('fail');
          return calls;
        },
        maxAttempts: 3,
        delay: Duration(milliseconds: 20),
        backoff: Backoff.exponential,
      );
      expect(delays[1], greaterThan(delays[0]));
    });

    test('computeDelay never overflows on huge attempt counts', () {
      const base = Duration(microseconds: 1);
      for (final attempt in [1, 2, 10, 31, 62, 63, 64, 70, 1000]) {
        final d = RetryUtil.computeDelay(base, attempt, Backoff.exponential);
        expect(d.inMicroseconds, greaterThanOrEqualTo(0));
      }
      // shift is capped at 62: attempts 63+ all equal the 2^62 multiplier.
      // Build 2^62 by doubling (a literal/shift would wrap or fail to
      // represent exactly on the web).
      var pow2_62 = 1;
      for (var i = 0; i < 62; i++) {
        pow2_62 *= 2;
      }
      final d62 = RetryUtil.computeDelay(base, 63, Backoff.exponential);
      final d1000 = RetryUtil.computeDelay(base, 1000, Backoff.exponential);
      expect(d1000, d62);
      // On the VM the exact 2^62 product is kept; on the web the saturation
      // guard rounds down to the safe-integer ceiling (both are hundreds of
      // thousands of years — an effective infinite delay).
      expect(d62.inMicroseconds, anyOf(pow2_62, 9007199254740991));

      // linear multiplication saturates at the cross-platform ceiling
      // (2^53 - 1) instead of wrapping to a negative value
      final hugeLinear = RetryUtil.computeDelay(
        const Duration(microseconds: 1000000),
        1 << 30,
        Backoff.linear,
      );
      expect(hugeLinear.inMicroseconds, greaterThan(0));
      expect(hugeLinear.inMicroseconds, lessThanOrEqualTo(9007199254740991));
    });
  });
}
