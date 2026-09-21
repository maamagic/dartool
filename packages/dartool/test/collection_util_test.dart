import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('CollectionUtil ', () {
    test('isEmpty / isNotEmpty', () {
      expect(CollectionUtil.isEmpty(null), isTrue);
      expect(CollectionUtil.isEmpty(<int>[]), isTrue);
      expect(CollectionUtil.isEmpty([1]), isFalse);
      expect(CollectionUtil.isNotEmpty([1]), isTrue);
    });
  });

  group('CollectionUtil ', () {
    test('distinct ', () {
      expect(CollectionUtil.distinct([3, 1, 3, 2, 1]), [3, 1, 2]);
    });

    test('groupBy', () {
      final g = CollectionUtil.groupBy([
        'apple',
        'avocado',
        'banana',
      ], (s) => s[0]);
      expect(g['a'], ['apple', 'avocado']);
      expect(g['b'], ['banana']);
    });

    test('chunk', () {
      expect(CollectionUtil.chunk([1, 2, 3, 4, 5], 2), [
        [1, 2],
        [3, 4],
        [5],
      ]);
      expect(CollectionUtil.chunk([1], 3), [
        [1],
      ]);
      expect(() => CollectionUtil.chunk([1], 0), throwsArgumentError);
    });

    test('flatten', () {
      expect(
        CollectionUtil.flatten([
          [1, 2],
          [3],
        ]),
        [1, 2, 3],
      );
    });

    test('sortBy', () {
      final sorted = CollectionUtil.sortBy(['bbb', 'a', 'cc'], (s) => s.length);
      expect(sorted, ['a', 'cc', 'bbb']);
      final desc = CollectionUtil.sortBy(
        ['a', 'cc', 'bbb'],
        (s) => s.length,
        desc: true,
      );
      expect(desc, ['bbb', 'cc', 'a']);
    });
  });

  group('CollectionUtil  ', () {
    test('firstOrNull / lastOrNull / elementAtOrNull', () {
      expect(CollectionUtil.firstOrNull(<int>[]), isNull);
      expect(CollectionUtil.firstOrNull([1, 2]), 1);
      expect(CollectionUtil.lastOrNull([1, 2]), 2);
      expect(CollectionUtil.elementAtOrNull([1, 2], 5), isNull);
      expect(CollectionUtil.elementAtOrNull([1, 2], -1), isNull);
      expect(CollectionUtil.getOrDefault([1, 2], 9, 0), 0);
    });

    test('toMap / countWhere', () {
      expect(CollectionUtil.toMap(['a', 'b'], [1, 2]), {'a': 1, 'b': 2});
      expect(CollectionUtil.countWhere([1, 2, 3, 4], (x) => x.isEven), 2);
    });
  });

  group('CollectionUtil conversion helpers', () {
    test('toList / toSet handle null', () {
      expect(CollectionUtil.toList<int>(null), <int>[]);
      expect(CollectionUtil.toList([1, 2]), [1, 2]);
      expect(CollectionUtil.toSet<int>(null), <int>{});
      expect(CollectionUtil.toSet([1, 1, 2]), {1, 2});
    });

    test('joinToString', () {
      expect(CollectionUtil.joinToString([1, 2, 3]), '1,2,3');
      expect(CollectionUtil.joinToString([1, 2, 3], separator: '-'), '1-2-3');
    });
  });

  group('CollectionUtil aggregates', () {
    test('sumOf / averageOf', () {
      final items = [_Item('a', 10), _Item('b', 20), _Item('c', 30)];
      expect(CollectionUtil.sumOf<_Item, int>(items, (e) => e.val), 60);
      expect(CollectionUtil.averageOf<_Item>(items, (e) => e.val), 20.0);
      expect(CollectionUtil.averageOf<_Item>([], (e) => e.val), 0.0);
    });

    test('sumOf with double result (regression: 0 as N crash)', () {
      final items = [_DItem('a', 1.5), _DItem('b', 2.5)];
      final total = CollectionUtil.sumOf<_DItem, double>(items, (e) => e.val);
      expect(total, 4.0);
      expect(total, isA<double>());

      final empty = CollectionUtil.sumOf<_DItem, double>(
        const <_DItem>[],
        (e) => e.val,
      );
      expect(empty, 0.0);
      expect(empty, isA<double>());
    });

    test('minOf / maxOf', () {
      final items = [_Item('a', 30), _Item('b', 10), _Item('c', 20)];
      expect(CollectionUtil.minOf(items, (e) => e.val)!.name, 'b');
      expect(CollectionUtil.maxOf(items, (e) => e.val)!.name, 'a');
      expect(CollectionUtil.minOf<_Item, num>([], (e) => e.val), isNull);
    });
  });

  group('CollectionUtil mapList / filter / all / any / whereNotNull', () {
    test('mapList / filter', () {
      expect(CollectionUtil.mapList([1, 2, 3], (x) => x * 2), [2, 4, 6]);
      expect(CollectionUtil.filter([1, 2, 3, 4], (x) => x.isEven), [2, 4]);
    });

    test('all / any', () {
      expect(CollectionUtil.all([2, 4, 6], (x) => x.isEven), isTrue);
      expect(CollectionUtil.all([2, 4, 5], (x) => x.isEven), isFalse);
      expect(CollectionUtil.any([1, 3, 5], (x) => x.isEven), isFalse);
      expect(CollectionUtil.any([1, 4, 5], (x) => x.isEven), isTrue);
    });

    test('whereNotNull removes nulls', () {
      final mixed = <int?>[1, null, 2, null, 3];
      expect(CollectionUtil.whereNotNull(mixed), [1, 2, 3]);
    });
  });
}

class _Item {
  final String name;
  final int val;
  _Item(this.name, this.val);
}

class _DItem {
  final String name;
  final double val;
  _DItem(this.name, this.val);
}
