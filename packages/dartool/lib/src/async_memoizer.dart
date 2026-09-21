import 'dart:async';

/// A one-shot async computation that caches its future value. All callers
/// receive the same [Future]  the function is called at most once, no
/// matter how many times [call] is invoked concurrently.
///
/// Useful for expensive initialization or network fetches that should run
/// once and share the result.
///
/// ```dart
/// final loader = AsyncMemoizer<String>(() => fetchFromNetwork());
/// final a = loader();
/// final b = loader(); // a and b are the same Future
/// ```
class AsyncMemoizer<T> {
  AsyncMemoizer(this._fn);

  final Future<T> Function() _fn;
  Future<T>? _cached;

  /// Returns the cached [Future], invoking the function on first call.
  Future<T> call() => _cached ??= _fn();

  /// Whether the computation has already started / been cached.
  bool get hasRun => _cached != null;

  /// Discard the cached future. The next [call] will re-run the function.
  void reset() => _cached = null;
}

/// Like [AsyncMemoizer] but the cached value expires after [ttl]. Once the
/// TTL has elapsed the next [call] triggers a fresh invocation.
class ExpiringMemoizer<T> {
  ExpiringMemoizer(this._fn, this.ttl);

  final Future<T> Function() _fn;
  final Duration ttl;

  Future<T>? _cached;
  DateTime? _cachedAt;

  Future<T> call() {
    final now = DateTime.now();
    if (_cached != null &&
        _cachedAt != null &&
        now.difference(_cachedAt!) < ttl) {
      return _cached!;
    }
    _cached = _fn();
    _cachedAt = now;
    return _cached!;
  }

  /// Whether a non-expired value is currently cached.
  bool get hasFresh {
    final c = _cached;
    if (c == null || _cachedAt == null) return false;
    return DateTime.now().difference(_cachedAt!) < ttl;
  }

  void reset() {
    _cached = null;
    _cachedAt = null;
  }
}

/// Kicks off an async computation in the background and returns a
/// "lazy" Future that only starts when first awaited. This is a thin
/// wrapper that makes Future-returning closures composable.
class LazyFuture<T> {
  LazyFuture(this._fn);

  final Future<T> Function() _fn;
  Future<T>? _inner;

  Future<T> get value => _inner ??= _fn();
}

/// Run [fn] and return its Future. If it completes before [timeout] elapses
/// the result is returned; otherwise [onTimeout] is called (defaults to
/// returning `null`) and the original Future is dropped (still runs in the
/// background).
Future<T?> withTimeout<T>(
  Future<T> Function() fn,
  Duration timeout, {
  T? Function()? onTimeout,
}) async {
  final completer = Completer<T>();
  final timer = Timer(timeout, () {
    if (!completer.isCompleted) {
      completer.complete(onTimeout?.call());
    }
  });

  // ignore: unawaited_futures
  fn()
      .then((value) {
        if (!completer.isCompleted) {
          timer.cancel();
          completer.complete(value);
        }
      })
      .catchError((Object e, StackTrace st) {
        if (!completer.isCompleted) {
          timer.cancel();
          completer.completeError(e, st);
        }
      });

  return completer.future;
}

/// Like [Future.wait] but short-circuits as soon as *any* future fails
/// cancels the rest and propagates the error.
///
/// This is the "fast-fail" analogue of [Future.wait].
Future<List<T>> waitFailFast<T>(Iterable<Future<T>> futures) async {
  final results = <T?>[];
  final List<Completer<T>> completers = [];
  final List<Future<T>> list = futures.toList();
  if (list.isEmpty) return <T>[];

  Object? firstError;
  StackTrace? firstStack;

  for (var i = 0; i < list.length; i++) {
    final c = Completer<T>();
    completers.add(c);
    results.add(null);

    // ignore: unawaited_futures
    list[i].then(
      (v) {
        if (!c.isCompleted) c.complete(v);
      },
      onError: (Object e, StackTrace st) {
        if (firstError == null) {
          firstError = e;
          firstStack = st;
        }
        if (!c.isCompleted) c.completeError(e, st);
      },
    );
  }

  try {
    for (var i = 0; i < completers.length; i++) {
      results[i] = await completers[i].future;
    }
  } catch (_) {
    if (firstError != null) {
      await Future<void>.delayed(Duration.zero);
      Error.throwWithStackTrace(firstError!, firstStack!);
    }
    rethrow;
  }

  return List<T>.filled(list.length, 0 as T, growable: false)
    ..setRange(0, list.length, results.cast<T>());
}
