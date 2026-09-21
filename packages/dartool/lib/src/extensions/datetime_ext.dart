import '../date_util.dart';

/// Extension APIs mirroring [DateUtil].
extension DartoolDateTime on DateTime {
  bool get isToday => DateUtil.isToday(this);
  bool get isYesterday => DateUtil.isYesterday(this);
  bool get isTomorrow => DateUtil.isTomorrow(this);
  bool get isThisMonth => DateUtil.isThisMonth(this);
  bool get isThisYear => DateUtil.isThisYear(this);
  bool isSameDayAs(DateTime other) => DateUtil.isSameDay(this, other);
  bool isSameMonthAs(DateTime other) => DateUtil.isSameMonth(this, other);

  int daysBetween(DateTime other) => DateUtil.daysBetween(this, other);
  int betweenDays(DateTime other) => DateUtil.betweenDays(this, other);
  Duration between(DateTime other) => DateUtil.between(this, other);

  DateTime get startOfDay => DateUtil.startOfDay(this);
  DateTime get endOfDay => DateUtil.endOfDay(this);

  DateTime addDays(int days) => DateUtil.addDays(this, days);
  DateTime addMonths(int months) => DateUtil.addMonths(this, months);
  DateTime addYears(int years) => DateUtil.addYears(this, years);

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) => DateUtil.copyWith(
    this,
    year: year,
    month: month,
    day: day,
    hour: hour,
    minute: minute,
    second: second,
    millisecond: millisecond,
    microsecond: microsecond,
  );

  String format([String pattern = DateUtil.defaultPattern]) =>
      DateUtil.format(this, pattern);
  String relativeTime({DateTime? now}) => DateUtil.relativeTime(this, now: now);
  String get weekdayName => DateUtil.weekdayName(this);
  int toTimestamp({bool millis = false}) =>
      DateUtil.toTimestamp(this, millis: millis);
}
