import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('RateLimiter', () {
    test('allows up to maxTokens immediately', () {
      final r = RateLimiter(tokensPerSecond: 10, maxTokens: 5);
      for (var i = 0; i < 5; i++) {
        expect(r.tryAcquire(), isTrue);
      }
      expect(r.tryAcquire(), isFalse);
    });

    test('request above maxTokens throws (can never be satisfied)', () {
      final r = RateLimiter(tokensPerSecond: 1, maxTokens: 2);
      expect(() => r.tryAcquire(count: 3), throwsArgumentError);
      expect(() => r.acquire(count: 3), throwsArgumentError);
      // limiter is still usable afterwards
      expect(r.tryAcquire(count: 2), isTrue);
    });

    test('reset replenishes tokens', () {
      final r = RateLimiter(tokensPerSecond: 10, maxTokens: 3);
      r.tryAcquire(count: 3);
      expect(r.available, lessThan(1));
      r.reset();
      expect(r.available, 3);
    });

    test('negative / zero count always allowed', () {
      final r = RateLimiter(tokensPerSecond: 1, maxTokens: 1);
      expect(r.tryAcquire(count: 0), isTrue);
      expect(r.tryAcquire(count: -5), isTrue);
    });

    test('tokens refill over time', () async {
      final r = RateLimiter(tokensPerSecond: 1000, maxTokens: 10);
      r.tryAcquire(count: 10); // drain
      await Future<void>.delayed(Duration(milliseconds: 60));
      // should have refilled ~6 tokens
      expect(r.available, greaterThanOrEqualTo(5));
    });

    test('invalid constructor arguments rejected', () {
      expect(() => RateLimiter(tokensPerSecond: 0), throwsArgumentError);
      expect(() => RateLimiter(tokensPerSecond: -1), throwsArgumentError);
      expect(
        () => RateLimiter(tokensPerSecond: double.nan),
        throwsArgumentError,
      );
      expect(
        () => RateLimiter(tokensPerSecond: double.infinity),
        throwsArgumentError,
      );
      expect(
        () => RateLimiter(tokensPerSecond: 1, maxTokens: 0),
        throwsArgumentError,
      );
    });

    test('acquire waits for refill instead of busy-looping forever', () async {
      final r = RateLimiter(tokensPerSecond: 100, maxTokens: 2);
      expect(r.tryAcquire(count: 2), isTrue);
      final sw = Stopwatch()..start();
      await r.acquire(); // ~10ms for one token
      sw.stop();
      expect(sw.elapsedMilliseconds, greaterThanOrEqualTo(8));
      expect(sw.elapsedMilliseconds, lessThan(500));
    });
  });
}
