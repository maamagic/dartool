import "dart:async";

/// Dart async primitives Semaphore and Mutex.
///
/// These are lightweight concurrency helpers built on top of Dart's
/// single-threaded event loop. They coordinate async code within a single
/// isolate; they do NOT work across isolates.
///
/// ```dart
/// final mutex = Mutex();
/// await mutex.protect(() async {
///   // critical section
/// });
/// ```

class Mutex {
  Mutex();

  Future<void>? _tail;

  /// Run [fn] while holding the mutex. A queued call will wait until every
  /// previous call completes.
  Future<T> protect<T>(Future<T> Function() fn) async {
    final previous = _tail;
    final completer = Completer<void>();
    _tail = completer.future;

    if (previous != null) {
      try {
        await previous;
      } catch (_) {
        // swallow errors from earlier protect calls �?they already propagated
      }
    }

    try {
      return await fn();
    } finally {
      completer.complete();
    }
  }
}

class Semaphore {
  Semaphore(int permits) : _permits = permits {
    assert(permits > 0, 'permits must be positive');
  }

  int _permits;
  final _queue = <_Waiter>[];

  /// Acquire one permit, blocking until available. Returns a release handle
  /// that restores the permit.
  Future<void> acquire() async {
    if (_permits > 0) {
      _permits--;
      return;
    }
    final w = _Waiter();
    _queue.add(w);
    await w.future;
  }

  /// Release one permit.
  void release() {
    if (_queue.isNotEmpty) {
      final w = _queue.removeAt(0);
      w.complete();
    } else {
      _permits++;
    }
  }

  /// Run [fn] while holding one permit.
  Future<T> protect<T>(Future<T> Function() fn) async {
    await acquire();
    try {
      return await fn();
    } finally {
      release();
    }
  }

  int get availablePermits => _permits;
}

class _Waiter {
  _Waiter() : _completer = Completer<void>();
  final Completer<void> _completer;
  Future<void> get future => _completer.future;
  void complete() => _completer.complete();
}
