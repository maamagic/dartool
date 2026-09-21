import 'dart:math';

/// Color conversion utilities: hex <-> RGB <-> ARGB, palette helpers.
///
/// Uses plain Dart `int` to represent colors (0xAARRGGBB), so it works in
/// pure Dart projects without Flutter dependency.
///
/// Example:
/// ```dart
/// ColorUtil.hexToInt('#FF5733');                // 0xFFFF5733
/// ColorUtil.intToRgb(0xFFFF5733);              // [255, 87, 51]
/// ColorUtil.rgbToInt(255, 87, 51);             // 0xFFFF5733
/// ColorUtil.intToHex(0xFFFF5733);              // #FF5733
/// ColorUtil.isDark(0xFF000000);                // true
/// ```
abstract final class ColorUtil {
  ColorUtil._();

  // ---------------------------------------------------------------------------
  // int <-> parts
  // ---------------------------------------------------------------------------

  static const int _maskA = 0xFF000000;
  static const int _maskR = 0x00FF0000;
  static const int _maskG = 0x0000FF00;
  static const int _maskB = 0x000000FF;

  /// Alpha channel [0, 255].
  static int alpha(int color) => (color & _maskA) >> 24;

  /// Red channel [0, 255].
  static int red(int color) => (color & _maskR) >> 16;

  /// Green channel [0, 255].
  static int green(int color) => (color & _maskG) >> 8;

  /// Blue channel [0, 255].
  static int blue(int color) => color & _maskB;

  /// Returns `[a, r, g, b]`  each in [0, 255].
  static List<int> argb(int color) => [
    alpha(color),
    red(color),
    green(color),
    blue(color),
  ];

  /// Returns `[r, g, b]` (no alpha).
  static List<int> rgb(int color) => [red(color), green(color), blue(color)];

  // ---------------------------------------------------------------------------
  // Constructors
  // ---------------------------------------------------------------------------

  /// Build ARGB int from channels (all [0, 255]).
  static int argbToInt(int a, int r, int g, int b) =>
      (((a & 0xFF) << 24) |
          ((r & 0xFF) << 16) |
          ((g & 0xFF) << 8) |
          (b & 0xFF)) &
      0xFFFFFFFF;

  /// Build RGB int with full opacity alpha.
  static int rgbToInt(int r, int g, int b) => argbToInt(0xFF, r, g, b);

  /// Returns a copy of [color] with alpha overridden.
  static int withAlpha(int color, int a) =>
      argbToInt(a, red(color), green(color), blue(color));

  /// Returns a copy of [color] with red overridden.
  static int withRed(int color, int r) =>
      argbToInt(alpha(color), r, green(color), blue(color));

  /// Returns a copy of [color] with green overridden.
  static int withGreen(int color, int g) =>
      argbToInt(alpha(color), red(color), g, blue(color));

  /// Returns a copy of [color] with blue overridden.
  static int withBlue(int color, int b) =>
      argbToInt(alpha(color), red(color), green(color), b);

  // ---------------------------------------------------------------------------
  // int <-> hex string
  // ---------------------------------------------------------------------------

  /// Parse a hex color string to int. Accepts `#RGB`, `#RRGGBB`, `#AARRGGBB`
  /// and plain `RRGGBB` / `AARRGGBB` without leading `#`.
  /// Returns -1 if invalid.
  static int tryParse(String hex) {
    final h = hex.startsWith('#') ? hex.substring(1) : hex;
    if (h.length == 3) {
      final buf = StringBuffer('FF');
      for (var i = 0; i < 3; i++) {
        buf.write(h[i] * 2);
      }
      final intValue = int.tryParse(buf.toString(), radix: 16);
      return intValue ?? -1;
    }
    if (h.length == 6) {
      final intValue = int.tryParse('FF$h', radix: 16);
      return intValue ?? -1;
    }
    if (h.length == 8) {
      final intValue = int.tryParse(h, radix: 16);
      return intValue ?? -1;
    }
    return -1;
  }

  /// Same as [tryParse] but returns [fallback] instead of -1 on failure.
  static int fromHex(String hex, {int fallback = 0xFF000000}) {
    final v = tryParse(hex);
    return v == -1 ? fallback : v;
  }

  /// Convert color int to `#RRGGBB` format (alpha stripped).
  static String toHex(int color) =>
      '#${red(color).toRadixString(16).padLeft(2, '0')}'
              '${green(color).toRadixString(16).padLeft(2, '0')}'
              '${blue(color).toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();

  /// Convert color int to `#AARRGGBB` format.
  static String toHexArgb(int color) =>
      '#${alpha(color).toRadixString(16).padLeft(2, '0')}'
              '${red(color).toRadixString(16).padLeft(2, '0')}'
              '${green(color).toRadixString(16).padLeft(2, '0')}'
              '${blue(color).toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();

  // ---------------------------------------------------------------------------
  // Utilities
  // ---------------------------------------------------------------------------

  /// Relative luminance (per WCAG formula). Range [0, 1].
  static double luminance(int color) {
    double f(int c) {
      final v = c / 255;
      return v <= 0.03928
          ? v / 12.92
          : pow((v + 0.055) / 1.055, 2.4).toDouble();
    }

    return 0.2126 * f(red(color)) +
        0.7152 * f(green(color)) +
        0.0722 * f(blue(color));
  }

  /// Whether the color is "dark" (luminance < 0.5).
  static bool isDark(int color) => luminance(color) < 0.5;

  /// Whether the color is "light" (luminance >= 0.5).
  static bool isLight(int color) => !isDark(color);

  /// Invert the RGB channels (alpha preserved).
  static int invert(int color) => argbToInt(
    alpha(color),
    255 - red(color),
    255 - green(color),
    255 - blue(color),
  );

  /// Linearly interpolate between [a] and [b] by factor [t] (0..1).
  static int lerp(int a, int b, double t) {
    final t0 = t.clamp(0.0, 1.0);
    final aa = alpha(a) + (alpha(b) - alpha(a)) * t0;
    final ra = red(a) + (red(b) - red(a)) * t0;
    final ga = green(a) + (green(b) - green(a)) * t0;
    final ba = blue(a) + (blue(b) - blue(a)) * t0;
    return argbToInt(
      aa.truncate(),
      ra.truncate(),
      ga.truncate(),
      ba.truncate(),
    );
  }
}
