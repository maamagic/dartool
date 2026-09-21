import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('ExceptionUtil.stringify', () {
    test('handles null', () {
      expect(ExceptionUtil.stringify(null), '');
    });

    test('handles Dart Exception with "Exception:" prefix', () {
      expect(ExceptionUtil.stringify(Exception('boom')), 'boom');
    });

    test('handles Dart Error', () {
      expect(
        ExceptionUtil.stringify(StateError('bad state')),
        'Bad state: bad state',
      );
    });

    test('handles plain String', () {
      expect(ExceptionUtil.stringify('hello'), 'hello');
    });

    test('handles unknown objects by calling toString', () {
      expect(ExceptionUtil.stringify([1, 2, 3]), '[1, 2, 3]');
    });
  });

  group('ExceptionUtil.summarize', () {
    test('prefixes runtime type', () {
      expect(ExceptionUtil.summarize(Exception('x')), startsWith('_Exception'));
      expect(ExceptionUtil.summarize(null), 'null');
    });
  });

  group('ExceptionUtil.formatStackTrace', () {
    test('returns empty for null', () {
      expect(ExceptionUtil.formatStackTrace(null), '');
    });

    test('indents lines and truncates long traces', () {
      final lines = List.generate(100, (i) => 'frame $i');
      final stack = StackTrace.fromString(lines.join('\n'));
      final formatted = ExceptionUtil.formatStackTrace(stack);
      expect(formatted.contains('frame 0'), isTrue);
      expect(formatted.contains('truncated'), isTrue);
    });
  });

  group('ExceptionUtil.tryCatch', () {
    test('returns result on success', () {
      expect(ExceptionUtil.tryCatch(() => 42), 42);
    });

    test('returns null on exception by default', () {
      expect(ExceptionUtil.tryCatch(() => throw Exception('x')), isNull);
    });

    test('onError receives both and can return a value', () {
      final v = ExceptionUtil.tryCatch(
        () => throw FormatException('bad'),
        onError: (e, st) => 'caught: $e',
      );
      expect(v, startsWith('caught:'));
    });
  });

  group('ExceptionUtil.tryCatchAsync', () {
    test('returns result on success', () async {
      expect(await ExceptionUtil.tryCatchAsync(() async => 7), 7);
    });

    test('returns null on exception', () async {
      expect(
        await ExceptionUtil.tryCatchAsync(() async => throw Exception('x')),
        isNull,
      );
    });
  });
}
