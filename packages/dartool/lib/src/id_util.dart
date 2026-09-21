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

  static const int _sequenceBits = 12;
  static const int _workerShift = _sequenceBits;
  static const int _timestampShift = _sequenceBits + 10;
  static const int _sequenceMask = (1 << _sequenceBits) - 1;
  static const int _epoch = 1288834974657;

  int _lastTimestamp = -1;
  int _sequence = 0;

  /// Generate the next ID.
  int nextId() {
    var ts = DateTime.now().millisecondsSinceEpoch;
    if (ts < _lastTimestamp) {
      ts = _lastTimestamp;
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
    return ((ts - _epoch) << _timestampShift) |
        (workerId << _workerShift) |
        _sequence;
  }

  int _tilNextMillis(int last) {
    var ts = DateTime.now().millisecondsSinceEpoch;
    while (ts <= last) {
      ts = DateTime.now().millisecondsSinceEpoch;
    }
    return ts;
  }
}
