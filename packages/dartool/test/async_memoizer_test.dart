import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('AsyncMemoizer', () {
    test('calls function only once even when awaited concurrently', () async {
      var calls = 0;
      final m = AsyncMemoizer<int>(() async {
        calls++;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        return 42;
      });

      final a = m();
      final b = m();
      final c = m();

      expect(await a, 42);
      expect(await b, 42);
      expect(await c, 42);
      expect(calls, 1);
      expect(m.hasRun, isTrue);
    });

    test('reset allows fresh invocation', () async {
      var calls = 0;
      final m = AsyncMemoizer<int>(() async => ++calls);
      expect(await m(), 1);
      expect(await m(), 1);
      m.reset();
      expect(await m(), 2);
    });
  });

  group('ExpiringMemoizer', () {
    test('serves cached value while fresh', () async {
      var calls = 0;
      final m = ExpiringMemoizer<int>(
        () async => ++calls,
        const Duration(milliseconds: 200),
      );

      expect(await m(), 1);
      expect(await m(), 1);
      expect(m.hasFresh, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 250));
      expect(m.hasFresh, isFalse);
      expect(await m(), 2);
    });
  });

  group('LazyFuture', () {
    test('does not start until first access', () async {
      var started = false;
      final lf = LazyFuture<void>(() async {
        started = true;
      });
      expect(started, isFalse);
      await lf.value;
      expect(started, isTrue);
    });
  });

  group('withTimeout', () {
    test('returns value on time', () async {
      final v = await withTimeout(() async {
        await Future<void>.delayed(const Duration(milliseconds: 5));
        return 7;
      }, const Duration(milliseconds: 500));
      expect(v, 7);
    });

    test('returns null / onTimeout when exceeded', () async {
      final v = await withTimeout(
        () async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return 1;
        },
        const Duration(milliseconds: 5),
        onTimeout: () => -1,
      );
      expect(v, -1);
    });

    test(
      'default timeout completes with null (regression: never completes)',
      () async {
        // The completer used to be Completer<int>; completing it with null in
        // the Timer callback threw asynchronously and the future never finished.
        final v = await withTimeout<int>(() async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return 1;
        }, const Duration(milliseconds: 5));
        expect(v, isNull);
      },
    );

    test('error inside fn propagates instead of hanging', () async {
      Object? caught;
      try {
        await withTimeout<int>(() async {
          await Future<void>.delayed(const Duration(milliseconds: 1));
          throw StateError('boom');
        }, const Duration(seconds: 1));
      } catch (e) {
        caught = e;
      }
      expect(caught, isStateError);
    });
  });

  group('waitFailFast', () {
    test('returns all when none fail', () async {
      final r = await waitFailFast(<Future<int>>[
        Future.value(1),
        Future.value(2),
        Future.value(3),
      ]);
      expect(r, [1, 2, 3]);
    });

    test('propagates first failure', () async {
      expect(
        () => waitFailFast(<Future<int>>[
          Future.value(1),
          Future<int>.error('boom'),
          Future.value(3),
        ]),
        throwsA(equals('boom')),
      );
    });

    test('empty list returns empty', () async {
      expect(await waitFailFast<int>(const []), isEmpty);
    });

    test(
      'works for non-nullable reference types (regression: 0 as T)',
      () async {
        final r = await waitFailFast<String>([
          Future.value('a'),
          Future.value('b'),
        ]);
        expect(r, ['a', 'b']);
      },
    );
  });
}
