import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('BiMap', () {
    test('insert + forward / inverse lookup', () {
      final m = BiMap<String, int>();
      m['one'] = 1;
      m['two'] = 2;
      expect(m['one'], 1);
      expect(m.inverse[1], 'one');
      expect(m.inverse[2], 'two');
      expect(m.length, 2);
    });

    test('overwriting a key removes the old value', () {
      final m = BiMap<String, int>();
      m['a'] = 1;
      m['a'] = 2;
      expect(m.length, 1);
      expect(m.inverse.containsKey(1), isFalse);
      expect(m.inverse[2], 'a');
    });

    test('overwriting a value removes the old key', () {
      final m = BiMap<String, int>();
      m['a'] = 1;
      m['b'] = 1;
      expect(m.length, 1);
      expect(m['a'], isNull);
      expect(m['b'], 1);
      expect(m.inverse[1], 'b');
    });

    test('remove / removeValue keeps both sides in sync', () {
      final m = BiMap<String, int>();
      m['a'] = 1;
      m['b'] = 2;
      m.remove('a');
      expect(m.containsKey('a'), isFalse);
      expect(m.containsValue(1), isFalse);
      m.removeValue(2);
      expect(m.containsKey('b'), isFalse);
      expect(m.length, 0);
    });

    test('clear resets both maps', () {
      final m = BiMap<String, int>();
      m['a'] = 1;
      m['b'] = 2;
      m.clear();
      expect(m.isEmpty, isTrue);
      expect(m.inverse, isEmpty);
    });

    test('null value is a real mapping both directions', () {
      final m = BiMap<String, int?>();
      m['a'] = null;
      m['b'] = 2;
      expect(m['a'], isNull);
      expect(m.containsKey('a'), isTrue);
      expect(m.inverse[null], 'a');
      expect(m.containsValue(null), isTrue);
      expect(m.length, 2);
    });

    test('removing a null-valued key cleans the inverse too', () {
      final m = BiMap<String, int?>();
      m['a'] = null;
      m['b'] = null; // null is unique: replaces key 'a'
      expect(m.containsKey('a'), isFalse);
      expect(m.inverse[null], 'b');
      m.remove('b');
      expect(m.containsValue(null), isFalse);
      expect(m.inverse.containsKey(null), isFalse);
    });

    test('removeValue works for null values', () {
      final m = BiMap<String, int?>();
      m['a'] = null;
      m.removeValue(null);
      expect(m.containsKey('a'), isFalse);
      expect(m.isEmpty, isTrue);
    });
  });
}
