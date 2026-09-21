import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('Debouncer', () {
    test('multiple rapid calls → only the last fires', () async {
      final d = Debouncer(duration: Duration(milliseconds: 30));
      var fired = 0;
      d.run(() => fired++);
      d.run(() => fired++);
      d.run(() => fired++);
      await Future<void>.delayed(Duration(milliseconds: 50));
      expect(fired, 1);
    });

    test('cancel prevents pending call', () async {
      final d = Debouncer(duration: Duration(milliseconds: 30));
      var fired = 0;
      d.run(() => fired++);
      d.cancel();
      await Future<void>.delayed(Duration(milliseconds: 50));
      expect(fired, 0);
    });

    test('runLeading fires immediately when idle', () async {
      final d = Debouncer(duration: Duration(milliseconds: 30));
      var fired = 0;
      d.runLeading(() => fired++);
      expect(fired, 1);
      await Future<void>.delayed(Duration(milliseconds: 50));
      expect(fired, 1);
    });
  });

  group('Throttler', () {
    test('only first call within window executes', () {
      final t = Throttler(duration: Duration(milliseconds: 50));
      var fired = 0;
      expect(t.run(() => fired++), isTrue);
      expect(t.run(() => fired++), isFalse);
      expect(t.run(() => fired++), isFalse);
      expect(fired, 1);
    });

    test('allows next call after window', () async {
      final t = Throttler(duration: Duration(milliseconds: 30));
      var fired = 0;
      t.run(() => fired++);
      await Future<void>.delayed(Duration(milliseconds: 40));
      expect(t.run(() => fired++), isTrue);
      expect(fired, 2);
    });

    test('reset allows immediate next call', () async {
      final t = Throttler(duration: Duration(milliseconds: 5000));
      var fired = 0;
      t.run(() => fired++);
      t.reset();
      expect(t.run(() => fired++), isTrue);
      expect(fired, 2);
    });
  });
}
