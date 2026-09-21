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

    test('blocks burst above maxTokens', () {
      final r = RateLimiter(tokensPerSecond: 1, maxTokens: 2);
      expect(r.tryAcquire(count: 3), isFalse);
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
  });
}
