import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('IdUtil', () {
    test('uuid 符合 v4 格式', () {
      final id = IdUtil.uuid();
      expect(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ).hasMatch(id),
        isTrue,
      );
    });

    test('simpleUuid 无连字符且 32 位', () {
      final id = IdUtil.simpleUuid();
      expect(id.length, 32);
      expect(id.contains('-'), isFalse);
    });

    test('randomId 长度与字符集', () {
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
    test('ID 单调递增且位数合法', () {
      final gen = IdUtil.snowflake(workerId: 1);
      var prev = gen.nextId();
      for (var i = 0; i < 1000; i++) {
        final next = gen.nextId();
        expect(next, greaterThan(prev));
        expect(next, greaterThanOrEqualTo(0));
        prev = next;
      }
    });

    test('workerId 越界抛异常', () {
      expect(() => IdUtil.snowflake(workerId: 1024), throwsArgumentError);
      expect(() => IdUtil.snowflake(workerId: -1), throwsArgumentError);
    });

    test('同毫秒内序列自增不重复', () {
      final gen = IdUtil.snowflake();
      final set = <int>{};
      for (var i = 0; i < 5000; i++) {
        final id = gen.nextId();
        expect(set.add(id), isTrue, reason: 'duplicate id: $id');
      }
    });
  });
}
