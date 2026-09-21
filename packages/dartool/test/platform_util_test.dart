import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group(
    'PlatformUtil (native VM)',
    () {
      test('isWeb is false', () {
        expect(PlatformUtil.isWeb, isFalse);
        expect(PlatformUtil.isNative, isTrue);
      });

      test('operatingSystem is a known native value', () {
        expect(
          PlatformUtil.operatingSystem,
          anyOf('windows', 'macos', 'linux', 'ios', 'android', 'fuchsia'),
        );
      });

      test('one and only one of isWindows/isMacOS/isLinux is true', () {
        final flags = [
          PlatformUtil.isWindows,
          PlatformUtil.isMacOS,
          PlatformUtil.isLinux,
        ];
        expect(flags.where((v) => v).length, 1);
      });

      test('pathSeparator matches dart:io', () {
        expect(PlatformUtil.pathSeparator, PlatformUtil.isWindows ? '\\' : '/');
      });

      test('numberOfProcessors is positive', () {
        expect(PlatformUtil.numberOfProcessors, greaterThan(0));
      });

      test('operatingSystemVersion is non-empty on native', () {
        expect(PlatformUtil.operatingSystemVersion, isNotEmpty);
      });

      test('isMobile / isDesktop classification', () {
        expect(
          PlatformUtil.isMobile ||
              PlatformUtil.isDesktop ||
              PlatformUtil.isFuchsia,
          isTrue,
        );
      });
    },
    skip: PlatformUtil.isWeb ? 'native VM behavior only' : false,
  );

  group('PlatformUtil (web)', () {
    test('isWeb is true and native flags are false', () {
      expect(PlatformUtil.isWeb, isTrue);
      expect(PlatformUtil.isNative, isFalse);
    });
  }, skip: PlatformUtil.isWeb ? false : 'web behavior only');

  group('PlatformUtil environment helper', () {
    test('missing variable returns fallback', () {
      expect(
        PlatformUtil.environment('___THIS_KEY_DOES_NOT_EXIST_12345___'),
        '',
      );
      expect(
        PlatformUtil.environment(
          '___THIS_KEY_DOES_NOT_EXIST_12345___',
          fallback: 'x',
        ),
        'x',
      );
    });
  });
}
