/// Collection (List / Set / Iterable) utilities.
abstract final class CollectionUtil {
  CollectionUtil._();

  /// Whether [coll] is `null` or empty.
  static bool isEmpty(Iterable<Object?>? coll) => coll == null || coll.isEmpty;

  /// Whether [coll] is non-empty (inverse of [isEmpty]).
  static bool isNotEmpty(Iterable<Object?>? coll) => !isEmpty(coll);

  /// Alias of [isEmpty]; semantically more explicit for nullable collections.
  static bool isNullOrEmpty(Iterable<Object?>? coll) => isEmpty(coll);

  /// Remove duplicates while preserving original order.
  static List<T> distinct<T>(Iterable<T> iter) {
    final seen = <T>{};
    return iter.where(seen.add).toList();
  }

  /// Group elements by the key returned by [keyOf], producing a
  /// `Map<K, List<T>>`.
  static Map<K, List<T>> groupBy<T, K>(Iterable<T> iter, K Function(T) keyOf) {
    final map = <K, List<T>>{};
    for (final e in iter) {
      map.putIfAbsent(keyOf(e), () => <T>[]).add(e);
    }
    return map;
  }

  /// Split [iter] into chunks of [size]; the last chunk may be smaller.
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

  /// Flatten a nested iterable into a single-level list.
  static List<T> flatten<T>(Iterable<Iterable<T>> nested) => [
    for (final l in nested) ...l,
  ];

  /// Returns the first element, or `null` if [iter] is empty.
  static T? firstOrNull<T>(Iterable<T> iter) =>
      iter.isEmpty ? null : iter.first;

  /// Returns the last element, or `null` if [iter] is empty.
  static T? lastOrNull<T>(Iterable<T> iter) => iter.isEmpty ? null : iter.last;

  /// Returns the element at [index], or `null` if out of bounds / negative.
  static T? elementAtOrNull<T>(Iterable<T> iter, int index) {
    if (index < 0) return null;
    var i = 0;
    for (final e in iter) {
      if (i == index) return e;
      i++;
    }
    return null;
  }

  /// Returns the element at [index], or [fallback] if out of bounds.
  static T getOrDefault<T>(Iterable<T> iter, int index, T fallback) =>
      elementAtOrNull(iter, index) ?? fallback;

  /// Sort by the key extracted via [keyOf] (ascending by default; set [desc]
  /// to `true` for descending).
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

  /// Build a `Map<K, V>` from paired [keys] and [values]; the shorter
  /// iterable determines the length.
  static Map<K, V> toMap<K, V>(Iterable<K> keys, Iterable<V> values) {
    final kit = keys.iterator;
    final vit = values.iterator;
    final map = <K, V>{};
    while (kit.moveNext() && vit.moveNext()) {
      map[kit.current] = vit.current;
    }
    return map;
  }

  /// Count elements matching [predicate].
  static int countWhere<T>(Iterable<T> iter, bool Function(T) predicate) =>
      iter.where(predicate).length;
}
