/// Map helpers that complement the static MapUtil-style API.
extension DartoolMap<K, V> on Map<K, V> {
  /// Get the value for [key] or [fallback].
  V getOrDefault(K key, V fallback) {
    final v = this[key];
    return v ?? fallback;
  }

  /// Insert [key]/[value] if absent; returns the stored value.
  V putIfAbsentOr(K key, V value) => putIfAbsent(key, () => value);

  /// Return a new map with keys transformed by [f]. Conflicting keys keep the
  /// last value.
  Map<R, V> mapKeys<R>(R Function(K) f) {
    final result = <R, V>{};
    for (final entry in entries) {
      result[f(entry.key)] = entry.value;
    }
    return result;
  }

  /// Return a new map with values transformed by [f].
  Map<K, R> mapValues<R>(R Function(V) f) {
    final result = <K, R>{};
    for (final entry in entries) {
      result[entry.key] = f(entry.value);
    }
    return result;
  }

  /// Return a new map with keys and values swapped. Duplicate values keep
  /// the last key.
  Map<V, K> invert() {
    final result = <V, K>{};
    for (final entry in entries) {
      result[entry.value] = entry.key;
    }
    return result;
  }

  /// Return a new map combining [other]; duplicate keys resolve via
  /// [resolver] (default: prefer [other]).
  Map<K, V> merge(
    Map<K, V> other, {
    V Function(V existing, V incoming)? resolver,
  }) {
    final result = Map<K, V>.from(this);
    for (final entry in other.entries) {
      if (result.containsKey(entry.key) && resolver != null) {
        result[entry.key] = resolver(result[entry.key] as V, entry.value);
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// Return a new map with entries satisfying [predicate] removed.
  Map<K, V> withoutWhere(bool Function(K, V) predicate) {
    final result = Map<K, V>.from(this);
    result.removeWhere(predicate);
    return result;
  }
}
