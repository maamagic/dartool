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

  group('StrUtil character-type checks', () {
    test('isAscii', () {
      expect(StrUtil.isAscii('hello 123'), isTrue);
      expect(StrUtil.isAscii('中文'), isFalse);
      expect(StrUtil.isAscii(''), isFalse);
    });

    test('isAlphabetic / isAlphanumeric', () {
      expect(StrUtil.isAlphabetic('HelloWorld'), isTrue);
      expect(StrUtil.isAlphabetic('Hello123'), isFalse);
      expect(StrUtil.isAlphanumeric('Hello123'), isTrue);
      expect(StrUtil.isAlphanumeric('Hello 123'), isFalse);
    });
  });

  group('StrUtil case-insensitive starts/ends', () {
    test('startsWithIgnoreCase / endsWithIgnoreCase', () {
      expect(StrUtil.startsWithIgnoreCase('HelloWorld', 'hello'), isTrue);
      expect(StrUtil.startsWithIgnoreCase('HelloWorld', 'xyz'), isFalse);
      expect(StrUtil.endsWithIgnoreCase('HelloWorld', 'WORLD'), isTrue);
      expect(StrUtil.endsWithIgnoreCase('HelloWorld', 'xyz'), isFalse);
    });
  });

  group('StrUtil split / join / reverse / between', () {
    test('splitAndTrim drops empty pieces', () {
      expect(StrUtil.splitAndTrim(' a, b , ,c ', ','), ['a', 'b', 'c']);
      expect(StrUtil.splitAndTrim(' a, b , ,c ', ',', dropEmpty: false), [
        'a',
        'b',
        '',
        'c',
      ]);
    });

    test('join filters null/empty', () {
      expect(StrUtil.join(['a', '', 'b', null, 'c'], '-'), 'a-b-c');
    });

    test('reverse / countChar / between', () {
      expect(StrUtil.reverse('hello'), 'olleh');
      expect(StrUtil.countChar('banana', 'a'), 3);
      expect(StrUtil.between('<!-- hi -->', '<!-- ', ' -->'), 'hi');
      expect(StrUtil.between('abc', '[', ']'), '');
    });
  });

  group('StrUtil removePrefix / removeSuffix / wrap / ifBlank', () {
    test('removePrefix / removeSuffix', () {
      expect(StrUtil.removePrefix('prefix_world', 'prefix_'), 'world');
      expect(StrUtil.removePrefix('world', 'prefix_'), 'world');
      expect(StrUtil.removeSuffix('hello.dart', '.dart'), 'hello');
      expect(StrUtil.removeSuffix('hello', '.dart'), 'hello');
    });

    test('wrap / ifBlank', () {
      expect(StrUtil.wrap('hi', '"'), '"hi"');
      expect(StrUtil.ifBlank(null, 'default'), 'default');
      expect(StrUtil.ifBlank('   ', 'default'), 'default');
      expect(StrUtil.ifBlank('ok', 'default'), 'ok');
    });
  });
}
