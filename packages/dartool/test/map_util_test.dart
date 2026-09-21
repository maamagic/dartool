import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('MapUtil getOrDefault / putIfAbsent', () {
    test('getOrDefault casts safely', () {
      final m = <String, dynamic>{'a': 1, 'b': 'hi'};
      expect(MapUtil.getOrDefault<String, String, dynamic>(m, 'a', 'x'), 'x');
      expect(MapUtil.getOrDefault<String, String, dynamic>(m, 'b', 'x'), 'hi');
      expect(
        MapUtil.getOrDefault<String, String, dynamic>(m, 'miss', 'def'),
        'def',
      );
      expect(MapUtil.getOrDefault<int, String, dynamic>(m, 'a', 0), 1);
    });

    test('putIfAbsent inserts only once', () {
      final m = <String, int>{};
      expect(MapUtil.putIfAbsent(m, 'a', 1), 1);
      expect(MapUtil.putIfAbsent(m, 'a', 99), 1);
      expect(m, {'a': 1});
    });
  });

  group('MapUtil mapKeys / mapValues / invert', () {
    test('transformations', () {
      final m = <String, int>{'a': 1, 'b': 2};
      expect(MapUtil.mapKeys(m, (k) => k.toUpperCase()), {'A': 1, 'B': 2});
      expect(MapUtil.mapValues(m, (v) => v * 10), {'a': 10, 'b': 20});
      expect(MapUtil.invert(m), <int, String>{1: 'a', 2: 'b'});
    });
  });

  group('MapUtil merge / filter / removeWhere', () {
    test('merge resolves duplicates', () {
      final a = {'a': 1, 'b': 2};
      final b = {'b': 3, 'c': 4};
      expect(MapUtil.merge(a, b), {'a': 1, 'b': 3, 'c': 4});
      expect(MapUtil.merge(a, b, resolver: (e, i) => e + i), {
        'a': 1,
        'b': 5,
        'c': 4,
      });
    });

    test('filter / removeWhere', () {
      final m = <String, int>{'a': 1, 'b': 2, 'c': 3};
      expect(MapUtil.filter(m, (k, v) => v.isEven), {'b': 2});
      expect(MapUtil.removeWhere(m, (k, v) => v.isEven), {'a': 1, 'c': 3});
    });
  });

  group('MapUtil of / fromIterable', () {
    test('build from parallel iterables', () {
      expect(MapUtil.of(['a', 'b', 'c'], [1, 2]), {'a': 1, 'b': 2});
      expect(MapUtil.of(['a'], [1, 2, 3]), {'a': 1});
    });

    test('fromIterable keyed extraction', () {
      final items = [_Item('a', 1), _Item('b', 2)];
      final map = MapUtil.fromIterable<String, _Item>(items, (e) => e.name);
      expect(map['a']!.val, 1);
      expect(map['b']!.val, 2);
    });
  });

  group('MapUtil flatten / unflatten', () {
    test('nested  flat', () {
      final nested = <String, dynamic>{
        'a': <String, dynamic>{
          'b': 1,
          'c': <String, dynamic>{'d': 2},
        },
        'e': 3,
      };
      expect(MapUtil.flatten(nested), {'a.b': 1, 'a.c.d': 2, 'e': 3});
    });

    test('flat  nested round-trip', () {
      final flat = <String, dynamic>{'a.b': 1, 'a.c': 2, 'e': 3};
      final nested = MapUtil.unflatten(flat);
      expect(nested, {
        'a': {'b': 1, 'c': 2},
        'e': 3,
      });
      // round-trip is lossless only when no intermediate scalar exists
      expect(MapUtil.flatten(nested), flat);
    });

    test('conflicting keys throw instead of silently dropping data', () {
      expect(
        () => MapUtil.unflatten(<String, dynamic>{'a.b': 1, 'a': 2}),
        throwsArgumentError,
      );
      expect(
        () => MapUtil.unflatten(<String, dynamic>{'a': 2, 'a.b': 1}),
        throwsArgumentError,
      );
      expect(
        () => MapUtil.unflatten(<String, dynamic>{'.b': 1}),
        throwsArgumentError,
      );
      expect(
        () => MapUtil.unflatten(<String, dynamic>{'a.b': 1}, separator: ''),
        throwsArgumentError,
      );
    });

    test('custom separator works', () {
      expect(MapUtil.unflatten(<String, dynamic>{'a/b': 1}, separator: '/'), {
        'a': {'b': 1},
      });
    });
  });
}

class _Item {
  _Item(this.name, this.val);
  final String name;
  final int val;
}
