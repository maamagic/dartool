import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

class _LoggedIn {
  _LoggedIn(this.userId);
  final String userId;
}

class _LoggedOut {}

void main() {
  group('EventBus', () {
    test('subscribe + emit delivers events', () {
      final bus = EventBus();
      _LoggedIn? received;
      bus.on<_LoggedIn>((e) => received = e);
      bus.emit(_LoggedIn('u-1'));
      expect(received?.userId, 'u-1');
    });

    test('unsubscribe function stops delivery', () {
      final bus = EventBus();
      var count = 0;
      final unsub = bus.on<_LoggedIn>((e) => count++);
      bus.emit(_LoggedIn('a'));
      unsub();
      bus.emit(_LoggedIn('b'));
      expect(count, 1);
    });

    test('off removes a specific handler', () {
      final bus = EventBus();
      void h1(_LoggedIn e) {}
      void h2(_LoggedIn e) {}
      bus.on<_LoggedIn>(h1);
      bus.on<_LoggedIn>(h2);
      bus.off<_LoggedIn>(h1);
      expect(bus.count<_LoggedIn>(), 1);
    });

    test('offAll / clear removes all handlers', () {
      final bus = EventBus();
      bus.on<_LoggedIn>((e) {});
      bus.on<_LoggedIn>((e) {});
      bus.on<_LoggedOut>((e) {});
      bus.offAll<_LoggedIn>();
      expect(bus.hasSubscribers<_LoggedIn>(), isFalse);
      expect(bus.hasSubscribers<_LoggedOut>(), isTrue);
      bus.clear();
      expect(bus.hasSubscribers<_LoggedOut>(), isFalse);
    });

    test('emit to wrong type is silent', () {
      final bus = EventBus();
      var delivered = 0;
      bus.on<_LoggedOut>((e) => delivered++);
      bus.emit(_LoggedIn('no-op'));
      expect(delivered, 0);
    });

    test('handlers that unsubscribe during emit do not crash', () {
      final bus = EventBus();
      late void Function() unsub;
      bus.on<_LoggedIn>((e) {
        unsub();
      });
      unsub = bus.on<_LoggedIn>((e) {});
      // should not throw
      bus.emit(_LoggedIn('x'));
    });

    test('no subscribers is safe', () {
      final bus = EventBus();
      // should not throw
      bus.emit(_LoggedIn('nobody listening'));
      expect(bus.count<_LoggedIn>(), 0);
    });

    test('emit dispatches by runtime type, not static type', () {
      final bus = EventBus();
      var logins = 0;
      var objects = 0;
      bus.on<_LoggedIn>((e) => logins++);
      bus.on<Object>((e) => objects++);
      // emit through a supertype-typed reference
      final Object event = _LoggedIn('runtime');
      bus.emit(event);
      expect(logins, 1);
      expect(objects, 0);
    });
  });
}
