import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  final fixed = DateTime(2026, 9, 21, 14, 5, 7, 123);

  group('DateUtil.format', () {
    test('默认格式', () {
      expect(DateUtil.format(fixed), '2026-09-21 14:05:07');
    });

    test('自定义格式与毫秒', () {
      expect(DateUtil.format(fixed, 'yyyy/MM/dd'), '2026/09/21');
      expect(DateUtil.format(fixed, 'HH:mm:ss.SSS'), '14:05:07.123');
    });
  });

  group('DateUtil.parse', () {
    test('tryParse 成功与失败', () {
      expect(
        DateUtil.tryParse('2026-09-21 14:05:07'),
        DateTime(2026, 9, 21, 14, 5, 7),
      );
      expect(
        DateUtil.tryParse('2026/09/21', 'yyyy/MM/dd'),
        DateTime(2026, 9, 21),
      );
      expect(DateUtil.tryParse('not-a-date'), isNull);
    });

    test('parse 失败抛异常', () {
      expect(() => DateUtil.parse('bad'), throwsFormatException);
    });
  });

  group('DateUtil 时间戳', () {
    test('toTimestamp / fromTimestamp 往返', () {
      final sec = DateUtil.toTimestamp(fixed);
      final ms = DateUtil.toTimestamp(fixed, millis: true);
      expect(sec, fixed.millisecondsSinceEpoch ~/ 1000);
      expect(ms, fixed.millisecondsSinceEpoch);
      expect(DateUtil.fromTimestamp(sec), DateTime(2026, 9, 21, 14, 5, 7));
      expect(DateUtil.fromTimestamp(ms, millis: true), fixed);
    });
  });

  group('DateUtil 日期运算', () {
    test('startOfDay / endOfDay / isSameDay', () {
      expect(DateUtil.startOfDay(fixed), DateTime(2026, 9, 21));
      expect(DateUtil.endOfDay(fixed).hour, 23);
      expect(DateUtil.isSameDay(fixed, DateTime(2026, 9, 21, 0)), isTrue);
      expect(DateUtil.isSameMonth(fixed, DateTime(2026, 9, 30)), isTrue);
      expect(DateUtil.betweenDays(DateTime(2026, 9, 20), fixed), 1);
    });

    test('relativeTime', () {
      final now = DateTime(2026, 9, 21, 12, 0, 0);
      expect(
        DateUtil.relativeTime(now.subtract(Duration(seconds: 5)), now: now),
        'just now',
      );
      expect(
        DateUtil.relativeTime(now.subtract(Duration(minutes: 5)), now: now),
        '5 minutes ago',
      );
      expect(
        DateUtil.relativeTime(now.subtract(Duration(hours: 3)), now: now),
        '3 hours ago',
      );
      expect(
        DateUtil.relativeTime(now.subtract(Duration(days: 2)), now: now),
        '2 days ago',
      );
      expect(
        DateUtil.relativeTime(now.subtract(Duration(days: 60)), now: now),
        '2 months ago',
      );
    });

    test('weekdayName', () {
      expect(DateUtil.weekdayName(DateTime(2026, 9, 21)), 'Monday');
    });
  });
}
