import 'package:flutter/material.dart';

/// Common theme shortcuts so you don't reach for `Theme.of(context)` every
/// time.
///
/// ```dart
/// final primaryColor = ThemeUtil.primary(context);
/// final bodyStyle = ThemeUtil.bodyText(context);
/// final isDark = ThemeUtil.isDark(context);
/// ```
class ThemeUtil {
  ThemeUtil._();

  static ThemeData of(BuildContext context) => Theme.of(context);

  static ColorScheme colorSchemeOf(BuildContext context) =>
      Theme.of(context).colorScheme;

  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;

  static Color secondary(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color background(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color scaffoldBackground(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color hint(BuildContext context) => Theme.of(context).hintColor;

  static Color divider(BuildContext context) => Theme.of(context).dividerColor;

  static Brightness brightness(BuildContext context) =>
      Theme.of(context).brightness;

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static TextTheme textThemeOf(BuildContext context) =>
      Theme.of(context).textTheme;

  static TextStyle? displayLarge(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge;

  static TextStyle? headlineMedium(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium;

  static TextStyle? titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge;

  static TextStyle? bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge;

  static TextStyle? bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium;

  static TextStyle? labelLarge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;

  static IconThemeData iconThemeOf(BuildContext context) =>
      Theme.of(context).iconTheme;

  static double iconSize(BuildContext context) =>
      Theme.of(context).iconTheme.size ?? 24.0;
}
