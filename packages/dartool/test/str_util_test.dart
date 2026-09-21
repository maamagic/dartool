import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('StrUtil.isBlank / isEmpty', () {
    test('isBlank 识别 null/空/纯空白', () {
      expect(StrUtil.isBlank(null), isTrue);
      expect(StrUtil.isBlank(''), isTrue);
      expect(StrUtil.isBlank('   '), isTrue);
      expect(StrUtil.isBlank('abc'), isFalse);
    });

    test('isEmpty 不忽略空白', () {
      expect(StrUtil.isEmpty(null), isTrue);
      expect(StrUtil.isEmpty(''), isTrue);
      expect(StrUtil.isEmpty('   '), isFalse);
      expect(StrUtil.isNotEmpty('x'), isTrue);
    });
  });

  group('StrUtil 命名风格转换', () {
    test('toCamelCase', () {
      expect(StrUtil.toCamelCase('hello_world'), 'helloWorld');
      expect(StrUtil.toCamelCase('hello-world'), 'helloWorld');
      expect(StrUtil.toCamelCase('hello world'), 'helloWorld');
      expect(StrUtil.toCamelCase(''), '');
    });

    test('toSnakeCase / toKebabCase', () {
      expect(StrUtil.toSnakeCase('helloWorld'), 'hello_world');
      expect(StrUtil.toSnakeCase('HelloWorld'), 'hello_world');
      expect(StrUtil.toKebabCase('helloWorld'), 'hello-world');
    });
  });

  group('StrUtil 其他能力', () {
    test('isNumeric', () {
      expect(StrUtil.isNumeric('123'), isTrue);
      expect(StrUtil.isNumeric('12a'), isFalse);
      expect(StrUtil.isNumeric(''), isFalse);
    });

    test('trim / truncate / pad', () {
      expect(StrUtil.trim('  x  '), 'x');
      expect(StrUtil.truncate('hello world', 5), 'hello...');
      expect(StrUtil.truncate('hi', 5), 'hi');
      expect(StrUtil.padLeft('5', 3, '0'), '005');
      expect(StrUtil.repeat('ab', 3), 'ababab');
    });

    test('capitalize / hide / ignore case', () {
      expect(StrUtil.capitalize('hello'), 'Hello');
      expect(StrUtil.uncapitalize('Hello'), 'hello');
      expect(StrUtil.hide('13812345678', 3, 4), '138****5678');
      expect(StrUtil.containsIgnoreCase('Hello World', 'hello'), isTrue);
      expect(StrUtil.equalsIgnoreCase('AbC', 'aBc'), isTrue);
    });
  });
}
