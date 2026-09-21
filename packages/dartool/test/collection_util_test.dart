import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('CollectionUtil 判空', () {
    test('isEmpty / isNotEmpty', () {
      expect(CollectionUtil.isEmpty(null), isTrue);
      expect(CollectionUtil.isEmpty(<int>[]), isTrue);
      expect(CollectionUtil.isEmpty([1]), isFalse);
      expect(CollectionUtil.isNotEmpty([1]), isTrue);
    });
  });

  group('CollectionUtil 变换', () {
    test('distinct 保持顺序去重', () {
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

  group('CollectionUtil 取元素', () {
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
}
