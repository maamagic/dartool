/// Tiny synchronous event bus  pub/sub with strong typing.
///
/// ```dart
/// final bus = EventBus();
/// bus.on<UserLoggedIn>((e) => print(e.userId));
/// bus.emit(UserLoggedIn('u-1'));
/// ```
class EventBus {
  EventBus();

  final _subscribers = <Type, List<Function>>{};

  /// Subscribe to events of type [T]. Returns an unsubscribe function.
  void Function() on<T>(void Function(T) handler) {
    _subscribers.putIfAbsent(T, () => []).add(handler);
    return () => off<T>(handler);
  }

  /// Remove a previously registered [handler] for events of type [T].
  void off<T>(void Function(T) handler) {
    final list = _subscribers[T];
    if (list == null) return;
    list.remove(handler);
    if (list.isEmpty) _subscribers.remove(T);
  }

  /// Remove **all** handlers for events of type [T].
  void offAll<T>() {
    _subscribers.remove(T);
  }

  /// Remove every registered handler.
  void clear() {
    _subscribers.clear();
  }

  /// Publish [event] synchronously to every subscriber of its **runtime**
  /// type (not the static type [T]), so emitting a subtype through a
  /// supertype-typed reference still reaches the matching subscribers.
  void emit<T>(T event) {
    final Type type = event == null ? T : (event as Object).runtimeType;
    final list = _subscribers[type];
    if (list == null || list.isEmpty) return;
    // snapshot to tolerate handlers that unsubscribe during emit
    for (final h in List<Function>.from(list)) {
      Function.apply(h, <Object?>[event]);
    }
  }

  /// Returns whether there are any subscribers for events of type [T].
  bool hasSubscribers<T>() {
    final list = _subscribers[T];
    return list != null && list.isNotEmpty;
  }

  /// Number of subscribers for [T].
  int count<T>() => _subscribers[T]?.length ?? 0;
}
