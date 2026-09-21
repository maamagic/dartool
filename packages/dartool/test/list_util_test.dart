import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('ListUtil.partition', () {
    test('splits into n roughly equal chunks', () {
      expect(ListUtil.partition([1, 2, 3, 4, 5], 2), [
        [1, 2, 3],
        [4, 5],
      ]);
    });

    test('more chunks than elements produces empty tails', () {
      expect(ListUtil.partition([1, 2, 3], 5), [
        [1],
        [2],
        [3],
        <int>[],
        <int>[],
      ]);
    });

    test('empty list padded with empty chunks', () {
      expect(ListUtil.partition(<int>[], 3), [<int>[], <int>[], <int>[]]);
    });

    test('n <= 0 returns a one-element list with the whole input', () {
      expect(ListUtil.partition([1, 2], 0), [
        [1, 2],
      ]);
    });
  });

  group('ListUtil.insertSafe', () {
    test('clamps negative index to 0', () {
      final l = <int>[1, 2, 3];
      ListUtil.insertSafe(l, -1, 0);
      expect(l, [0, 1, 2, 3]);
    });

    test('clamps out-of-range index to end', () {
      final l = <int>[1, 2, 3];
      ListUtil.insertSafe(l, 99, 4);
      expect(l, [1, 2, 3, 4]);
    });
  });

  group('ListUtil.removeAtSafe', () {
    test('returns orElse for negative / out-of-range indices', () {
      expect(ListUtil.removeAtSafe([1, 2], -1, orElse: () => -99), -99);
      expect(ListUtil.removeAtSafe([1, 2], 2, orElse: () => -99), -99);
    });

    test('removes and returns element for valid index', () {
      final l = [1, 2, 3];
      expect(ListUtil.removeAtSafe(l, 1), 2);
      expect(l, [1, 3]);
    });
  });

  group('ListUtil.swap', () {
    test('exchanges two elements', () {
      final l = [1, 2, 3];
      ListUtil.swap(l, 0, 2);
      expect(l, [3, 2, 1]);
    });

    test('out-of-range indices are no-ops', () {
      final l = [1, 2, 3];
      ListUtil.swap(l, -1, 10);
      expect(l, [1, 2, 3]);
    });
  });

  group('ListUtil.shuffled', () {
    test('returns a list of same length with same elements', () {
      final l = List.generate(100, (i) => i);
      final s = ListUtil.shuffled(l);
      expect(s.length, 100);
      expect(s.toSet(), l.toSet());
    });
  });

  group('ListUtil.elementAtOrElse / firstOrNull / lastOrNull', () {
    test('elementAtOrElse', () {
      expect(ListUtil.elementAtOrElse([1, 2], 10, (_) => -1), -1);
      expect(ListUtil.elementAtOrElse([1, 2], 0, (_) => -1), 1);
    });

    test('firstOrNull / lastOrNull', () {
      expect(ListUtil.firstOrNull([1, 2, 3], (e) => e > 1), 2);
      expect(ListUtil.firstOrNull([1, 2, 3], (e) => e > 9), isNull);
      expect(ListUtil.lastOrNull([1, 2, 3], (e) => e < 3), 2);
      expect(ListUtil.lastOrNull([1, 2, 3], (e) => e < 0), isNull);
    });
  });

  group('SetUtil', () {
    test('union merges both sets', () {
      expect(SetUtil.union({1, 2}, {2, 3}), {1, 2, 3});
    });

    test('intersection keeps only common elements', () {
      expect(SetUtil.intersection({1, 2, 3}, {2, 3, 4}), {2, 3});
    });

    test('difference removes b from a', () {
      expect(SetUtil.difference({1, 2, 3}, {2}), {1, 3});
    });

    test('symmetricDifference keeps elements in one set only', () {
      expect(SetUtil.symmetricDifference({1, 2}, {2, 3}), {1, 3});
    });

    test('from preserves insertion order', () {
      expect(SetUtil.from([3, 1, 2]), {3, 1, 2});
    });
  });

  group('ListX extensions', () {
    test('sortByAsc / sortByDesc', () {
      final l = <int>[3, 1, 2]..sortByAsc((e) => e);
      expect(l, [1, 2, 3]);
      final l2 = <int>[3, 1, 2]..sortByDesc((e) => e);
      expect(l2, [3, 2, 1]);
    });

    test('distinct preserves order', () {
      expect([2, 1, 2, 3, 1].distinct(), [2, 1, 3]);
    });

    test('all / anyOf', () {
      expect([1, 2, 3].all((e) => e > 0), isTrue);
      expect([1, 2, 3].all((e) => e > 1), isFalse);
      expect([1, 2, 3].anyOf((e) => e == 2), isTrue);
      expect([1, 2, 3].anyOf((e) => e == 9), isFalse);
    });

    test('partition through extension', () {
      expect([1, 2, 3, 4].partition(2), [
        [1, 2],
        [3, 4],
      ]);
    });

    test('firstOrNull / lastOrNull / indexWhereOrNull', () {
      final l = <int>[1, 2, 3, 4];
      expect(l.firstOrNull((e) => e > 2), 3);
      expect(l.lastOrNull((e) => e < 3), 2);
      expect(l.indexWhereOrNull((e) => e == 3), 2);
      expect(l.indexWhereOrNull((e) => e == 9), -1);
    });

    test('shuffled / reversedCopy / insertSafe / removeAtSafe', () {
      expect([1, 2, 3].reversedCopy, [3, 2, 1]);
      final l = <int>[1, 2, 3];
      l.insertSafe(99, 4);
      expect(l, [1, 2, 3, 4]);
      expect(l.removeAtSafe(10, orElse: () => -1), -1);
    });
  });
}
