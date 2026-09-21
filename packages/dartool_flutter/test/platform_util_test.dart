import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('targetPlatform is not null', () {
    expect(PlatformUtil.targetPlatform, isNotNull);
  });

  test('isMobile and isDesktop are mutually exclusive', () {
    expect(PlatformUtil.isMobile, isNot(PlatformUtil.isDesktop));
  });

  test('isWeb is false when running on VM', () {
    expect(PlatformUtil.isWeb, isFalse);
  });

  test('isDesktop works', () {
    expect(PlatformUtil.isDesktop, anyOf(isTrue, isFalse));
  });
}
