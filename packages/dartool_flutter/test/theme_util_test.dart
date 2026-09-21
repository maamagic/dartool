import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const primary = Color(0xFF112233);
  const secondary = Color(0xFF445566);
  const surface = Color(0xFF778899);

  testWidgets('reads colors and brightness from Theme', (tester) async {
    late ThemeResult r;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: primary,
            onPrimary: Colors.white,
            secondary: secondary,
            surface: surface,
          ),
          scaffoldBackgroundColor: const Color(0xFFAAAAAA),
          dividerColor: const Color(0xFFBBBBBB),
          iconTheme: const IconThemeData(size: 32),
        ),
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              r = ThemeResult(
                primary: ThemeUtil.primary(context),
                onPrimary: ThemeUtil.onPrimary(context),
                secondary: ThemeUtil.secondary(context),
                surface: ThemeUtil.surface(context),
                background: ThemeUtil.background(context),
                scaffoldBg: ThemeUtil.scaffoldBackground(context),
                divider: ThemeUtil.divider(context),
                dark: ThemeUtil.isDark(context),
                brightness: ThemeUtil.brightness(context),
                iconSize: ThemeUtil.iconSize(context),
                titleLarge: ThemeUtil.titleLarge(context),
                bodyLarge: ThemeUtil.bodyLarge(context),
                scheme: ThemeUtil.colorSchemeOf(context),
                theme: ThemeUtil.of(context),
                textTheme: ThemeUtil.textThemeOf(context),
              );
            });
            return const SizedBox();
          },
        ),
      ),
    );

    expect(r.primary, primary);
    expect(r.onPrimary, Colors.white);
    expect(r.secondary, secondary);
    expect(r.surface, surface);
    expect(r.background, surface);
    expect(r.scaffoldBg, const Color(0xFFAAAAAA));
    expect(r.divider, const Color(0xFFBBBBBB));
    expect(r.dark, isTrue);
    expect(r.brightness, Brightness.dark);
    expect(r.iconSize, 32);
    expect(r.titleLarge, isNotNull);
    expect(r.bodyLarge, isNotNull);
    expect(r.scheme.primary, primary);
    expect(r.theme.brightness, Brightness.dark);
    expect(r.textTheme, isNotNull);
  });

  testWidgets('light theme and missing icon size falls back to 24', (
    tester,
  ) async {
    late bool dark;
    late double iconSize;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              dark = ThemeUtil.isDark(context);
              iconSize = ThemeUtil.iconSize(context);
            });
            return const SizedBox();
          },
        ),
      ),
    );
    expect(dark, isFalse);
    expect(iconSize, 24);
  });
}

class ThemeResult {
  ThemeResult({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.surface,
    required this.background,
    required this.scaffoldBg,
    required this.divider,
    required this.dark,
    required this.brightness,
    required this.iconSize,
    required this.titleLarge,
    required this.bodyLarge,
    required this.scheme,
    required this.theme,
    required this.textTheme,
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color surface;
  final Color background;
  final Color scaffoldBg;
  final Color divider;
  final bool dark;
  final Brightness brightness;
  final double iconSize;
  final TextStyle? titleLarge;
  final TextStyle? bodyLarge;
  final ColorScheme scheme;
  final ThemeData theme;
  final TextTheme textTheme;
}
