/// Utilities for parsing / formatting dates with zero third-party
/// dependencies. Supports `yyyy MM dd HH mm ss SSS` tokens.
abstract final class DateUtil {
  DateUtil._();

  /// Default format pattern.
  static const String defaultPattern = 'yyyy-MM-dd HH:mm:ss';

  /// Format [dt] using [pattern]. Supported tokens:
  /// `yyyy` `MM` `dd` `HH` `mm` `ss` `SSS`.
  static String format(DateTime dt, [String pattern = defaultPattern]) {
    String pad(int v, int n) => v.toString().padLeft(n, '0');
    return pattern.replaceAllMapped(_tokenPattern, (m) {
      switch (m[0]) {
        case 'yyyy':
          return pad(dt.year, 4);
        case 'MM':
          return pad(dt.month, 2);
        case 'dd':
          return pad(dt.day, 2);
        case 'HH':
          return pad(dt.hour, 2);
        case 'mm':
          return pad(dt.minute, 2);
        case 'ss':
          return pad(dt.second, 2);
        case 'SSS':
          return pad(dt.millisecond, 3);
        default:
          return m[0]!;
      }
    });
  }

  /// Format the current time using [pattern].
  static String formatNow([String pattern = defaultPattern]) =>
      format(DateTime.now(), pattern);

  /// Parse [text] with [pattern]; throws [FormatException] on failure.
  static DateTime parse(String text, [String pattern = defaultPattern]) {
    final dt = tryParse(text, pattern);
    if (dt == null) {
      throw FormatException('Cannot parse "$text" with pattern "$pattern"');
    }
    return dt;
  }

  /// Parse [text] with [pattern]; returns `null` on failure.
  static DateTime? tryParse(String text, [String pattern = defaultPattern]) {
    final tokens = _tokenize(pattern);
    final sb = StringBuffer();
    final names = <String>[];
    for (final t in tokens) {
      if (t is _Token) {
        sb.write('(?<${t.name}>${t.regex})');
        names.add(t.name);
      } else {
        sb.write(RegExp.escape(t as String));
      }
    }
    final re = RegExp('^${sb.toString()}\$');
    final m = re.firstMatch(text);
    if (m == null) return null;
    int? v(String n) =>
        names.contains(n) ? int.tryParse(m.namedGroup(n) ?? '') : null;

    // Fields omitted from [pattern] fall back to epoch-style defaults; fields
    // present in the input must be valid calendar values (no silent overflow
    // such as 2024-02-31 -> 2024-03-02).
    final year = v('year') ?? 1970;
    final month = v('month') ?? 1;
    final day = v('day') ?? 1;
    final hour = v('hour') ?? 0;
    final minute = v('minute') ?? 0;
    final second = v('second') ?? 0;
    final millis = v('millis') ?? 0;

    if (month < 1 || month > 12) return null;
    if (day < 1 || day > _daysInMonth(year, month)) return null;
    if (hour < 0 || hour > 23) return null;
    if (minute < 0 || minute > 59) return null;
    if (second < 0 || second > 59) return null;
    if (millis < 0 || millis > 999) return null;

    return DateTime(year, month, day, hour, minute, second, millis);
  }

  /// Convert [dt] to a Unix timestamp. Returns seconds by default, or
  /// milliseconds when [millis] is `true`.
  static int toTimestamp(DateTime dt, {bool millis = false}) =>
      millis ? dt.millisecondsSinceEpoch : dt.millisecondsSinceEpoch ~/ 1000;

  /// Build a [DateTime] from a Unix timestamp. Assumes seconds by default,
  /// or milliseconds when [millis] is `true`.
  static DateTime fromTimestamp(int ts, {bool millis = false}) =>
      DateTime.fromMillisecondsSinceEpoch(millis ? ts : ts * 1000);

  /// Current Unix timestamp. Seconds by default; [millis] for milliseconds.
  static int nowTimestamp({bool millis = false}) =>
      toTimestamp(DateTime.now(), millis: millis);

  /// Start of today (midnight).
  static DateTime today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// Start of yesterday (midnight).
  static DateTime yesterday() => today().subtract(const Duration(days: 1));

  /// Start of tomorrow (midnight).
  static DateTime tomorrow() => today().add(const Duration(days: 1));

  /// Start of the day containing [dt] (midnight).
  static DateTime startOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  /// End of the day containing [dt]  `23:59:59.999`.
  static DateTime endOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999);

  /// Whether [a] and [b] fall on the same calendar day.
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Whether [a] and [b] fall in the same calendar month.
  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  /// Difference from [start] to [end].
  static Duration between(DateTime start, DateTime end) =>
      end.difference(start);

  /// Whole days between [start] and [end] (may be negative).
  static int betweenDays(DateTime start, DateTime end) =>
      end.difference(start).inDays;

  /// Human-readable relative time, e.g. "just now", "5 minutes ago",
  /// "2 hours ago", "3 days ago", "2 months ago", "1 year ago".
  ///
  /// Future times use the symmetric "in ..." form, e.g. "in a moment",
  /// "in 5 minutes".
  static String relativeTime(DateTime dt, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    final raw = ref.difference(dt);
    final isFuture = raw.isNegative;
    final diff = isFuture ? -raw : raw;

    String unit(int value, String name) =>
        '$value $name${value == 1 ? '' : 's'}';
    String describe(String body) => isFuture ? 'in $body' : '$body ago';

    if (diff.inSeconds < 60) {
      return isFuture ? 'in a moment' : 'just now';
    }
    if (diff.inMinutes < 60) {
      return describe(unit(diff.inMinutes, 'minute'));
    }
    if (diff.inHours < 24) {
      return describe(unit(diff.inHours, 'hour'));
    }
    if (diff.inDays < 30) {
      return describe(unit(diff.inDays, 'day'));
    }
    if (diff.inDays < 365) {
      return describe(unit(diff.inDays ~/ 30, 'month'));
    }
    return describe(unit(diff.inDays ~/ 365, 'year'));
  }

  /// English weekday name: "Monday"  "Sunday".
  static String weekdayName(DateTime dt) => switch (dt.weekday) {
    1 => 'Monday',
    2 => 'Tuesday',
    3 => 'Wednesday',
    4 => 'Thursday',
    5 => 'Friday',
    6 => 'Saturday',
    7 => 'Sunday',
    _ => '',
  };

  // ---------------------------------------------------------------------------
  // Relative predicates (against DateTime.now())
  // ---------------------------------------------------------------------------

  /// Whether [dt] is on today's calendar day.
  static bool isToday(DateTime dt) => isSameDay(dt, DateTime.now());

  /// Whether [dt] is on yesterday's calendar day.
  static bool isYesterday(DateTime dt) =>
      isSameDay(dt, DateTime.now().subtract(const Duration(days: 1)));

  /// Whether [dt] is on tomorrow's calendar day.
  static bool isTomorrow(DateTime dt) =>
      isSameDay(dt, DateTime.now().add(const Duration(days: 1)));

  /// Whether [dt] falls in the current month.
  static bool isThisMonth(DateTime dt) => isSameMonth(dt, DateTime.now());

  /// Whether [dt] falls in the current year.
  static bool isThisYear(DateTime dt) => dt.year == DateTime.now().year;

  // ---------------------------------------------------------------------------
  // Date arithmetic
  // ---------------------------------------------------------------------------

  /// Whole calendar days between [start] and [end], absolute value.
  ///
  /// For a signed difference see [betweenDays].
  static int daysBetween(DateTime start, DateTime end) =>
      end.difference(start).inDays.abs();

  /// Add [days] calendar days to [dt]. Delegates to [DateTime.add] and
  /// preserves DST transitions across the added span.
  static DateTime addDays(DateTime dt, int days) =>
      dt.add(Duration(days: days));

  /// Add [months] calendar months to [dt]. Day values that overflow the
  /// resulting month are clamped to the last valid day.
  ///
  /// Example: `addMonths(2024-01-31, 1)`  `2024-02-29` (leap year clamped).
  static DateTime addMonths(DateTime dt, int months) {
    final total = dt.month - 1 + months;
    final year = dt.year + total ~/ 12;
    final month = (total % 12) + 1;
    final lastDay = _daysInMonth(year, month);
    final day = dt.day > lastDay ? lastDay : dt.day;
    return DateTime(
      year,
      month,
      day,
      dt.hour,
      dt.minute,
      dt.second,
      dt.millisecond,
      dt.microsecond,
    );
  }

  /// Add [years] calendar years to [dt]; Feb 29 in a non-leap target year is
  /// clamped to Feb 28.
  static DateTime addYears(DateTime dt, int years) => addMonths(dt, years * 12);

  /// Copy [dt] with individual fields replaced. Omitting a field keeps the
  /// original value.
  static DateTime copyWith(
    DateTime dt, {
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? dt.year,
      month ?? dt.month,
      day ?? dt.day,
      hour ?? dt.hour,
      minute ?? dt.minute,
      second ?? dt.second,
      millisecond ?? dt.millisecond,
      microsecond ?? dt.microsecond,
    );
  }

  static final RegExp _tokenPattern = RegExp(r'yyyy|SSS|MM|dd|HH|mm|ss');

  static int _daysInMonth(int year, int month) {
    const lengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) {
      return 29;
    }
    return lengths[month - 1];
  }

  static String _tokenRegex(String name) => switch (name) {
    'year' => r'\d{4}',
    'millis' => r'\d{1,3}',
    _ => r'\d{1,2}',
  };

  static List<Object> _tokenize(String pattern) {
    final result = <Object>[];
    var i = 0;
    while (i < pattern.length) {
      final rest = pattern.substring(i);
      String? name;
      var step = 0;
      if (rest.startsWith('yyyy')) {
        name = 'year';
        step = 4;
      } else if (rest.startsWith('SSS')) {
        name = 'millis';
        step = 3;
      } else if (rest.startsWith('MM')) {
        name = 'month';
        step = 2;
      } else if (rest.startsWith('dd')) {
        name = 'day';
        step = 2;
      } else if (rest.startsWith('HH')) {
        name = 'hour';
        step = 2;
      } else if (rest.startsWith('mm')) {
        name = 'minute';
        step = 2;
      } else if (rest.startsWith('ss')) {
        name = 'second';
        step = 2;
      }
      if (name != null) {
        result.add(_Token(name, _tokenRegex(name)));
        i += step;
      } else {
        result.add(pattern[i]);
        i++;
      }
    }
    return result;
  }
}

/// Internal token used by the parser.
class _Token {
  _Token(this.name, this.regex);

  final String name;
  final String regex;
}
