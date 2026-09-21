import 'package:dartool/dartool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('targetPlatform 可安全读取', () {
    expect(PlatformUtil.targetPlatform, isNotNull);
  });

  test('isMobile 与 isDesktop 互斥', () {
    expect(PlatformUtil.isMobile, isNot(PlatformUtil.isDesktop));
  });

  test('isWeb 与 isDesktop 可同时为 false（原生环境）', () {
    // 测试运行在原生 VM 上，Web 一定为 false
    expect(PlatformUtil.isWeb, isFalse);
  });
}
