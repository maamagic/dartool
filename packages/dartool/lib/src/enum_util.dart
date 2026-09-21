/// Enum utilities.
///
/// Provides null-safe by-name and by-index lookups on top of Dart 3's native
/// `Enum.name` / `Enum.byName`, to avoid exceptions on misses.
abstract final class EnumUtil {
  EnumUtil._();

  /// Find an enum value by [name]; returns `null` if not found.
  static T? byName<T extends Enum>(List<T> values, String name) {
    for (final v in values) {
      if (v.name == name) return v;
    }
    return null;
  }

  /// Find an enum value by [name]; throws [ArgumentError] if not found.
  static T byNameOrThrow<T extends Enum>(List<T> values, String name) {
    final v = byName(values, name);
    if (v == null) {
      throw ArgumentError.value(name, 'name', 'no such enum value: $name');
    }
    return v;
  }

  /// Find an enum value by [index]; returns `null` if out of bounds.
  static T? byIndex<T extends Enum>(List<T> values, int index) {
    if (index < 0 || index >= values.length) return null;
    return values[index];
  }

  /// Names of all enum values as a `List<String>`.
  static List<String> names<T extends Enum>(List<T> values) =>
      values.map((v) => v.name).toList();

  /// Whether an enum value named [name] exists.
  static bool contains<T extends Enum>(List<T> values, String name) =>
      byName(values, name) != null;
}
