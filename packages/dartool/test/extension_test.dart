import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('StringX extension', () {
    test('basic predicates', () {
      expect('  '.isBlank, isTrue);
      expect('hi'.isBlank, isFalse);
      expect('hello world'.isAscii, isTrue);
      expect(''.isAlphabetic, isFalse);
    });

    test('case conversions', () {
      expect('hello_world'.camelCase, 'helloWorld');
      expect('HelloWorld'.snakeCase, 'hello_world');
      expect('hello-world'.pascalCase, 'HelloWorld');
      expect('HelloWorld'.kebabCase, 'hello-world');
      expect('helloWorld-foo_bar'.words, ['hello', 'World', 'foo', 'bar']);
    });

    test('other helpers', () {
      expect('hello'.capitalize, 'Hello');
      expect('hello world'.truncate(5), 'hello...');
      expect('ab'.repeat(3), 'ababab');
      expect('hello world'.countChar('l'), 3);
      expect('hello'.startsWithIgnoreCase('HE'), isTrue);
      expect('  hi  '.trimmed, 'hi');
      expect('nullish'.ifBlank('fallback'), 'nullish');
      expect('abc'.wrap('*'), '*abc*');
    });

    test('nullable extension', () {
      const String? a = null;
      expect(a.isBlank, isTrue);
      expect(a.orEmpty, '');
    });
  });

  group('IterableX / ListX', () {
    test('iterable predicates', () {
      expect([1, 2, 3].all((x) => x > 0), isTrue);
      expect([1, 2, 3].any((x) => x == 2), isTrue);
      expect([1, 2, 3, 4].filter((x) => x.isEven), [2, 4]);
      expect([1, null, 2, null, 3].whereNotNull(), [1, 2, 3]);
    });

    test('num iterable aggregate', () {
      expect([1, 2, 3].sum(), 6);
      expect([1, 2, 3].average(), 2.0);
      expect([3, 1, 2].min(), 1);
      expect([3, 1, 2].max(), 3);
      expect(<int>[].sum(), 0);
      expect(<int>[].average(), 0.0);
    });

    test('double iterable sum (regression: 0 as T crash)', () {
      final doubles = [1.5, 2.5];
      expect(doubles.sum(), 4.0);
      expect(doubles.sum(), isA<double>());
      final empty = <double>[];
      expect(empty.sum(), 0.0);
      expect(empty.sum(), isA<double>());
    });

    test('list chunk / windowed', () {
      expect([1, 2, 3, 4, 5].chunk(2), [
        [1, 2],
        [3, 4],
        [5],
      ]);
      expect([1, 2, 3, 4].windowed(3, step: 1), [
        [1, 2, 3],
        [2, 3, 4],
      ]);
      expect([1, 2, 3, 4].windowed(3, step: 3, includePartial: true), [
        [1, 2, 3],
        [4],
      ]);
    });

    test('list distinctBy / sortedCopy / swap / groupBy', () {
      final items = [_Entity('a', 1), _Entity('b', 1), _Entity('c', 2)];
      expect(items.distinctBy((e) => e.val).length, 2);
      expect([3, 1, 2].sortedCopy((a, b) => a.compareTo(b)), [1, 2, 3]);
      expect(() => [1, 2, 3].swap(0, 2), returnsNormally);
      final grouped = items.groupBy((e) => e.val);
      expect(grouped[1]!.length, 2);
      expect(grouped[2]!.length, 1);
    });
  });

  group('NumX / IntX', () {
    test('num helpers', () {
      expect(3.1415.roundNum(decimal: 2), 3.14);
      expect(1234567.formatThousand(), '1,234,567');
      expect(50.mapRange(0, 100, 0, 1), 0.5);
    });

    test('int formatBytes', () {
      expect(1024.formatBytes(decimals: 1), '1.0 KB');
      expect((1024 * 1024).formatBytes(decimals: 1), '1.0 MB');
    });
  });

  group('DateTimeX', () {
    final fixed = DateTime(2024, 1, 31, 10, 0, 0);
    test('predicates and arithmetic', () {
      expect(fixed.isSameDayAs(DateTime(2024, 1, 31, 23)), isTrue);
      expect(fixed.addMonths(1), DateTime(2024, 2, 29, 10));
      expect(fixed.copyWith(year: 2025, day: 1), DateTime(2025, 1, 1, 10));
    });

    test('format and relative', () {
      expect(fixed.format('yyyy/MM/dd'), '2024/01/31');
      expect(fixed.weekdayName, 'Wednesday');
    });
  });

  group('MapX', () {
    test('getOrDefault / invert / merge', () {
      final map = <String, int>{'a': 1, 'b': 2};
      expect(map.getOrDefault('c', 99), 99);
      expect(map.invert(), <int, String>{1: 'a', 2: 'b'});
      final merged = map.merge({'b': 3, 'c': 4}, resolver: (e, i) => e + i);
      expect(merged, {'a': 1, 'b': 5, 'c': 4});
    });

    test('mapKeys / mapValues', () {
      final map = <String, int>{'a': 1, 'b': 2};
      expect(map.mapKeys((k) => k.toUpperCase()), {'A': 1, 'B': 2});
      expect(map.mapValues((v) => v * 2), {'a': 2, 'b': 4});
    });

    test('removeWhere', () {
      final map = <String, int>{'a': 1, 'b': 2, 'c': 3};
      expect(map.withoutWhere((k, v) => v.isEven), {'a': 1, 'c': 3});
    });
  });

  group('DurationX', () {
    test('formatCompact / formatClock', () {
      expect(Duration(hours: 2, minutes: 30).formatCompact(), '2h30m');
      expect(Duration(minutes: 15, seconds: 5).formatCompact(), '15m5s');
      expect(Duration(seconds: 45).formatClock(), '00:45');
      expect(Duration(hours: 1, minutes: 2).formatClock(), '01:02:00');
    });
  });
}

class _Entity {
  _Entity(this.name, this.val);
  final String name;
  final int val;
}
