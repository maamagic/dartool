import 'dart:collection';

/// Set algebra helpers 鈥?union / intersection / difference / symmetric
/// difference 鈥?plus a few convenient constructors that preserve order via
/// [LinkedHashSet].
class SetUtil {
  SetUtil._();

  /// Union of [a] and [b] 鈥?every element present in either set.
  static Set<T> union<T>(Set<T> a, Set<T> b) => {...a, ...b};

  /// Intersection of [a] and [b] 鈥?elements present in both sets.
  static Set<T> intersection<T>(Set<T> a, Set<T> b) => a.intersection(b);

  /// [a] minus [b] 鈥?elements in [a] that are not in [b].
  static Set<T> difference<T>(Set<T> a, Set<T> b) => a.difference(b);

  /// Symmetric difference 鈥?elements in either [a] or [b] but not both.
  static Set<T> symmetricDifference<T>(Set<T> a, Set<T> b) => {
    ...a.where((e) => !b.contains(e)),
    ...b.where((e) => !a.contains(e)),
  };

  /// Build a [LinkedHashSet] from [source], preserving iteration order.
  static Set<T> from<T>(Iterable<T> source) => LinkedHashSet<T>.of(source);

  /// Build a [LinkedHashSet] from [source], applying [transform] to each
  /// element first.
  static Set<R> fromMap<T, R>(Iterable<T> source, R Function(T) transform) =>
      LinkedHashSet<R>.of(source.map(transform));

  /// Remove [source] elements that satisfy [test]. Returns the removed count.
  static int removeWhere<T>(Set<T> source, bool Function(T) test) {
    final toRemove = <T>[];
    for (final e in source) {
      if (test(e)) toRemove.add(e);
    }
    toRemove.forEach(source.remove);
    return toRemove.length;
  }
}
