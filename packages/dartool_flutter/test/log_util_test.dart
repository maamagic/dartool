import 'package:dartool/dartool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    LogUtil.minLevel = LogLevel.debug;
    LogUtil.output = (_) {};
  });

  test('浣庝簬 minLevel 鐨勬棩蹇楄杩囨护', () {
    final lines = <String>[];
    LogUtil.output = lines.add;
    LogUtil.minLevel = LogLevel.warn;

    LogUtil.debug('d');
    LogUtil.info('i');
    LogUtil.warn('w');
    LogUtil.error('e');

    expect(lines, ['[WARN] w', '[ERROR] e']);
  });

  test('杈撳嚭鍖呭惈鏍囩', () {
    final lines = <String>[];
    LogUtil.output = lines.add;

    LogUtil.info('msg', tag: 'mytag');

    expect(lines.single, '[INFO] [mytag] msg');
  });

  test('榛樿涓嶈緭鍑烘棤鏍囩鏃剁殑澶氫綑绌烘牸', () {
    final lines = <String>[];
    LogUtil.output = lines.add;

    LogUtil.error('boom');

    expect(lines.single, '[ERROR] boom');
  });
}
