/// Bidirectional map — every value has a unique key too.
///
/// ```dart
/// final map = BiMap<String, int>();
/// map['one'] = 1;
/// map['two'] = 2;
/// print(map.inverse[1]); // 'one'
/// ```
class BiMap<K, V> {
  BiMap();

  final _forward = <K, V>{};
  final _backward = <V, K>{};

  int get length => _forward.length;
  bool get isEmpty => _forward.isEmpty;
  bool get isNotEmpty => _forward.isNotEmpty;

  V? operator [](K key) => _forward[key];

  /// Insert a [key] → [value] pair. If either the key or value already
  /// exists it is overwritten (both directions are kept consistent).
  void operator []=(K key, V value) {
    _backward.remove(_forward[key]);
    _forward.remove(_backward[value]);
    _forward[key] = value;
    _backward[value] = key;
  }

  /// The inverse view — maps value → key. The returned map is a live view
  /// backed by the BiMap, so mutations through it are NOT supported.
  Map<V, K> get inverse => Map<V, K>.unmodifiable(_backward);

  bool containsKey(K key) => _forward.containsKey(key);
  bool containsValue(V value) => _backward.containsKey(value);

  void remove(K key) {
    final v = _forward.remove(key);
    if (v != null) _backward.remove(v);
  }

  void removeValue(V value) {
    final k = _backward.remove(value);
    if (k != null) _forward.remove(k);
  }

  void clear() {
    _forward.clear();
    _backward.clear();
  }

  Iterable<K> get keys => _forward.keys;
  Iterable<V> get values => _forward.values;

  @override
  String toString() => 'BiMap($_forward)';
}
