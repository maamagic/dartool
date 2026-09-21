import 'dart:io';

import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  final tmp = Directory.systemTemp.createTempSync('dartool_io_');
  final testFile = File('${tmp.path}\\io_test.txt');

  tearDownAll(() {
    try {
      tmp.deleteSync(recursive: true);
    } catch (_) {}
  });

  group('IoUtil.writeString / readString', () {
    test('write then read', () {
      expect(IoUtil.writeString(testFile.path, 'hello'), isTrue);
      expect(IoUtil.readString(testFile.path), 'hello');
    });

    test('append', () {
      IoUtil.writeString(testFile.path, 'world', append: true);
      expect(IoUtil.readString(testFile.path), 'helloworld');
    });

    test('read missing file returns fallback', () {
      expect(
        IoUtil.readString('${tmp.path}\\no_such_file.txt', fallback: 'x'),
        'x',
      );
    });
  });

  group('IoUtil.readLines', () {
    test('reads each line', () {
      IoUtil.writeString(testFile.path, 'a\nb\nc');
      expect(IoUtil.readLines(testFile.path), ['a', 'b', 'c']);
    });
  });

  group('IoUtil.copy / exists / size / delete', () {
    test('copy to new path', () {
      IoUtil.writeString(testFile.path, 'data');
      final dst = '${tmp.path}\\copied.txt';
      expect(IoUtil.copy(testFile.path, dst), isTrue);
      expect(IoUtil.exists(dst), isTrue);
      expect(IoUtil.readString(dst), 'data');
    });

    test('size', () {
      expect(IoUtil.size(testFile.path), greaterThan(0));
      expect(IoUtil.size('${tmp.path}\\missing.bin'), -1);
    });

    test('delete', () {
      IoUtil.writeString(testFile.path, 'x');
      expect(IoUtil.exists(testFile.path), isTrue);
      expect(IoUtil.delete(testFile.path), isTrue);
      expect(IoUtil.exists(testFile.path), isFalse);
    });
  });
}
