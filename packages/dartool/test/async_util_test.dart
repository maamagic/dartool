import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('Mutex', () {
    test('protect serializes concurrent calls', () async {
      final mutex = Mutex();
      var counter = 0;
      var running = 0;
      var maxRunning = 0;

      Future<void> worker() => mutex.protect(() async {
        running++;
        if (running > maxRunning) maxRunning = running;
        counter++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        running--;
      });

      await Future.wait([worker(), worker(), worker()]);
      expect(counter, 3);
      expect(maxRunning, 1);
    });

    test(
      'errors inside protect propagate but still release the mutex',
      () async {
        final mutex = Mutex();
        final future = mutex.protect(() async {
          throw StateError('boom');
        });
        await expectLater(future, throwsStateError);

        var entered = false;
        await mutex.protect(() async {
          entered = true;
        });
        expect(entered, isTrue);
      },
    );
  });

  group('Semaphore', () {
    test('limits concurrency to permits', () async {
      final sem = Semaphore(2);
      var running = 0;
      var maxRunning = 0;

      Future<void> worker() => sem.protect(() async {
        running++;
        if (running > maxRunning) maxRunning = running;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        running--;
      });

      await Future.wait([worker(), worker(), worker(), worker()]);
      expect(maxRunning, 2);
    });

    test('protect releases on exception', () async {
      final sem = Semaphore(1);
      await expectLater(
        sem.protect(() async => throw Exception('x')),
        throwsException,
      );
      expect(sem.availablePermits, 1);
    });

    test('acquire + release manual', () async {
      final sem = Semaphore(1);
      await sem.acquire();
      expect(sem.availablePermits, 0);
      sem.release();
      expect(sem.availablePermits, 1);
    });

    test('constructor rejects permits below 1', () {
      expect(() => Semaphore(0), throwsArgumentError);
      expect(() => Semaphore(-3), throwsArgumentError);
    });

    test('releasing more times than acquired throws StateError', () {
      final sem = Semaphore(2);
      expect(sem.release, throwsStateError); // nothing acquired yet
      expect(sem.availablePermits, 2); // not inflated past the limit
      sem.acquire();
      sem.release();
      expect(sem.availablePermits, 2);
      expect(sem.release, throwsStateError);
    });

    test('queued acquirer is woken by release hand-off', () async {
      final sem = Semaphore(1);
      await sem.acquire();
      var entered = false;
      final queued = sem.acquire().then((_) => entered = true);
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(entered, isFalse);
      // release hands the permit straight to the queued acquirer, so the
      // permit count stays at 0 and a second release is still legal.
      sem.release();
      await queued;
      expect(entered, isTrue);
      expect(sem.availablePermits, 0);
      sem.release();
      expect(sem.availablePermits, 1);
      expect(sem.release, throwsStateError);
    });
  });
}
