import '../collection_util.dart';

/// Extension APIs mirroring [CollectionUtil] for [Iterable].
extension DartoolIterable<T> on Iterable<T> {
  List<T> toListOrEmpty() => CollectionUtil.toList(this);
  Set<T> toSetOrEmpty() => CollectionUtil.toSet(this);
  String joinToString({String separator = ','}) =>
      CollectionUtil.joinToString(this, separator: separator);
  bool get isEmpty => CollectionUtil.isEmpty(this);
  bool get isNotEmpty => CollectionUtil.isNotEmpty(this);
  int countWhere(bool Function(T) predicate) =>
      CollectionUtil.countWhere(this, predicate);
  bool all(bool Function(T) predicate) => CollectionUtil.all(this, predicate);
  bool any(bool Function(T) predicate) => CollectionUtil.any(this, predicate);
  List<T> filter(bool Function(T) predicate) =>
      CollectionUtil.filter(this, predicate);
  List<R> mapList<R>(R Function(T) transform) =>
      CollectionUtil.mapList(this, transform);
  T? elementAtOrNull(int index) => CollectionUtil.elementAtOrNull(this, index);
  T? getOrDefault(int index, T fallback) =>
      CollectionUtil.getOrDefault(this, index, fallback);
}

extension DartoolNullableIterable<T> on Iterable<T?> {
  List<T> whereNotNull() => CollectionUtil.whereNotNull(this);
}

/// Iterable of [num] helpers.
extension DartoolNumIterable<T extends num> on Iterable<T> {
  T? min() => NumExt._min(this);
  T? max() => NumExt._max(this);
  T sum() => NumExt._sum(this);
  double average() => NumExt._average(this);
}

/// Private re-export from NumUtil to avoid a cross-extension file.
class NumExt {
  static T? _min<T extends num>(Iterable<T> values) {
    T? best;
    for (final v in values) {
      if (best == null || v < best) best = v;
    }
    return best;
  }

  static T? _max<T extends num>(Iterable<T> values) {
    T? best;
    for (final v in values) {
      if (best == null || v > best) best = v;
    }
    return best;
  }

  static T _sum<T extends num>(Iterable<T> values) {
    T total = 0 as T;
    for (final v in values) {
      total = (total + v) as T;
    }
    return total;
  }

  static double _average(Iterable<num> values) {
    var count = 0;
    double total = 0;
    for (final v in values) {
      total += v;
      count++;
    }
    return count == 0 ? 0.0 : total / count;
  }
}

/// List-only helpers (chunk / windowed).
extension DartoolList<T> on List<T> {
  /// Split into chunks of [size].
  List<List<T>> chunk(int size) {
    if (size <= 0) throw ArgumentError.value(size, 'size', 'must be > 0');
    final result = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      result.add(sublist(i, i + size > length ? length : i + size));
    }
    return result;
  }

  /// Generate a sliding window of [size] over this list.
  List<List<T>> windowed(
    int size, {
    int step = 1,
    bool includePartial = false,
  }) {
    if (size <= 0) throw ArgumentError.value(size, 'size', 'must be > 0');
    if (step <= 0) throw ArgumentError.value(step, 'step', 'must be > 0');
    final result = <List<T>>[];
    for (var i = 0; ; i += step) {
      if (i + size > length) {
        if (includePartial && i < length) {
          result.add(sublist(i));
        }
        break;
      }
      result.add(sublist(i, i + size));
    }
    return result;
  }

  /// Return a sorted copy using [compare].
  List<T> sortedCopy(int Function(T a, T b) compare) {
    final copy = List<T>.from(this);
    copy.sort(compare);
    return copy;
  }

  /// Return a copy with duplicates removed by [keyOf] (first wins).
  List<T> distinctBy<K>(K Function(T) keyOf) {
    final seen = <K>{};
    final result = <T>[];
    for (final item in this) {
      final key = keyOf(item);
      if (seen.add(key)) result.add(item);
    }
    return result;
  }

  /// Swap two elements in-place.
  void swap(int i, int j) {
    final tmp = this[i];
    this[i] = this[j];
    this[j] = tmp;
  }

  /// Fill with [value] up to [newLength] (shrinks if smaller).
  void fill(int newLength, T value) {
    if (newLength < 0) throw ArgumentError.value(newLength, 'newLength');
    if (newLength <= length) {
      length = newLength;
    } else {
      for (var i = length; i < newLength; i++) {
        add(value);
      }
    }
  }

  /// Group this list by [keyOf].
  Map<K, List<T>> groupBy<K>(K Function(T) keyOf) {
    final result = <K, List<T>>{};
    for (final item in this) {
      result.putIfAbsent(keyOf(item), () => <T>[]).add(item);
    }
    return result;
  }
}
