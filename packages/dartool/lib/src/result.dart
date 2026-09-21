/// 操作结果容器，在"值 + 错误信息"上封装成功/失败语义。
///
/// 用于方法显式返回成功或失败，避免用异常表达可预期的失败分支。
class Result<T> {
  Result._(this._value, this._message, this._error, this._isSuccess);

  final T? _value;
  final String? _message;
  final Object? _error;
  final bool _isSuccess;

  /// 成功结果。
  factory Result.success(T value) => Result<T>._(value, null, null, true);

  /// 失败结果，携带可读信息与可选底层错误。
  factory Result.failure(String message, [Object? error]) =>
      Result<T>._(null, message, error, false);

  /// 是否成功。
  bool get isSuccess => _isSuccess;

  /// 是否失败。
  bool get isFailure => !_isSuccess;

  /// 成功时的值（失败时为 `null`）。
  T? get value => _value;

  /// 失败信息（成功时为 `null`）。
  String? get message => _message;

  /// 底层错误对象（可选）。
  Object? get error => _error;

  /// 取值；失败时返回 [fallback]。
  T getOrElse(T fallback) => _isSuccess ? _value as T : fallback;

  /// 取值；失败时抛 [StateError]。
  T getOrThrow() {
    if (!_isSuccess) {
      throw StateError(_message ?? 'Result is failure');
    }
    return _value as T;
  }

  /// 成功时变换值，失败时保持失败。
  Result<R> map<R>(R Function(T) mapper) => _isSuccess
      ? Result<R>.success(mapper(_value as T))
      : Result<R>._(null, _message, _error, false);

  /// 失败时用 [mapper] 改写错误信息，成功时保持原值不变。
  Result<T> mapFailure(String Function(String message) mapper) =>
      _isSuccess ? this : Result<T>.failure(mapper(_message ?? ''), _error);

  /// 成功时执行 [action]。
  void ifSuccess(void Function(T) action) {
    if (_isSuccess) action(_value as T);
  }

  /// 失败时执行 [action]。
  void ifFailure(void Function(String message) action) {
    if (!_isSuccess) action(_message ?? '');
  }

  /// 折叠：成功走 [onSuccess]，失败走 [onFailure]。
  R fold<R>(R Function(T) onSuccess, R Function(String message) onFailure) =>
      _isSuccess ? onSuccess(_value as T) : onFailure(_message ?? '');

  @override
  String toString() =>
      _isSuccess ? 'Result.success($_value)' : 'Result.failure($_message)';
}
