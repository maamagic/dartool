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

  // ---------------------------------------------------------------------------
  // Conversion helpers
  // ---------------------------------------------------------------------------

  /// Convert [iter] to a `List<T>`; handles `null` safely.
  static List<T> toList<T>(Iterable<T>? iter) => iter?.toList() ?? <T>[];

  /// Convert [iter] to a `Set<T>`; handles `null` safely.
  static Set<T> toSet<T>(Iterable<T>? iter) => iter?.toSet() ?? <T>{};

  /// Build a string by joining the stringification of each element with
  /// [separator].
  static String joinToString<T>(Iterable<T> iter, {String separator = ','}) =>
      iter.map((e) => e.toString()).join(separator);

  // ---------------------------------------------------------------------------
  // Aggregates
  // ---------------------------------------------------------------------------

  /// Sum of numeric elements extracted from each item via [numOf].
  ///
  /// Supports both `int` and `double` result types; an empty iterable yields
  /// `0` for `int` / `num` and `0.0` for `double`.
  static N sumOf<T, N extends num>(Iterable<T> iter, N Function(T) numOf) {
    num total = 0;
    for (final e in iter) {
      total += numOf(e);
    }
    if (total == 0 && <N>[] is List<double>) {
      return 0.0 as N;
    }
    return total as N;
  }

  /// Average of numeric elements extracted from each item via [numOf].
  /// Returns `0.0` when [iter] is empty.
  static double averageOf<T>(Iterable<T> iter, num Function(T) numOf) {
    var count = 0;
    double total = 0;
    for (final e in iter) {
      total += numOf(e);
      count++;
    }
    return count == 0 ? 0.0 : total / count;
  }

  /// Element in [iter] with the smallest value of [keyOf]. Returns `null` if
  /// [iter] is empty.
  static T? minOf<T, K extends Comparable<K>>(
    Iterable<T> iter,
    K Function(T) keyOf,
  ) {
    T? best;
    K? bestKey;
    for (final e in iter) {
      final k = keyOf(e);
      if (bestKey == null || k.compareTo(bestKey) < 0) {
        best = e;
        bestKey = k;
      }
    }
    return best;
  }

  /// Element in [iter] with the largest value of [keyOf]. Returns `null` if
  /// [iter] is empty.
  static T? maxOf<T, K extends Comparable<K>>(
    Iterable<T> iter,
    K Function(T) keyOf,
  ) {
    T? best;
    K? bestKey;
    for (final e in iter) {
      final k = keyOf(e);
      if (bestKey == null || k.compareTo(bestKey) > 0) {
        best = e;
        bestKey = k;
      }
    }
    return best;
  }

  // ---------------------------------------------------------------------------
  // Other helpers
  // ---------------------------------------------------------------------------

  /// Build a list by applying [transform] to every element of [iter].
  static List<R> mapList<T, R>(Iterable<T> iter, R Function(T) transform) =>
      iter.map(transform).toList();

  /// Build a list of elements for which [predicate] returns `true`.
  static List<T> filter<T>(Iterable<T> iter, bool Function(T) predicate) =>
      iter.where(predicate).toList();

  /// Whether every element in [iter] satisfies [predicate].
  static bool all<T>(Iterable<T> iter, bool Function(T) predicate) {
    for (final e in iter) {
      if (!predicate(e)) return false;
    }
    return true;
  }

  /// Whether at least one element in [iter] satisfies [predicate].
  static bool any<T>(Iterable<T> iter, bool Function(T) predicate) {
    for (final e in iter) {
      if (predicate(e)) return true;
    }
    return false;
  }

  /// Remove elements that are `null` from [iter] and cast to `List<T>`.
  static List<T> whereNotNull<T>(Iterable<T?> iter) {
    final result = <T>[];
    for (final e in iter) {
      if (e != null) result.add(e);
    }
    return result;
  }
}
