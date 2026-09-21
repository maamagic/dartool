import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    LogUtil.minLevel = LogLevel.debug;
    LogUtil.output = (_) {};
  });

  test('低于 minLevel 的日志被过滤', () {
    final lines = <String>[];
    LogUtil.output = lines.add;
    LogUtil.minLevel = LogLevel.warn;

    LogUtil.debug('d');
    LogUtil.info('i');
    LogUtil.warn('w');
    LogUtil.error('e');

    expect(lines, ['[WARN] w', '[ERROR] e']);
  });

  test('输出包含标签', () {
    final lines = <String>[];
    LogUtil.output = lines.add;

    LogUtil.info('msg', tag: 'mytag');

    expect(lines.single, '[INFO] [mytag] msg');
  });

  test('默认不输出无标签时的多余空格', () {
    final lines = <String>[];
    LogUtil.output = lines.add;

    LogUtil.error('boom');

    expect(lines.single, '[ERROR] boom');
  });
}
