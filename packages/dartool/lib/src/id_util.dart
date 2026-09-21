import 'dart:math';

/// ID generation utilities: UUID v4, short random IDs and Snowflake IDs,
/// all with zero third-party dependencies.
abstract final class IdUtil {
  IdUtil._();

  static final Random _random = Random.secure();

  /// Generate a UUID v4 (with hyphens, lowercase).
  static String uuid() {
    final b = List<int>.generate(16, (_) => _random.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    final hex = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  /// UUID v4 without hyphens (32 hex characters).
  static String simpleUuid() => uuid().replaceAll('-', '');

  /// Random ID of [length] characters chosen from [charset].
  static String randomId(
    int length, {
    String charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
  }) {
    if (length <= 0) throw ArgumentError.value(length, 'length');
    final sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(charset[_random.nextInt(charset.length)]);
    }
    return sb.toString();
  }

  /// Create a Snowflake ID generator ([workerId] in 0..1023).
  static SnowflakeIdGenerator snowflake({int workerId = 0}) =>
      SnowflakeIdGenerator(workerId: workerId);
}

/// Snowflake ID generator.
///
/// 64-bit ID layout: 41-bit millisecond timestamp + 10-bit worker ID +
/// 12-bit auto-incrementing sequence. Monotonically increasing on a
/// single node; well suited as a distributed primary key.
///
/// On the web, where Dart integers are IEEE-754 doubles and cannot
/// represent every 64-bit ID exactly, use [nextIdString] instead of
/// [nextId] (and transport IDs as strings in JSON).
class SnowflakeIdGenerator {
  /// [workerId] must be in 0..1023.
  SnowflakeIdGenerator({this.workerId = 0}) {
    if (workerId < 0 || workerId > maxWorkerId) {
      throw ArgumentError.value(workerId, 'workerId', 'must be 0..1023');
    }
  }

  /// Worker identifier.
  final int workerId;

  /// Maximum worker ID (10 bits).
  static const int maxWorkerId = 1023;

  /// Clock backwards drift tolerated by busy-waiting; larger drifts throw.
  static const int maxBackwardMs = 5;

  static const int _sequenceBits = 12;
  static const int _workerShift = _sequenceBits;
  static const int _sequenceMask = (1 << _sequenceBits) - 1;
  static const int _epoch = 1288834974657;

  int _lastTimestamp = -1;
  int _sequence = 0;

  /// Generate the next ID as a native 64-bit integer.
  ///
  /// Throws [StateError] if the system clock has moved backwards by more
  /// than [maxBackwardMs] milliseconds, rather than risking duplicate or
  /// out-of-order IDs. Prefer the VM/native platform; on the web use
  /// [nextIdString].
  int nextId() {
    final p = _advance();
    // Multiplication keeps the same value as bit shifts on the native VM.
    return p.high * 0x100000000 + p.low;
  }

  /// Generate the next ID formatted as a decimal string.
  ///
  /// This is the platform-independent representation: it never relies on
  /// 32-bit-truncated JS bitwise operators or on integers above 2^53, so
  /// it is safe on the web.
  String nextIdString() {
    final p = _advance();
    return _uint64ToDecimal(p.high, p.low);
  }

  /// Advances the clock/sequence state and returns the ID split into its
  /// upper (above bit 32) and lower 32-bit parts, computed without 32-bit
  /// bitwise truncation so the math is exact on the web as well.
  ({int high, int low}) _advance() {
    var ts = DateTime.now().millisecondsSinceEpoch;
    if (ts < _lastTimestamp) {
      final drift = _lastTimestamp - ts;
      if (drift > maxBackwardMs) {
        throw StateError(
          'Clock moved backwards by $drift ms; refusing to generate a '
          'snowflake id to avoid duplicates / out-of-order values',
        );
      }
      ts = _tilNextMillis(_lastTimestamp);
    }
    if (ts == _lastTimestamp) {
      _sequence = (_sequence + 1) & _sequenceMask;
      if (_sequence == 0) {
        ts = _tilNextMillis(_lastTimestamp);
      }
    } else {
      _sequence = 0;
    }
    _lastTimestamp = ts;

    final relative = ts - _epoch;
    // relative << 22 == (relative ~/ 1024) << 32 + (relative % 1024) << 22
    final high = relative ~/ 1024;
    final low =
        (relative - high * 1024) * (1 << 22) +
        workerId * (1 << _workerShift) +
        _sequence;
    return (high: high, low: low);
  }

  int _tilNextMillis(int last) {
    var ts = DateTime.now().millisecondsSinceEpoch;
    while (ts <= last) {
      ts = DateTime.now().millisecondsSinceEpoch;
    }
    return ts;
  }

  /// Format an unsigned 64-bit integer, given as `[high, low]` 32-bit
  /// parts, as a decimal string using only base-10000 limb arithmetic
  /// (every intermediate product stays below 2^53, so this is exact on
  /// the web too).
  static String _uint64ToDecimal(int high, int low) {
    final limbs = <int>[0]; // base 10000, least significant first
    for (final chunk in [high, low]) {
      var carry = chunk;
      for (var i = 0; i < limbs.length; i++) {
        final value = limbs[i] * 0x100000000 + carry;
        limbs[i] = value % 10000;
        carry = value ~/ 10000;
      }
      while (carry > 0) {
        limbs.add(carry % 10000);
        carry ~/= 10000;
      }
    }
    final buffer = StringBuffer(limbs.last.toString());
    for (var i = limbs.length - 2; i >= 0; i--) {
      buffer.write(limbs[i].toString().padLeft(4, '0'));
    }
    return buffer.toString();
  }
}
