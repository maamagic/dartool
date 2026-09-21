/// Token-bucket rate limiter  smooths bursts while enforcing an average rate.
class RateLimiter {
  /// [tokensPerSecond] must be a finite positive number; [maxTokens]
  /// defaults to twice the rate (capped at 2^20) and must be at least 1.
  factory RateLimiter({required double tokensPerSecond, int? maxTokens}) {
    if (tokensPerSecond.isNaN ||
        tokensPerSecond.isInfinite ||
        tokensPerSecond <= 0) {
      throw ArgumentError.value(
        tokensPerSecond,
        'tokensPerSecond',
        'must be a finite positive number',
      );
    }
    final effectiveMax =
        maxTokens ?? (tokensPerSecond * 2).clamp(1, 1 << 20).toInt();
    return RateLimiter._(tokensPerSecond, effectiveMax);
  }

  RateLimiter._(this.tokensPerSecond, this.maxTokens) {
    if (maxTokens < 1) {
      throw ArgumentError.value(maxTokens, 'maxTokens', 'must be at least 1');
    }
    _tokens = maxTokens.toDouble();
    _last = DateTime.now();
  }

  final double tokensPerSecond;
  final int maxTokens;

  double _tokens = 0;
  DateTime _last = DateTime.now();

  /// Try to acquire [count] tokens immediately without waiting.
  ///
  /// [count] must be between 1 and [maxTokens]; a larger request could never
  /// be satisfied and throws [ArgumentError]. A non-positive [count] is a
  /// no-op that returns `true`.
  bool tryAcquire({int count = 1}) {
    if (count <= 0) return true;
    if (count > maxTokens) {
      throw ArgumentError.value(
        count,
        'count',
        'cannot exceed maxTokens ($maxTokens)',
      );
    }
    _refill();
    if (_tokens >= count) {
      _tokens -= count;
      return true;
    }
    return false;
  }

  /// Acquire [count] tokens, waiting (without busy-polling) until enough have
  /// accrued. Throws [ArgumentError] if [count] exceeds [maxTokens].
  Future<void> acquire({int count = 1}) async {
    if (count <= 0) return;
    if (count > maxTokens) {
      throw ArgumentError.value(
        count,
        'count',
        'cannot exceed maxTokens ($maxTokens)',
      );
    }
    while (true) {
      if (tryAcquire(count: count)) return;
      // Estimate how long until the deficit is refilled, then sleep that long
      // instead of polling every millisecond.
      _refill();
      final deficit = count - _tokens;
      if (deficit <= 0) continue;
      final waitMs = (deficit / tokensPerSecond * 1000).ceil();
      await Future<void>.delayed(
        Duration(milliseconds: waitMs < 1 ? 1 : waitMs),
      );
    }
  }

  double get available {
    _refill();
    return _tokens;
  }

  void reset() {
    _tokens = maxTokens.toDouble();
    _last = DateTime.now();
  }

  void _refill() {
    final now = DateTime.now();
    final delta = now.difference(_last);
    final seconds = delta.inMicroseconds / Duration.microsecondsPerSecond;
    if (seconds > 0) {
      _tokens = (_tokens + seconds * tokensPerSecond).clamp(
        0.0,
        maxTokens.toDouble(),
      );
      _last = now;
    }
  }
}
