import 'dart:math';

/// List-specific helpers. For general [Iterable] and [Map] helpers see
/// [CollectionUtil] and [MapUtil].
class ListUtil {
  ListUtil._();

  /// Partition [list] into [chunkSize]-sized sub-lists. The final chunk may
  /// be shorter when [list] length is not a multiple of [chunkSize].
  ///
  /// Returns an empty list when [chunkSize] <= 0 or [list] is empty.
  static List<List<T>> chunked<T>(List<T> list, int chunkSize) {
    if (chunkSize <= 0 || list.isEmpty) return <List<T>>[];
    final result = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, list.length);
      result.add(list.sublist(i, end));
    }
    return result;
  }

  /// Partition [list] into [n] sub-lists of roughly equal size.
  ///
  /// If [n] > [list].length the result is a list of [list].length single-
  /// element lists padded with empty lists. Passing [n] <= 0 returns a
  /// one-element list containing [list].
  static List<List<T>> partition<T>(List<T> list, int n) {
    if (n <= 0) return [List<T>.from(list)];
    if (list.isEmpty) return List<List<T>>.filled(n, <T>[]);
    final result = <List<T>>[];
    final base = list.length ~/ n;
    final extra = list.length % n;
    var start = 0;
    for (var i = 0; i < n; i++) {
      final size = base + (i < extra ? 1 : 0);
      final end = (start + size).clamp(0, list.length);
      result.add(list.sublist(start, end));
      start = end;
    }
    return result;
  }

  /// Insert [item] at [index], clamped to `0..list.length`.
  static void insertSafe<T>(List<T> list, int index, T item) {
    final i = index.clamp(0, list.length);
    list.insert(i, item);
  }

  /// Remove and return the element at [index], or [orElse] if the index is
  /// out of range.
  static T? removeAtSafe<T>(List<T> list, int index, {T Function()? orElse}) {
    if (index < 0 || index >= list.length) {
      return orElse?.call();
    }
    return list.removeAt(index);
  }

  /// Swap two elements in [list] at indices [a] and [b].
  static void swap<T>(List<T> list, int a, int b) {
    if (a < 0 || a >= list.length || b < 0 || b >= list.length) return;
    final t = list[a];
    list[a] = list[b];
    list[b] = t;
  }

  /// Shuffle a copy of [list] and return it.
  static List<T> shuffled<T>(List<T> list, [Random? random]) {
    final copy = List<T>.from(list);
    copy.shuffle(random);
    return copy;
  }

  /// Return a new list with [list]'s elements in reverse order.
  static List<T> reversed<T>(List<T> list) => List<T>.from(list.reversed);

  /// Return the element at [index], or [orElse()] when out of range.
  static T elementAtOrElse<T>(
    List<T> list,
    int index,
    T Function(int index) orElse,
  ) {
    if (index < 0 || index >= list.length) return orElse(index);
    return list[index];
  }

  /// Return the first element satisfying [test], or null.
  static T? firstOrNull<T>(List<T> list, bool Function(T) test) {
    for (final item in list) {
      if (test(item)) return item;
    }
    return null;
  }

  /// Return the last element satisfying [test], or null.
  static T? lastOrNull<T>(List<T> list, bool Function(T) test) {
    for (var i = list.length - 1; i >= 0; i--) {
      if (test(list[i])) return list[i];
    }
    return null;
  }
}
