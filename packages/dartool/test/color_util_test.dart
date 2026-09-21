import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('ColorUtil 通道提取', () {
    const color = 0xFFFF5733;
    test('alpha / red / green / blue', () {
      expect(ColorUtil.alpha(color), equals(0xFF));
      expect(ColorUtil.red(color), equals(0xFF));
      expect(ColorUtil.green(color), equals(0x57));
      expect(ColorUtil.blue(color), equals(0x33));
    });

    test('rgb / argb 返回正确列表', () {
      expect(ColorUtil.rgb(color), equals([255, 0x57, 0x33]));
      expect(ColorUtil.argb(color), equals([0xFF, 255, 0x57, 0x33]));
    });
  });

  group('ColorUtil 构造', () {
    test('rgbToInt / argbToInt', () {
      expect(ColorUtil.rgbToInt(255, 87, 51), equals(0xFFFF5733));
      expect(ColorUtil.argbToInt(0x80, 255, 87, 51), equals(0x80FF5733));
    });

    test('withAlpha / withRed 等修改通道', () {
      const c = 0xFFFF5733;
      expect(ColorUtil.withAlpha(c, 0x80), equals(0x80FF5733));
      expect(ColorUtil.withRed(c, 0x00), equals(0xFF005733));
    });
  });

  group('ColorUtil hex 解析', () {
    test('tryParse #RRGGBB', () {
      expect(ColorUtil.tryParse('#FF5733'), equals(0xFFFF5733));
    });

    test('tryParse #AARRGGBB', () {
      expect(ColorUtil.tryParse('#80FF5733'), equals(0x80FF5733));
    });

    test('tryParse #RGB 简写', () {
      expect(ColorUtil.tryParse('#F53'), equals(0xFFFF5533));
    });

    test('tryParse 无 # 前缀', () {
      expect(ColorUtil.tryParse('FF5733'), equals(0xFFFF5733));
    });

    test('tryParse 非法返回 -1', () {
      expect(ColorUtil.tryParse('invalid'), equals(-1));
    });

    test('fromHex 使用 fallback', () {
      expect(
        ColorUtil.fromHex('zzz', fallback: 0xFF000000),
        equals(0xFF000000),
      );
    });
  });

  group('ColorUtil toHex', () {
    test('toHex 返回 #RRGGBB', () {
      expect(ColorUtil.toHex(0xFFFF5733), equals('#FF5733'));
    });

    test('toHexArgb 返回 #AARRGGBB', () {
      expect(ColorUtil.toHexArgb(0x80FF5733), equals('#80FF5733'));
    });

    test('toHex / fromHex 往返', () {
      const c = 0xFF123456;
      expect(ColorUtil.fromHex(ColorUtil.toHex(c)), equals(c));
    });
  });

  group('ColorUtil 亮度 / 反色 / 插值', () {
    test('isDark / isLight', () {
      expect(ColorUtil.isDark(0xFF000000), isTrue);
      expect(ColorUtil.isLight(0xFFFFFFFF), isTrue);
    });

    test('invert', () {
      expect(ColorUtil.invert(0xFFFF0000), equals(0xFF00FFFF));
    });

    test('lerp 两端', () {
      const a = 0xFF000000;
      const b = 0xFFFFFFFF;
      expect(ColorUtil.lerp(a, b, 0), equals(a));
      expect(ColorUtil.lerp(a, b, 1), equals(b));
      expect(ColorUtil.lerp(a, b, 0.5), equals(0xFF7F7F7F));
    });
  });
}
