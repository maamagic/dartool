/// Token-bucket rate limiter — smooths bursts while enforcing an average rate.
class RateLimiter {
  RateLimiter({required this.tokensPerSecond, int? maxTokens})
    : maxTokens = maxTokens ?? (tokensPerSecond * 2).clamp(1, 1 << 20).toInt() {
    _tokens = this.maxTokens.toDouble();
    _last = DateTime.now();
  }

  final double tokensPerSecond;
  final int maxTokens;

  double _tokens = 0;
  DateTime _last = DateTime.now();

  bool tryAcquire({int count = 1}) {
    if (count <= 0) return true;
    _refill();
    if (_tokens >= count) {
      _tokens -= count;
      return true;
    }
    return false;
  }

  Future<void> acquire({int count = 1}) async {
    if (tryAcquire(count: count)) return;
    while (!tryAcquire(count: count)) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
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
