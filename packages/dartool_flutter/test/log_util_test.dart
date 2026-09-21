import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    LogUtil.minLevel = LogLevel.debug;
    LogUtil.output = (_) {};
  });

  test('logLevel', () {
    final lines = <String>[];
    LogUtil.output = lines.add;
    LogUtil.minLevel = LogLevel.warn;

    LogUtil.debug('d');
    LogUtil.info('i');
    LogUtil.warn('w');
    LogUtil.error('e');

    expect(lines, ['[WARN] w', '[ERROR] e']);
  });

  test('tag', () {
    final lines = <String>[];
    LogUtil.output = lines.add;

    LogUtil.info('msg', tag: 'mytag');

    expect(lines.single, '[INFO] [mytag] msg');
  });

  test('default tag', () {
    final lines = <String>[];
    LogUtil.output = lines.add;

    LogUtil.error('boom');

    expect(lines.single, '[ERROR] boom');
  });
}
