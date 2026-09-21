import 'package:flutter/material.dart';

/// Convenience helpers for common MediaQuery lookups.
///
/// All methods require a [BuildContext]. Values are read from
/// `MediaQuery.of(context)` and are automatically updated by Flutter's
/// reactive system when the view changes.
///
/// ```dart
/// final padding = MediaQueryUtil.padding(context);
/// final textScale = MediaQueryUtil.textScaleFactor(context);
/// final isLandscape = MediaQueryUtil.isLandscape(context);
/// ```
class MediaQueryUtil {
  MediaQueryUtil._();

  static Size size(BuildContext context) => MediaQuery.sizeOf(context);
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;
  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static EdgeInsets padding(BuildContext context) =>
      MediaQuery.paddingOf(context);
  static EdgeInsets viewPadding(BuildContext context) =>
      MediaQuery.viewPaddingOf(context);
  static EdgeInsets viewInsets(BuildContext context) =>
      MediaQuery.viewInsetsOf(context);
  static EdgeInsets systemGestureInsets(BuildContext context) =>
      MediaQuery.systemGestureInsetsOf(context);

  static double devicePixelRatio(BuildContext context) =>
      MediaQuery.devicePixelRatioOf(context);

  static TextScaler textScaler(BuildContext context) =>
      MediaQuery.textScalerOf(context);

  static Orientation orientation(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return s.width > s.height ? Orientation.landscape : Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) =>
      orientation(context) == Orientation.landscape;
  static bool isPortrait(BuildContext context) =>
      orientation(context) == Orientation.portrait;

  static Brightness platformBrightness(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context);

  static bool isDark(BuildContext context) =>
      platformBrightness(context) == Brightness.dark;

  static double statusBarHeight(BuildContext context) =>
      MediaQuery.paddingOf(context).top;
  static double bottomBarHeight(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom;
  static double keyboardHeight(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom;

  static double shortestSide(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return s.shortestSide;
  }
}
