import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('RandomUtil numeric', () {
    test('nextInt respects min / max bounds', () {
      for (var i = 0; i < 100; i++) {
        final v = RandomUtil.nextInt(10);
        expect(v, greaterThanOrEqualTo(0));
        expect(v, lessThan(10));
      }
      for (var i = 0; i < 100; i++) {
        final v = RandomUtil.nextInt(20, min: 5);
        expect(v, greaterThanOrEqualTo(5));
        expect(v, lessThan(20));
      }
    });

    test('nextDouble respects bounds', () {
      for (var i = 0; i < 100; i++) {
        final v = RandomUtil.nextDouble(min: 2.0, max: 5.0);
        expect(v, greaterThanOrEqualTo(2.0));
        expect(v, lessThan(5.0));
      }
    });

    test('nextBool with probability 0/1 is deterministic', () {
      expect(RandomUtil.nextBool(probability: 0), isFalse);
      expect(RandomUtil.nextBool(probability: 1), isTrue);
    });

    test('min >= max throws', () {
      expect(() => RandomUtil.nextInt(5, min: 5), throwsArgumentError);
      expect(() => RandomUtil.nextDouble(min: 5, max: 5), throwsArgumentError);
    });
  });

  group('RandomUtil string', () {
    test('randomString respects length and pool', () {
      final s = RandomUtil.randomString(10, chars: 'ab');
      expect(s.length, 10);
      expect(s.runes.every((r) => r == 0x61 || r == 0x62), isTrue);
    });

    test('randomHex / randomAlpha / randomNumeric', () {
      final hex = RandomUtil.randomHex(16);
      expect(hex.length, 16);
      expect(hex, matches(RegExp(r'^[0-9a-f]{16}$')));

      final alpha = RandomUtil.randomAlpha(20);
      expect(alpha.length, 20);
      expect(alpha, matches(RegExp(r'^[A-Za-z]{20}$')));

      final num = RandomUtil.randomNumeric(8);
      expect(num.length, 8);
      expect(num, matches(RegExp(r'^[0-9]{8}$')));
    });

    test('randomString length 0 returns empty', () {
      expect(RandomUtil.randomString(0), '');
    });
  });

  group('RandomUtil collection', () {
    test('shuffle reorders list', () {
      final original = List.generate(20, (i) => i);
      final copy = List<int>.from(original);
      RandomUtil.shuffle(copy);
      // Same elements
      expect(copy..sort(), orderedEquals(original));
    });

    test('sample takes n items without duplicates', () {
      final src = List.generate(100, (i) => i);
      final s = RandomUtil.sample(src, 10);
      expect(s.length, 10);
      expect(s.toSet().length, 10);
    });

    test('sample with n >= length returns shuffled copy', () {
      final src = [1, 2, 3];
      final s = RandomUtil.sample(src, 10);
      expect(s.length, 3);
    });

    test('pick returns null on empty', () {
      expect(RandomUtil.pick<int>([]), isNull);
    });

    test('pickWeighted skews to heavier weight', () {
      var a = 0;
      var b = 0;
      for (var i = 0; i < 1000; i++) {
        final picked = RandomUtil.pickWeighted<String>(
          ['a', 'b'],
          [999.0, 1.0],
        );
        if (picked == 'a') a++;
        if (picked == 'b') b++;
      }
      expect(a, greaterThan(900));
      expect(b, lessThan(100));
    });
  });
}
