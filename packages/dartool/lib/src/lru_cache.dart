/// Simple in-memory LRU cache with optional time-to-live.
class LruCache<K, V> {
  LruCache({required this.capacity, this.ttl}) {
    assert(capacity > 0, 'capacity must be positive');
  }

  final int capacity;
  final Duration? ttl;

  final _map = <K, _LruEntry<V>>{};
  final _order = <K>[];

  int get length => _map.length;
  bool get isEmpty => _map.isEmpty;
  bool get isNotEmpty => _map.isNotEmpty;

  /// Insert [value] under [key].
  void set(K key, V value) {
    _map.remove(key);
    _order.remove(key);
    _map[key] = _LruEntry(value, DateTime.now());
    _order.add(key);
    if (_order.length > capacity) {
      final evicted = _order.removeAt(0);
      _map.remove(evicted);
    }
  }

  /// Return the cached value for [key], or null if missing / expired.
  V? get(K key) {
    final entry = _map[key];
    if (entry == null) return null;
    if (_isExpired(entry)) {
      remove(key);
      return null;
    }
    _order.remove(key);
    _order.add(key);
    return entry.value;
  }

  V putIfAbsent(K key, V Function() ifAbsent) {
    final existing = get(key);
    if (existing != null) return existing;
    final value = ifAbsent();
    set(key, value);
    return value;
  }

  bool contains(K key) {
    final entry = _map[key];
    if (entry == null) return false;
    if (_isExpired(entry)) {
      remove(key);
      return false;
    }
    return true;
  }

  void remove(K key) {
    _map.remove(key);
    _order.remove(key);
  }

  void clear() {
    _map.clear();
    _order.clear();
  }

  int evictExpired() {
    if (ttl == null) return 0;
    var removed = 0;
    for (final key in List<K>.from(_order)) {
      final entry = _map[key];
      if (entry != null && _isExpired(entry)) {
        remove(key);
        removed++;
      }
    }
    return removed;
  }

  bool _isExpired(_LruEntry<V> entry) {
    if (ttl == null) return false;
    return DateTime.now().difference(entry.storedAt) >= ttl!;
  }
}

class _LruEntry<V> {
  _LruEntry(this.value, this.storedAt);
  final V value;
  final DateTime storedAt;
}
