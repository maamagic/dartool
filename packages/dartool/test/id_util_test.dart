import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  // On the web every int is an IEEE double, so full 64-bit snowflake ids are
  // not exactly representable; nextIdString() is the web-safe API.
  final isVm = !identical(0, 0.0);
  const vmOnly = 'full 64-bit int precision is only available on the VM';

  group('IdUtil', () {
    test('uuid  v4  ', () {
      final id = IdUtil.uuid();
      expect(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ).hasMatch(id),
        isTrue,
      );
    });

    test('simpleUuid   32 ', () {
      final id = IdUtil.simpleUuid();
      expect(id.length, 32);
      expect(id.contains('-'), isFalse);
    });

    test('randomId ', () {
      expect(IdUtil.randomId(8).length, 8);
      expect(IdUtil.randomId(16, charset: 'ab').length, 16);
      expect(
        IdUtil.randomId(
          16,
          charset: 'ab',
        ).split('').every((c) => c == 'a' || c == 'b'),
        isTrue,
      );
      expect(() => IdUtil.randomId(0), throwsArgumentError);
    });
  });

  group('SnowflakeIdGenerator', () {
    test('ID ', () {
      final gen = IdUtil.snowflake(workerId: 1);
      var prev = gen.nextId();
      for (var i = 0; i < 1000; i++) {
        final next = gen.nextId();
        expect(next, greaterThan(prev));
        expect(next, greaterThanOrEqualTo(0));
        prev = next;
      }
    }, skip: isVm ? false : vmOnly);

    test('workerId ', () {
      expect(() => IdUtil.snowflake(workerId: 1024), throwsArgumentError);
      expect(() => IdUtil.snowflake(workerId: -1), throwsArgumentError);
    });

    test('5000 generated ids are unique', () {
      final gen = IdUtil.snowflake();
      final set = <int>{};
      for (var i = 0; i < 5000; i++) {
        final id = gen.nextId();
        expect(set.add(id), isTrue, reason: 'duplicate id: $id');
      }
    }, skip: isVm ? false : vmOnly);

    test('nextIdString encodes the same 64-bit layout (web-safe)', () {
      const workerId = 7;
      final gen = IdUtil.snowflake(workerId: workerId);
      for (var i = 0; i < 100; i++) {
        final s = gen.nextIdString();
        // purely numeric decimal
        expect(RegExp(r'^\d+$').hasMatch(s), isTrue);
        if (isVm) {
          // bit layout is only inspectable via exact 64-bit ints
          final id = int.parse(s);
          expect((id >> 12) & 0x3FF, workerId);
          expect(id >> 22, greaterThan(0));
        }
      }
    });

    test('nextIdString values are unique and monotonic', () {
      final gen = IdUtil.snowflake(workerId: 1023);
      final seen = <String>{};
      String? prev;
      for (var i = 0; i < 3000; i++) {
        final s = gen.nextIdString();
        expect(seen.add(s), isTrue, reason: 'duplicate id string: $s');
        if (prev != null) {
          // same-length numeric strings compare lexicographically
          expect(s.length, greaterThanOrEqualTo(prev.length));
          if (s.length == prev.length) {
            expect(s.compareTo(prev), greaterThan(0));
          }
        }
        prev = s;
      }
    });
  });
}
