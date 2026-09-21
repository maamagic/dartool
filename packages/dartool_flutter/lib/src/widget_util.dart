import 'package:flutter/material.dart';

/// Common Flutter widget shorthands and helpers.
///
/// Example:
/// ```dart
/// WidgetUtil.box(h: 16);                 // const SizedBox(height: 16)
/// WidgetUtil.pad(child: Text('hi'));     // Padding(padding: EdgeInsets.all(8), ...)
/// WidgetUtil.expanded(Text('hi'));       // Expanded(child: ...)
/// WidgetUtil.safeArea(Scaffold(...));
/// ```
abstract final class WidgetUtil {
  WidgetUtil._();

  // ---------------------------------------------------------------------------
  // SizedBox shorthands
  // ---------------------------------------------------------------------------

  /// `SizedBox.shrink()` — zero-size placeholder.
  static const Widget none = SizedBox.shrink();

  /// Horizontal gap, default 8.
  static Widget hGap([double size = 8]) => SizedBox(width: size);

  /// Vertical gap, default 8.
  static Widget vGap([double size = 8]) => SizedBox(height: size);

  /// SizedBox with the given [w] and/or [h].
  static Widget box({double? w, double? h}) => SizedBox(width: w, height: h);

  // ---------------------------------------------------------------------------
  // Padding shorthands
  // ---------------------------------------------------------------------------

  /// Padding on all sides, default 8.
  static Widget pad({required Widget child, double all = 8}) =>
      Padding(padding: EdgeInsets.all(all), child: child);

  /// Horizontal padding only.
  static Widget padH({required Widget child, double h = 8}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: h),
    child: child,
  );

  /// Vertical padding only.
  static Widget padV({required Widget child, double v = 8}) => Padding(
    padding: EdgeInsets.symmetric(vertical: v),
    child: child,
  );

  /// Padding with per-direction values.
  static Widget padOnly({
    required Widget child,
    double l = 0,
    double t = 0,
    double r = 0,
    double b = 0,
  }) => Padding(padding: EdgeInsets.fromLTRB(l, t, r, b), child: child);

  // ---------------------------------------------------------------------------
  // Layout wrappers
  // ---------------------------------------------------------------------------

  /// `Expanded` shorthand.
  static Widget expanded(Widget child, {int flex = 1}) =>
      Expanded(flex: flex, child: child);

  /// `Flexible` shorthand.
  static Widget flexible(
    Widget child, {
    int flex = 1,
    FlexFit fit = FlexFit.loose,
  }) => Flexible(flex: flex, fit: fit, child: child);

  /// `SafeArea` shorthand.
  static Widget safeArea(
    Widget child, {
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) => SafeArea(
    top: top,
    bottom: bottom,
    left: left,
    right: right,
    child: child,
  );

  /// `Center` shorthand.
  static Widget center(Widget child) => Center(child: child);

  /// `ClipRRect` shorthand.
  static Widget rounded(Widget child, {double radius = 8}) =>
      ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);

  // ---------------------------------------------------------------------------
  // Alignment / Stack helpers
  // ---------------------------------------------------------------------------

  /// Pin [child] to the top-left corner of a Stack.
  static Widget topLeft(Widget child, {double? top, double? left}) =>
      Positioned(top: top, left: left, child: child);

  /// Pin [child] to the top-right corner of a Stack.
  static Widget topRight(Widget child, {double? top, double? right}) =>
      Positioned(top: top, right: right, child: child);

  /// Pin [child] to the bottom of a Stack (full width).
  static Widget bottom(Widget child, {double? bottom}) =>
      Positioned(bottom: bottom, left: 0, right: 0, child: child);

  // ---------------------------------------------------------------------------
  // Visibility / conditional
  // ---------------------------------------------------------------------------

  /// Conditional rendering: [child] when [condition] is true, [fallback]
  /// (defaults to [none]) otherwise.
  static Widget when(bool condition, Widget child, {Widget fallback = none}) =>
      condition ? child : fallback;
}
