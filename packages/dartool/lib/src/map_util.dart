/// Map utilities  higher-level helpers than the core library provides.
abstract final class MapUtil {
  MapUtil._();

  // ---------------------------------------------------------------------------
  // Null-safe access
  // ---------------------------------------------------------------------------

  /// Return [value] cast into type [T], or [fallback] if missing / wrong type.
  static T getOrDefault<T, K, V>(Map<K, V> map, K key, T fallback) {
    final v = map[key];
    if (v == null) return fallback;
    if (v is T) return v as T;
    return fallback;
  }

  /// Insert [value] into [map] under [key] only if the key is absent.
  /// Returns the value that ended up stored.
  static V putIfAbsent<K, V>(Map<K, V> map, K key, V value) =>
      map.putIfAbsent(key, () => value);

  // ---------------------------------------------------------------------------
  // Transformations
  // ---------------------------------------------------------------------------

  /// Return a new map with keys transformed by [f]. Conflicting keys keep the
  /// last value.
  static Map<R, V> mapKeys<K, V, R>(Map<K, V> map, R Function(K) f) {
    final result = <R, V>{};
    for (final entry in map.entries) {
      result[f(entry.key)] = entry.value;
    }
    return result;
  }

  /// Return a new map with values transformed by [f].
  static Map<K, R> mapValues<K, V, R>(Map<K, V> map, R Function(V) f) {
    final result = <K, R>{};
    for (final entry in map.entries) {
      result[entry.key] = f(entry.value);
    }
    return result;
  }

  /// Return a new map combining [a] and [b]. Duplicate keys resolve via
  /// [resolver]; default is to prefer [b].
  static Map<K, V> merge<K, V>(
    Map<K, V> a,
    Map<K, V> b, {
    V Function(V existing, V incoming)? resolver,
  }) {
    final result = Map<K, V>.from(a);
    for (final entry in b.entries) {
      if (result.containsKey(entry.key) && resolver != null) {
        result[entry.key] = resolver(result[entry.key] as V, entry.value);
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// Return a new map where keys and values are swapped. Duplicate values keep
  /// the last key.
  static Map<V, K> invert<K, V>(Map<K, V> map) {
    final result = <V, K>{};
    for (final entry in map.entries) {
      result[entry.value] = entry.key;
    }
    return result;
  }

  /// Return a new map with entries satisfying [predicate] kept.
  static Map<K, V> filter<K, V>(Map<K, V> map, bool Function(K, V) predicate) {
    final result = <K, V>{};
    for (final entry in map.entries) {
      if (predicate(entry.key, entry.value)) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// Return a new map with entries satisfying [predicate] removed.
  static Map<K, V> removeWhere<K, V>(
    Map<K, V> map,
    bool Function(K, V) predicate,
  ) {
    final result = Map<K, V>.from(map);
    result.removeWhere(predicate);
    return result;
  }

  // ---------------------------------------------------------------------------
  // Construction
  // ---------------------------------------------------------------------------

  /// Build a map from [keys] and [values]; if they have different lengths,
  /// shorter side wins silently.
  static Map<K, V> of<K, V>(Iterable<K> keys, Iterable<V> values) {
    final result = <K, V>{};
    final ki = keys.iterator;
    final vi = values.iterator;
    while (ki.moveNext() && vi.moveNext()) {
      result[ki.current] = vi.current;
    }
    return result;
  }

  /// Build a map from an iterable by applying [keyOf] to each element.
  static Map<K, V> fromIterable<K, V>(Iterable<V> items, K Function(V) keyOf) {
    final result = <K, V>{};
    for (final item in items) {
      result[keyOf(item)] = item;
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Flatten / unflatten (dot-notation keys like "a.b.c")
  // ---------------------------------------------------------------------------

  /// Flatten a nested map so that all paths become dot-notation keys.
  ///
  /// Example: `{'a': {'b': 1}}`  `{'a.b': 1}`.
  static Map<String, dynamic> flatten(
    Map<String, dynamic> source, {
    String separator = '.',
  }) {
    final result = <String, dynamic>{};
    _flattenInto(source, result, '', separator);
    return result;
  }

  /// Unflatten a dot-notation map back into a nested structure.
  ///
  /// Example: `{'a.b': 1, 'a.c': 2}`  `{'a': {'b': 1, 'c': 2}}`.
  static Map<String, dynamic> unflatten(
    Map<String, dynamic> source, {
    String separator = '.',
  }) {
    final root = <String, dynamic>{};
    for (final entry in source.entries) {
      final parts = entry.key.split(separator);
      dynamic current = root;
      for (var i = 0; i < parts.length - 1; i++) {
        final part = parts[i];
        if (current is Map<String, dynamic>) {
          current[part] ??= <String, dynamic>{};
          current = current[part];
        }
      }
      if (current is Map<String, dynamic>) {
        current[parts.last] = entry.value;
      }
    }
    return root;
  }

  static void _flattenInto(
    Map<String, dynamic> src,
    Map<String, dynamic> dst,
    String prefix,
    String sep,
  ) {
    for (final entry in src.entries) {
      final key = prefix.isEmpty ? entry.key : '$prefix$sep${entry.key}';
      if (entry.value is Map<String, dynamic>) {
        _flattenInto(entry.value as Map<String, dynamic>, dst, key, sep);
      } else {
        dst[key] = entry.value;
      }
    }
  }
}
