/// 集合（List / Set / Iterable）工具类。
abstract final class CollectionUtil {
  CollectionUtil._();

  /// 判断集合是否为 `null` 或为空。
  static bool isEmpty(Iterable<Object?>? coll) => coll == null || coll.isEmpty;

  /// 判断集合是否非空（即 [isEmpty] 的反向）。
  static bool isNotEmpty(Iterable<Object?>? coll) => !isEmpty(coll);

  /// 判断集合是否为 `null` 或为空（[isEmpty] 的别名，语义更明确）。
  static bool isNullOrEmpty(Iterable<Object?>? coll) => isEmpty(coll);

  /// 去重并保持原有顺序。
  static List<T> distinct<T>(Iterable<T> iter) {
    final seen = <T>{};
    return iter.where(seen.add).toList();
  }

  /// 按 [keyOf] 返回的键对元素分组，得到 `key -> List<T>` 映射。
  static Map<K, List<T>> groupBy<T, K>(Iterable<T> iter, K Function(T) keyOf) {
    final map = <K, List<T>>{};
    for (final e in iter) {
      map.putIfAbsent(keyOf(e), () => <T>[]).add(e);
    }
    return map;
  }

  /// 将集合按 [size] 分块，返回若干子列表；最后一个块可能不足 [size]。
  static List<List<T>> chunk<T>(Iterable<T> iter, int size) {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'must be greater than 0');
    }
    final result = <List<T>>[];
    var current = <T>[];
    for (final e in iter) {
      current.add(e);
      if (current.length == size) {
        result.add(current);
        current = <T>[];
      }
    }
    if (current.isNotEmpty) result.add(current);
    return result;
  }

  /// 扁平化嵌套集合为单层列表。
  static List<T> flatten<T>(Iterable<Iterable<T>> nested) => [
    for (final l in nested) ...l,
  ];

  /// 返回首个元素；集合为空返回 `null`。
  static T? firstOrNull<T>(Iterable<T> iter) =>
      iter.isEmpty ? null : iter.first;

  /// 返回末个元素；集合为空返回 `null`。
  static T? lastOrNull<T>(Iterable<T> iter) => iter.isEmpty ? null : iter.last;

  /// 返回索引 [index] 处的元素；越界或为负返回 `null`。
  static T? elementAtOrNull<T>(Iterable<T> iter, int index) {
    if (index < 0) return null;
    var i = 0;
    for (final e in iter) {
      if (i == index) return e;
      i++;
    }
    return null;
  }

  /// 返回索引 [index] 处的元素；越界返回 [fallback]。
  static T getOrDefault<T>(Iterable<T> iter, int index, T fallback) =>
      elementAtOrNull(iter, index) ?? fallback;

  /// 按 [keyOf] 提取的键排序（默认升序，[desc] 为 `true` 时降序）。
  static List<T> sortBy<T, K extends Comparable<K>>(
    Iterable<T> iter,
    K Function(T) keyOf, {
    bool desc = false,
  }) {
    final list = iter.toList();
    list.sort((a, b) {
      final c = keyOf(a).compareTo(keyOf(b));
      return desc ? -c : c;
    });
    return list;
  }

  /// 以 [keys] 与 [values] 一一对应构造映射；以较短者为准。
  static Map<K, V> toMap<K, V>(Iterable<K> keys, Iterable<V> values) {
    final kit = keys.iterator;
    final vit = values.iterator;
    final map = <K, V>{};
    while (kit.moveNext() && vit.moveNext()) {
      map[kit.current] = vit.current;
    }
    return map;
  }

  /// 统计满足 [predicate] 的元素个数。
  static int countWhere<T>(Iterable<T> iter, bool Function(T) predicate) =>
      iter.where(predicate).length;
}
