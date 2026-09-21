import 'dart:math';

/// ID 生成工具类。
///
/// 零第三方依赖实现 UUID v4、短随机 ID 与雪花 ID。
abstract final class IdUtil {
  IdUtil._();

  static final Random _random = Random.secure();

  /// 生成 UUID v4（带连字符，小写）。
  static String uuid() {
    final b = List<int>.generate(16, (_) => _random.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40; // version 4
    b[8] = (b[8] & 0x3f) | 0x80; // variant 10xx
    final hex = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  /// 生成无连字符的 UUID v4（32 位十六进制）。
  static String simpleUuid() => uuid().replaceAll('-', '');

  /// 从 [charset] 中随机生成 [length] 位 ID。
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

  /// 创建一个雪花 ID 生成器（[workerId] 取值 0..1023）。
  static SnowflakeIdGenerator snowflake({int workerId = 0}) =>
      SnowflakeIdGenerator(workerId: workerId);
}

/// 雪花 ID 生成器。
///
/// 64 位 ID：41 位毫秒时间戳 + 10 位机器 ID + 12 位自增序列。
/// 单机单调递增、趋势递增，适合作为分布式主键。
class SnowflakeIdGenerator {
  /// [workerId] 范围 0..1023。
  SnowflakeIdGenerator({this.workerId = 0}) {
    if (workerId < 0 || workerId > maxWorkerId) {
      throw ArgumentError.value(workerId, 'workerId', 'must be 0..1023');
    }
  }

  /// 机器 ID。
  final int workerId;

  /// 机器 ID 最大值（10 位）。
  static const int maxWorkerId = 1023;

  static const int _sequenceBits = 12;
  static const int _workerShift = _sequenceBits;
  static const int _timestampShift = _sequenceBits + 10;
  static const int _sequenceMask = (1 << _sequenceBits) - 1;
  static const int _epoch = 1288834974657; // Twitter snowflake epoch

  int _lastTimestamp = -1;
  int _sequence = 0;

  /// 生成下一个 ID。
  int nextId() {
    var ts = DateTime.now().millisecondsSinceEpoch;
    if (ts < _lastTimestamp) {
      // 简单时钟回拨处理：等待追平
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
