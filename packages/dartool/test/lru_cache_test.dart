import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('LruCache basic', () {
    test('put / get / contains', () {
      final c = LruCache<String, int>(capacity: 3);
      c.set('a', 1);
      c.set('b', 2);
      expect(c.get('a'), 1);
      expect(c.get('c'), isNull);
      expect(c.contains('a'), isTrue);
      expect(c.contains('c'), isFalse);
      expect(c.length, 2);
    });

    test('evicts least-recently-used when over capacity', () {
      final c = LruCache<String, int>(capacity: 2);
      c.set('a', 1);
      c.set('b', 2);
      c.set('c', 3);
      expect(c.get('a'), isNull);
      expect(c.get('b'), 2);
      expect(c.get('c'), 3);
    });

    test('get refreshes recency so eviction skips accessed keys', () {
      final c = LruCache<String, int>(capacity: 3);
      c.set('a', 1);
      c.set('b', 2);
      c.set('c', 3);
      expect(c.get('a'), 1);
      c.set('d', 4);
      expect(c.get('a'), 1);
      expect(c.get('b'), isNull);
      expect(c.get('c'), 3);
      expect(c.get('d'), 4);
    });

    test('putIfAbsent computes once', () {
      final c = LruCache<String, int>(capacity: 10);
      var calls = 0;
      final v = c.putIfAbsent('x', () {
        calls++;
        return 100;
      });
      expect(v, 100);
      c.putIfAbsent('x', () {
        calls++;
        return 999;
      });
      expect(calls, 1);
    });

    test('remove / clear', () {
      final c = LruCache<String, int>(capacity: 10);
      c.set('a', 1);
      c.set('b', 2);
      c.remove('a');
      expect(c.length, 1);
      c.clear();
      expect(c.isEmpty, isTrue);
    });

    test('invalid capacity throws ArgumentError', () {
      expect(() => LruCache<String, int>(capacity: 0), throwsArgumentError);
      expect(() => LruCache<String, int>(capacity: -2), throwsArgumentError);
    });
  });

  group('LruCache nullable values', () {
    test('putIfAbsent respects an explicitly cached null', () {
      final c = LruCache<String, int?>(capacity: 2);
      var calls = 0;
      c.set('a', null);
      expect(c.get('a'), isNull);
      expect(c.contains('a'), isTrue);
      final v = c.putIfAbsent('a', () {
        calls++;
        return 42;
      });
      expect(v, isNull);
      expect(calls, 0);
    });

    test('putIfAbsent inserts null when absent and keeps it', () {
      final c = LruCache<String, int?>(capacity: 2);
      var calls = 0;
      final v = c.putIfAbsent('a', () {
        calls++;
        return null;
      });
      expect(v, isNull);
      expect(calls, 1);
      c.putIfAbsent('a', () {
        calls++;
        return 1;
      });
      expect(calls, 1);
      expect(c.contains('a'), isTrue);
    });
  });

  group('LruCache with TTL', () {
    test('expired values return null', () async {
      final c = LruCache<String, int>(
        capacity: 10,
        ttl: Duration(milliseconds: 30),
      );
      c.set('a', 1);
      expect(c.get('a'), 1);
      await Future<void>.delayed(Duration(milliseconds: 40));
      expect(c.get('a'), isNull);
    });

    test('evictExpired cleans up', () async {
      final c = LruCache<String, int>(
        capacity: 10,
        ttl: Duration(milliseconds: 30),
      );
      c.set('a', 1);
      c.set('b', 2);
      await Future<void>.delayed(Duration(milliseconds: 40));
      final removed = c.evictExpired();
      expect(removed, 2);
      expect(c.isEmpty, isTrue);
    });
  });
}
