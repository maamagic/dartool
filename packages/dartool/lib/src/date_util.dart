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
    int v(String n) =>
        names.contains(n) ? int.tryParse(m.namedGroup(n) ?? '') ?? 0 : 0;
    final year = v('year') == 0 ? 1970 : v('year');
    return DateTime(
      year,
      _clamp(v('month'), 1, 12),
      _clamp(v('day'), 1, 31),
      v('hour'),
      v('minute'),
      v('second'),
      v('millis'),
    );
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

  /// End of the day containing [dt] — `23:59:59.999`.
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
  static String relativeTime(DateTime dt, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    final diff = ref.difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60)
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    if (diff.inHours < 24)
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    if (diff.inDays < 30)
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    if (diff.inDays < 365)
      return '${diff.inDays ~/ 30} month${diff.inDays ~/ 30 == 1 ? '' : 's'} ago';
    return '${diff.inDays ~/ 365} year${diff.inDays ~/ 365 == 1 ? '' : 's'} ago';
  }

  /// English weekday name: "Monday" … "Sunday".
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

  static final RegExp _tokenPattern = RegExp(r'yyyy|SSS|MM|dd|HH|mm|ss');

  static int _clamp(int v, int min, int max) =>
      v < min ? min : (v > max ? max : v);

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
