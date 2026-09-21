/// Null-safe value container, similar to Java's `Optional`.
///
/// Encapsulates "possibly absent" values in an explicit wrapper, so you can
/// chain [map], [filter], [ifPresent], etc. instead of scattering `if (x == null)`
/// checks throughout business logic.
class Optional<T> {
  Optional._(this._value);

  final T? _value;

  /// Wrap a non-null value. Use [ofNullable] if [value] may be `null`.
  factory Optional.of(T value) => Optional<T>._(value);

  /// Wrap a value that may be `null`.
  factory Optional.ofNullable(T? value) => Optional<T>._(value);

  /// Empty container.
  factory Optional.empty() => Optional<T>._(null);

  /// Whether a value is present.
  bool get isPresent => _value != null;

  /// Whether the container is empty.
  bool get isEmpty => _value == null;

  /// The wrapped value; throws [StateError] when empty.
  T get value {
    final v = _value;
    if (v == null) throw StateError('Optional value is empty');
    return v;
  }

  /// Returns the wrapped value, or [fallback] when empty.
  T getOrElse(T fallback) => _value ?? fallback;

  /// Returns the wrapped value; throws [error] (or [StateError] with
  /// [error]'s toString) when empty.
  T getOrThrow([Object? error]) {
    final v = _value;
    if (v != null) return v;
    if (error is Exception) throw error;
    throw StateError(error?.toString() ?? 'Optional value is empty');
  }

  /// Transform the value; stays empty if already empty.
  Optional<R> map<R>(R Function(T) mapper) =>
      Optional<R>._(_value == null ? null : mapper(_value));

  /// Flat-map into another Optional; stays empty if already empty.
  Optional<R> flatMap<R>(Optional<R> Function(T) mapper) =>
      _value == null ? Optional<R>.empty() : mapper(_value);

  /// Keep the value only if it matches [predicate]; otherwise become empty.
  Optional<T> filter(bool Function(T) predicate) {
    final v = _value;
    if (v == null) return this;
    return predicate(v) ? this : Optional<T>.empty();
  }

  /// Run [action] if a value is present.
  void ifPresent(void Function(T) action) {
    final v = _value;
    if (v != null) action(v);
  }

  /// Run [action] if present, [orElse] if empty.
  void ifPresentOrElse(void Function(T) action, void Function() orElse) {
    final v = _value;
    if (v != null) {
      action(v);
    } else {
      orElse();
    }
  }

  @override
  String toString() => _value == null ? 'Optional.empty' : 'Optional($_value)';
}
