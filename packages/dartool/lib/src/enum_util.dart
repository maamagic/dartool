/// 枚举工具类。
///
/// 在 Dart 3 原生 `Enum.name` / `Enum.byName` 基础上提供 null 安全
/// 的按名、按序解析，避免越界抛异常。
abstract final class EnumUtil {
  EnumUtil._();

  /// 按名称查找枚举值；不存在返回 `null`。
  static T? byName<T extends Enum>(List<T> values, String name) {
    for (final v in values) {
      if (v.name == name) return v;
    }
    return null;
  }

  /// 按名称查找枚举值；不存在抛 [ArgumentError]。
  static T byNameOrThrow<T extends Enum>(List<T> values, String name) {
    final v = byName(values, name);
    if (v == null) {
      throw ArgumentError.value(name, 'name', 'no such enum value: $name');
    }
    return v;
  }

  /// 按索引查找枚举值；越界返回 `null`。
  static T? byIndex<T extends Enum>(List<T> values, int index) {
    if (index < 0 || index >= values.length) return null;
    return values[index];
  }

  /// 枚举值的名称列表。
  static List<String> names<T extends Enum>(List<T> values) =>
      values.map((v) => v.name).toList();

  /// 是否包含名为 [name] 的枚举值。
  static bool contains<T extends Enum>(List<T> values, String name) =>
      byName(values, name) != null;
}
