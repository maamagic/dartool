import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('StrUtil.isBlank / isEmpty', () {
    test('isBlank  null/', () {
      expect(StrUtil.isBlank(null), isTrue);
      expect(StrUtil.isBlank(''), isTrue);
      expect(StrUtil.isBlank('   '), isTrue);
      expect(StrUtil.isBlank('abc'), isFalse);
    });

    test('isEmpty ', () {
      expect(StrUtil.isEmpty(null), isTrue);
      expect(StrUtil.isEmpty(''), isTrue);
      expect(StrUtil.isEmpty('   '), isFalse);
      expect(StrUtil.isNotEmpty('x'), isTrue);
    });
  });

  group('StrUtil  ', () {
    test('toCamelCase', () {
      expect(StrUtil.toCamelCase('hello_world'), 'helloWorld');
      expect(StrUtil.toCamelCase('hello-world'), 'helloWorld');
      expect(StrUtil.toCamelCase('hello world'), 'helloWorld');
      expect(StrUtil.toCamelCase('HelloWorld'), 'helloWorld');
      expect(StrUtil.toCamelCase(''), '');
    });

    test('toSnakeCase / toKebabCase / toPascalCase', () {
      expect(StrUtil.toSnakeCase('helloWorld'), 'hello_world');
      expect(StrUtil.toSnakeCase('HelloWorld'), 'hello_world');
      expect(StrUtil.toKebabCase('helloWorld'), 'hello-world');
      expect(StrUtil.toPascalCase('hello_world'), 'HelloWorld');
      expect(StrUtil.toPascalCase('hello-world'), 'HelloWorld');
      expect(StrUtil.toPascalCase('helloWorld'), 'HelloWorld');
    });

    test('toWords splits any casing', () {
      expect(StrUtil.toWords('helloWorld-foo_bar'), [
        'hello',
        'World',
        'foo',
        'bar',
      ]);
      expect(StrUtil.toWords('HelloWorld'), ['Hello', 'World']);
      expect(StrUtil.toWords(''), isEmpty);
    });
  });

  group('StrUtil ', () {
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

    test('hide keeps the original string when too short', () {
      // previously the visible prefix/suffix were replaced by the mask,
      // destroying data
      expect(StrUtil.hide('12345', 3, 4), '12345');
      expect(StrUtil.hide('12345678', 3, 4), '123****5678');
      expect(StrUtil.hide('abcd', 0, 2), '****cd');
      expect(StrUtil.hide('ab', 0, 0), '****');
      expect(() => StrUtil.hide('abc', -1, 1), throwsArgumentError);
      expect(() => StrUtil.hide('abc', 1, -1), throwsArgumentError);
    });
  });

  group('StrUtil character-type checks', () {
    test('isAscii', () {
      expect(StrUtil.isAscii('hello 123'), isTrue);
      expect(StrUtil.isAscii(''), isFalse);
      expect(StrUtil.isAscii(''), isFalse);
    });

    test('isAlphabetic / isAlphanumeric', () {
      expect(StrUtil.isAlphabetic('HelloWorld'), isTrue);
      expect(StrUtil.isAlphabetic('Hello123'), isFalse);
      expect(StrUtil.isAlphanumeric('Hello123'), isTrue);
      expect(StrUtil.isAlphanumeric('Hello 123'), isFalse);
    });

    test('isAlphabetic / isAlphanumeric support CJK letters', () {
      expect(StrUtil.isAlphabetic('中文'), isTrue);
      expect(StrUtil.isAlphabetic('你好世界'), isTrue);
      expect(StrUtil.isAlphabetic('中文1'), isFalse);
      expect(StrUtil.isAlphanumeric('中文123'), isTrue);
      expect(StrUtil.isAlphanumeric('café'), isTrue);
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

  group('padCenter / chunked / hideEmail / hidePhone', () {
    test('padCenter', () {
      expect(StrUtil.padCenter('ab', 5), ' ab  ');
      expect(StrUtil.padCenter('ab', 5, '-'), '-ab--');
      expect(StrUtil.padCenter('hello', 3), 'hello');
    });

    test('chunked', () {
      expect(StrUtil.chunked('abcdefg', 3), ['abc', 'def', 'g']);
      expect(StrUtil.chunked('abc', 5), ['abc']);
      expect(StrUtil.chunked('', 2), isEmpty);
      expect(StrUtil.chunked('abc', 0), isEmpty);
    });

    test('hideEmail', () {
      expect(StrUtil.hideEmail('test@example.com'), 't****@example.com');
      expect(StrUtil.hideEmail('a@b.com'), 'a@b.com');
    });

    test('hidePhone', () {
      expect(StrUtil.hidePhone('13812345678'), '138****5678');
      expect(StrUtil.hidePhone('123'), '123');
    });
  });
}
