import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('success / failure 语义', () {
      final ok = Result<int>.success(42);
      final bad = Result<int>.failure('boom', Exception('detail'));
      expect(ok.isSuccess, isTrue);
      expect(bad.isFailure, isTrue);
      expect(ok.value, 42);
      expect(bad.message, 'boom');
      expect(bad.error, isA<Exception>());
    });

    test('getOrElse / getOrThrow', () {
      expect(Result<int>.success(1).getOrElse(9), 1);
      expect(Result<int>.failure('x').getOrElse(9), 9);
      expect(Result<int>.success(1).getOrThrow(), 1);
      expect(() => Result<int>.failure('x').getOrThrow(), throwsStateError);
    });

    test('map / mapFailure', () {
      expect(Result<int>.success(2).map((x) => x * 10).value, 20);
      final failed = Result<int>.failure('err').map((x) => x * 10);
      expect(failed.isFailure, isTrue);
      expect(
        Result<int>.failure('oops').mapFailure((m) => 'E:$m').message,
        'E:oops',
      );
    });

    test('ifSuccess / ifFailure / fold', () {
      var called = '';
      Result<int>.success(3).ifSuccess((x) => called = 'ok$x');
      expect(called, 'ok3');
      Result<int>.failure('bad').ifFailure((m) => called = m);
      expect(called, 'bad');
      expect(Result<int>.success(3).fold((v) => v, (m) => -1), 3);
      expect(Result<int>.failure('bad').fold((v) => v, (m) => -1), -1);
    });
  });
}
