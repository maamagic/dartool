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
  });
}
