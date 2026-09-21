/// 可空值容器，类似 Java 的 `Optional`。
///
/// 用显式容器代替散落的判空逻辑，配合 [map]、[filter]、[ifPresent]
/// 等组合操作，让"可能为空"的处理更流畅、更安全。
class Optional<T> {
  Optional._(this._value);

  final T? _value;

  /// 包装一个非空值；为 `null` 时请用 [ofNullable]。
  factory Optional.of(T value) => Optional<T>._(value);

  /// 包装可能为 `null` 的值。
  factory Optional.ofNullable(T? value) => Optional<T>._(value);

  /// 返回空容器。
  factory Optional.empty() => Optional<T>._(null);

  /// 是否存在值。
  bool get isPresent => _value != null;

  /// 是否为空。
  bool get isEmpty => _value == null;

  /// 取值；为空时抛 [StateError]。
  T get value {
    final v = _value;
    if (v == null) throw StateError('Optional value is empty');
    return v;
  }

  /// 取值；为空时返回 [fallback]。
  T getOrElse(T fallback) => _value ?? fallback;

  /// 取值；为空时抛异常（[error] 为 [Exception] 则原样抛出，否则包成 [StateError]）。
  T getOrThrow([Object? error]) {
    final v = _value;
    if (v != null) return v;
    if (error is Exception) throw error;
    throw StateError(error?.toString() ?? 'Optional value is empty');
  }

  /// 变换值；为空时保持为空。
  Optional<R> map<R>(R Function(T) mapper) =>
      Optional<R>._(_value == null ? null : mapper(_value));

  /// 平铺变换；为空时保持为空。
  Optional<R> flatMap<R>(Optional<R> Function(T) mapper) =>
      _value == null ? Optional<R>.empty() : mapper(_value);

  /// 按条件过滤；不满足时置空。
  Optional<T> filter(bool Function(T) predicate) {
    final v = _value;
    if (v == null) return this;
    return predicate(v) ? this : Optional<T>.empty();
  }

  /// 存在值时执行 [action]。
  void ifPresent(void Function(T) action) {
    final v = _value;
    if (v != null) action(v);
  }

  /// 存在值执行 [action]，否则执行 [orElse]。
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
