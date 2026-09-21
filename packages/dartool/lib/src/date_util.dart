/// 日期时间工具类。
///
/// 零第三方依赖实现常用格式化、解析、时间戳转换、相对时间等能力。
abstract final class DateUtil {
  DateUtil._();

  /// 默认格式。
  static const String defaultPattern = 'yyyy-MM-dd HH:mm:ss';

  /// 按 [pattern] 格式化时间。
  ///
  /// 支持的占位符：`yyyy` `MM` `dd` `HH` `mm` `ss` `SSS`。
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

  /// 以 [pattern] 格式化当前时间。
  static String formatNow([String pattern = defaultPattern]) =>
      format(DateTime.now(), pattern);

  /// 解析字符串为时间；失败抛 [FormatException]。
  static DateTime parse(String text, [String pattern = defaultPattern]) {
    final dt = tryParse(text, pattern);
    if (dt == null) {
      throw FormatException('Cannot parse "$text" with pattern "$pattern"');
    }
    return dt;
  }

  /// 解析字符串为时间；失败返回 `null`。
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

  /// 转为时间戳。默认秒级，[millis] 为 `true` 时毫秒级。
  static int toTimestamp(DateTime dt, {bool millis = false}) =>
      millis ? dt.millisecondsSinceEpoch : dt.millisecondsSinceEpoch ~/ 1000;

  /// 从时间戳构造时间。默认秒级，[millis] 为 `true` 时毫秒级。
  static DateTime fromTimestamp(int ts, {bool millis = false}) =>
      DateTime.fromMillisecondsSinceEpoch(millis ? ts : ts * 1000);

  /// 当前时间戳。默认秒级，[millis] 为 `true` 时毫秒级。
  static int nowTimestamp({bool millis = false}) =>
      toTimestamp(DateTime.now(), millis: millis);

  /// 今天零点。
  static DateTime today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// 昨天零点。
  static DateTime yesterday() => today().subtract(const Duration(days: 1));

  /// 明天零点。
  static DateTime tomorrow() => today().add(const Duration(days: 1));

  /// 当天零点。
  static DateTime startOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  /// 当天最后一毫秒（`23:59:59.999`）。
  static DateTime endOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999);

  /// 是否同一天。
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// 是否同一个月。
  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  /// 计算 [start] 到 [end] 的差值。
  static Duration between(DateTime start, DateTime end) =>
      end.difference(start);

  /// 计算 [start] 到 [end] 相差的整天数（可能为负）。
  static int betweenDays(DateTime start, DateTime end) =>
      end.difference(start).inDays;

  /// 相对时间（中文），如"刚刚 / 5分钟前 / 3小时前 / 2天前 / 4个月前 / 1年前"。
  static String relativeTime(DateTime dt, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    final diff = ref.difference(dt);
    if (diff.inSeconds < 60) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 30) return '${diff.inDays}天前';
    if (diff.inDays < 365) return '${diff.inDays ~/ 30}个月前';
    return '${diff.inDays ~/ 365}年前';
  }

  /// 星期名称（中文），如"周一"。
  static String weekdayName(DateTime dt) => switch (dt.weekday) {
    1 => '周一',
    2 => '周二',
    3 => '周三',
    4 => '周四',
    5 => '周五',
    6 => '周六',
    7 => '周日',
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

/// 解析用内部 token。
class _Token {
  _Token(this.name, this.regex);

  final String name;
  final String regex;
}
