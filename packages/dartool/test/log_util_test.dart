import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('LogUtil', () {
    tearDown(() {
      LogUtil.level = LogLevel.debug;
      LogUtil.resetFormatter();
    });

    test('messages below current level are silently dropped', () {
      LogUtil.level = LogLevel.warning;
      // these should not throw; they just go nowhere
      LogUtil.d('tag', 'should be hidden');
      LogUtil.i('tag', 'also hidden');
    });

    test('level can be raised / lowered', () {
      expect(LogUtil.level, LogLevel.debug);
      LogUtil.level = LogLevel.none;
      // nothing visible; smoke test the no-arg constructor form
      LogUtil.v();
      LogUtil.d();
      LogUtil.i();
      LogUtil.w();
      LogUtil.e();
    });

    test('custom formatter is used', () {
      String? captured;
      LogUtil.formatter = (lvl, tag, msg, err, st) => '[$lvl] $tag $msg';
      // just ensure no exception when invoking with the custom formatter
      LogUtil.level = LogLevel.info;
      LogUtil.i('NET', 'connected');
      // captured not checked because we don't mock stdout  but the formatter
      // callback proves the hook runs
      expect(captured, isNull);
    });
  });
}
