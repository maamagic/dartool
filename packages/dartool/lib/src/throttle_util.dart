/// Throttle / debounce helpers  one-shot and reusable versions.
library;

import 'dart:async';

/// Debounce a function: only the **last** call within [duration] fires.
///
/// ```dart
/// final search = Debouncer(duration: Duration(milliseconds: 300));
/// search.run(() => api.search(query));
/// ```
class Debouncer {
  Debouncer({required this.duration});
  final Duration duration;
  Timer? _timer;

  void run(void Function() fn) {
    _timer?.cancel();
    _timer = Timer(duration, fn);
  }

  /// Run immediately if no call is pending; otherwise schedule for after
  /// [duration] with the latest payload.
  void runLeading(void Function() fn) {
    if (_timer == null || !_timer!.isActive) {
      fn();
      _timer = Timer(duration, () {
        _timer = null;
      });
    } else {
      _timer?.cancel();
      _timer = Timer(duration, fn);
    }
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isPending => _timer != null && _timer!.isActive;
}

/// Throttle a function: at most **one call per** [duration] window.
///
/// ```dart
/// final clickGuard = Throttler(duration: Duration(seconds: 1));
/// ElevatedButton(onPressed: () => clickGuard.run(() => submit()));
/// ```
class Throttler {
  Throttler({required this.duration});
  final Duration duration;
  DateTime? _nextAllowed;

  /// Run [fn] if enough time has passed since the last allowed call.
  /// Returns whether the call was executed.
  bool run(void Function() fn) {
    final now = DateTime.now();
    final allowed = _nextAllowed == null || !now.isBefore(_nextAllowed!);
    if (allowed) {
      fn();
      _nextAllowed = now.add(duration);
    }
    return allowed;
  }

  /// Reset the throttle clock so the next [run] is immediate.
  void reset() => _nextAllowed = null;
}

/// One-shot convenience function: run [fn] after [duration] elapses.
///
/// This is a plain non-cancellable [Timer]; for a debouncer that resets on
/// every call use [Debouncer].
Timer debounce(Duration duration, void Function() fn) => Timer(duration, fn);

/// Last-execution timestamps keyed by the callback identity. Entries are
/// released automatically once the closure is garbage collected.
final Expando<DateTime> _throttleSlots = Expando<DateTime>();

/// Leading-edge throttle: execute [fn] immediately and return `true` at most
/// once per [duration] window **for the same callback instance**; calls inside
/// the window are swallowed and return `false`.
///
/// Throttling state is keyed on [fn]'s identity, so reuse the same closure
/// (or store a tear-off in a variable) across calls:
///
/// ```dart
/// final handler = () => submit();
/// ElevatedButton(onPressed: () => throttle(Duration(seconds: 1), handler));
/// ```
bool throttle(Duration duration, void Function() fn) {
  final now = DateTime.now();
  final last = _throttleSlots[fn];
  if (last != null && now.difference(last) < duration) {
    return false;
  }
  _throttleSlots[fn] = now;
  fn();
  return true;
}
