/// 字符串工具类。
///
/// 提供判空、大小写、命名风格转换、裁剪、填充、脱敏等常用能力，
/// 所有方法均做 null 安全处理，避免在业务代码里反复手写判空。
abstract final class StrUtil {
  StrUtil._();

  /// 判断字符串是否为 `null`、空串或仅由空白字符组成。
  static bool isBlank(String? str) => str == null || str.trim().isEmpty;

  /// 判断字符串是否非空白（即 [isBlank] 的反向）。
  static bool isNotBlank(String? str) => !isBlank(str);

  /// 判断字符串是否为 `null` 或空串（`''`），不忽略空白。
  static bool isEmpty(String? str) => str == null || str.isEmpty;

  /// 判断字符串是否非空（即 [isEmpty] 的反向）。
  static bool isNotEmpty(String? str) => !isEmpty(str);

  /// 判断字符串是否全部由十进制数字（`0-9`）组成。
  static bool isNumeric(String? str) {
    if (isBlank(str)) return false;
    return str!.trim().runes.every((r) => r >= 0x30 && r <= 0x39);
  }

  /// null 安全的大写转换，`null` 返回空串。
  static String toUpperCase(String? str) => str?.toUpperCase() ?? '';

  /// null 安全的小写转换，`null` 返回空串。
  static String toLowerCase(String? str) => str?.toLowerCase() ?? '';

  /// 将 `snake_case` / `kebab-case` / 空格分隔的字符串转为驼峰。
  ///
  /// 例：`hello_world` / `hello-world` / `hello world` → `helloWorld`。
  static String toCamelCase(String str) {
    if (str.isEmpty) return str;
    final parts = str
        .split(RegExp(r'[_\-\s]+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    final first = parts.first;
    final lowerFirst =
        first[0].toLowerCase() + first.substring(1).toLowerCase();
    final rest = parts
        .skip(1)
        .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
        .join();
    return lowerFirst + rest;
  }

  /// 将驼峰字符串转为 `snake_case`。
  ///
  /// 例：`helloWorld` → `hello_world`，`XMLHttp` → `x_m_l_h_t_t_p`。
  static String toSnakeCase(String str) {
    if (str.isEmpty) return str;
    final runes = str.runes.toList();
    final sb = StringBuffer();
    for (var i = 0; i < runes.length; i++) {
      final ch = String.fromCharCode(runes[i]);
      if (i > 0 && ch == ch.toUpperCase() && ch != ch.toLowerCase()) {
        sb.write('_');
      }
      sb.write(ch.toLowerCase());
    }
    return sb.toString();
  }

  /// 将驼峰字符串转为 `kebab-case`。
  ///
  /// 例：`helloWorld` → `hello-world`。
  static String toKebabCase(String str) =>
      toSnakeCase(str).replaceAll('_', '-');

  /// null 安全的去除首尾空白。
  static String trim(String? str) => str?.trim() ?? '';

  /// 去除头部空白。
  static String trimStart(String? str) =>
      str?.replaceFirst(RegExp(r'^\s+'), '') ?? '';

  /// 去除尾部空白。
  static String trimEnd(String? str) =>
      str?.replaceFirst(RegExp(r'\s+$'), '') ?? '';

  /// 截断字符串，超出 [maxLength] 的部分以 [ellipsis] 代替。
  static String truncate(String str, int maxLength, {String ellipsis = '...'}) {
    if (maxLength < 0) throw ArgumentError.value(maxLength, 'maxLength');
    if (str.length <= maxLength) return str;
    return str.substring(0, maxLength) + ellipsis;
  }

  /// 左侧填充至指定宽度。
  static String padLeft(String str, int width, [String padding = ' ']) =>
      str.padLeft(width, padding);

  /// 右侧填充至指定宽度。
  static String padRight(String str, int width, [String padding = ' ']) =>
      str.padRight(width, padding);

  /// 重复字符串 [count] 次。
  static String repeat(String str, int count) => str * count;

  /// 首字母大写，其余保持不变。
  static String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  /// 首字母小写，其余保持不变。
  static String uncapitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toLowerCase() + str.substring(1);
  }

  /// 忽略大小写判断 [source] 是否包含 [target]。
  static bool containsIgnoreCase(String source, String target) =>
      source.toLowerCase().contains(target.toLowerCase());

  /// 忽略大小写比较两个字符串是否相等。
  static bool equalsIgnoreCase(String? a, String? b) =>
      (a ?? '').toLowerCase() == (b ?? '').toLowerCase();

  /// 脱敏中间部分，保留首尾 [left] / [right] 位。
  ///
  /// 例：`hide('13812345678', 3, 4)` → `138****5678`。
  static String hide(String str, int left, int right, {String mask = '****'}) {
    if (str.length <= left + right) return mask;
    return str.substring(0, left) + mask + str.substring(str.length - right);
  }
}
