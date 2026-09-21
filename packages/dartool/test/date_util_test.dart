import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  final fixed = DateTime(2026, 9, 21, 14, 5, 7, 123);

  group('DateUtil.format', () {
    test(' ', () {
      expect(DateUtil.format(fixed), '2026-09-21 14:05:07');
    });

    test(' ', () {
      expect(DateUtil.format(fixed, 'yyyy/MM/dd'), '2026/09/21');
      expect(DateUtil.format(fixed, 'HH:mm:ss.SSS'), '14:05:07.123');
    });
  });

  group('DateUtil.parse', () {
    test('tryParse ', () {
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

    test('parse ', () {
      expect(() => DateUtil.parse('bad'), throwsFormatException);
    });
  });

  group('DateUtil ', () {
    test('toTimestamp / fromTimestamp ', () {
      final sec = DateUtil.toTimestamp(fixed);
      final ms = DateUtil.toTimestamp(fixed, millis: true);
      expect(sec, fixed.millisecondsSinceEpoch ~/ 1000);
      expect(ms, fixed.millisecondsSinceEpoch);
      expect(DateUtil.fromTimestamp(sec), DateTime(2026, 9, 21, 14, 5, 7));
      expect(DateUtil.fromTimestamp(ms, millis: true), fixed);
    });
  });

  group('DateUtil ', () {
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

  group('DateUtil date arithmetic', () {
    test('daysBetween absolute', () {
      expect(
        DateUtil.daysBetween(DateTime(2026, 9, 20), DateTime(2026, 9, 22)),
        2,
      );
      expect(
        DateUtil.daysBetween(DateTime(2026, 9, 22), DateTime(2026, 9, 20)),
        2,
      );
    });

    test('addDays', () {
      expect(DateUtil.addDays(DateTime(2026, 9, 21), 3), DateTime(2026, 9, 24));
    });

    test('addMonths clamps to last valid day', () {
      expect(
        DateUtil.addMonths(DateTime(2024, 1, 31), 1),
        DateTime(2024, 2, 29),
      );
      expect(
        DateUtil.addMonths(DateTime(2023, 1, 31), 1),
        DateTime(2023, 2, 28),
      );
      expect(
        DateUtil.addMonths(DateTime(2024, 12, 15), 2),
        DateTime(2025, 2, 15),
      );
    });

    test('addYears uses addMonths underneath', () {
      expect(
        DateUtil.addYears(DateTime(2024, 2, 29), 1),
        DateTime(2025, 2, 28),
      );
      expect(DateUtil.addYears(DateTime(2024, 1, 1), 2), DateTime(2026, 1, 1));
    });

    test('copyWith replaces individual fields', () {
      final dt = DateTime(2026, 9, 21, 14, 5, 7);
      expect(
        DateUtil.copyWith(dt, year: 2027),
        DateTime(2027, 9, 21, 14, 5, 7),
      );
      expect(
        DateUtil.copyWith(dt, month: 12, day: 31),
        DateTime(2026, 12, 31, 14, 5, 7),
      );
      expect(DateUtil.copyWith(dt), dt);
    });

    test('isToday / isYesterday / isTomorrow / isThisYear', () {
      final now = DateTime.now();
      expect(DateUtil.isToday(now), isTrue);
      expect(DateUtil.isToday(now.subtract(const Duration(days: 1))), isFalse);
      expect(
        DateUtil.isYesterday(now.subtract(const Duration(days: 1))),
        isTrue,
      );
      expect(DateUtil.isTomorrow(now.add(const Duration(days: 1))), isTrue);
      expect(DateUtil.isThisYear(now), isTrue);
      expect(DateUtil.isThisYear(DateTime(now.year - 1, 1, 1)), isFalse);
    });
  });
}
