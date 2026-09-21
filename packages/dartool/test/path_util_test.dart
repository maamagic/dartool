import 'dart:io';

import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('PathUtil.join', () {
    test('joins and collapses separators', () {
      expect(PathUtil.join(['foo', 'bar', 'baz']), 'foo/bar/baz');
      expect(PathUtil.join(['/', 'etc', 'a', 'b.txt']), '/etc/a/b.txt');
    });

    test('handles empty parts', () {
      expect(PathUtil.join(['a', '', 'b']), 'a/b');
      expect(PathUtil.join(<String>[]), '');
    });
  });

  group('PathUtil.normalize / split', () {
    test('normalizes separators and resolves ..', () {
      expect(PathUtil.normalize('a/../b'), 'b');
      expect(PathUtil.normalize('a//b/./c'), 'a/b/c');
      expect(PathUtil.normalize('/a/b/../c'), '/a/c');
    });

    test('split returns segments', () {
      expect(PathUtil.split('a/b/c'), ['a', 'b', 'c']);
      expect(PathUtil.split('/etc/hosts'), ['/', 'etc', 'hosts']);
    });
  });

  group('PathUtil extension / baseName / dirName', () {
    test('extension extracts after last dot in segment', () {
      expect(PathUtil.extension('foo/bar.png'), 'png');
      expect(PathUtil.extension('foo.tar.gz'), 'gz');
      expect(PathUtil.extension('noext'), '');
      expect(PathUtil.extension('foo/bar.'), '');
    });

    test('baseName returns last segment', () {
      expect(PathUtil.baseName('a/b/c.txt'), 'c.txt');
      expect(PathUtil.baseName('a/b/c.txt', '.txt'), 'c');
      expect(PathUtil.baseName(''), '');
    });

    test('dirName returns parent path', () {
      expect(PathUtil.dirName('a/b/c.txt'), 'a/b');
      expect(PathUtil.dirName('single'), '');
      expect(PathUtil.dirName('/foo/bar'), '/foo');
    });
  });

  test('separator matches platform', () {
    expect(PathUtil.separator, Platform.isWindows ? r'\' : '/');
  });
}
