/// Result container that wraps "value + error" into explicit success /
/// failure semantics. Prevents using exceptions for expected failure branches.
class Result<T> {
  Result._(this._value, this._message, this._error, this._isSuccess);

  final T? _value;
  final String? _message;
  final Object? _error;
  final bool _isSuccess;

  /// Successful result.
  factory Result.success(T value) => Result<T>._(value, null, null, true);

  /// Failed result with a human-readable [message] and optional underlying
  /// [error].
  factory Result.failure(String message, [Object? error]) =>
      Result<T>._(null, message, error, false);

  /// Whether this result represents success.
  bool get isSuccess => _isSuccess;

  /// Whether this result represents failure.
  bool get isFailure => !_isSuccess;

  /// The wrapped value (`null` on failure).
  T? get value => _value;

  /// Failure message (`null` on success).
  String? get message => _message;

  /// Optional underlying error object.
  Object? get error => _error;

  /// Returns the wrapped value, or [fallback] on failure.
  T getOrElse(T fallback) => _isSuccess ? _value as T : fallback;

  /// Returns the wrapped value; throws [StateError] on failure.
  T getOrThrow() {
    if (!_isSuccess) {
      throw StateError(_message ?? 'Result is failure');
    }
    return _value as T;
  }

  /// Transform the value on success; stays unchanged on failure.
  Result<R> map<R>(R Function(T) mapper) => _isSuccess
      ? Result<R>.success(mapper(_value as T))
      : Result<R>._(null, _message, _error, false);

  /// Transform the failure message; stays unchanged on success.
  Result<T> mapFailure(String Function(String message) mapper) =>
      _isSuccess ? this : Result<T>.failure(mapper(_message ?? ''), _error);

  /// Run [action] on success.
  void ifSuccess(void Function(T) action) {
    if (_isSuccess) action(_value as T);
  }

  /// Run [action] on failure.
  void ifFailure(void Function(String message) action) {
    if (!_isSuccess) action(_message ?? '');
  }

  /// Fold: invoke [onSuccess] on success, [onFailure] on failure.
  R fold<R>(R Function(T) onSuccess, R Function(String message) onFailure) =>
      _isSuccess ? onSuccess(_value as T) : onFailure(_message ?? '');

  @override
  String toString() =>
      _isSuccess ? 'Result.success($_value)' : 'Result.failure($_message)';
}
