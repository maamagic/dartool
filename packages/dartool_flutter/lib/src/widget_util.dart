import 'package:flutter/material.dart';

/// Common Flutter widget shorthands and helpers.
///
/// Example:
/// ```dart
/// WidgetUtil.sizedBox(h: 16);           // const SizedBox(height: 16)
/// WidgetUtil.pad(child: Text('hi'));    // Padding(padding: EdgeInsets.all(8), ...)
/// WidgetUtil.expanded(Text('hi'));      // Expanded(child: ...)
/// WidgetUtil.safeArea(Scaffold(...));
/// ```
abstract final class WidgetUtil {
  WidgetUtil._();

  // ---------------------------------------------------------------------------
  // SizedBox shorthands
  // ---------------------------------------------------------------------------

  /// `SizedBox.shrink()` — 零尺寸占位。
  static const Widget none = SizedBox.shrink();

  /// 水平间距，默认 8。
  static Widget hGap([double size = 8]) => SizedBox(width: size);

  /// 垂直间距，默认 8。
  static Widget vGap([double size = 8]) => SizedBox(height: size);

  /// 指定宽高的 SizedBox。
  static Widget box({double? w, double? h}) => SizedBox(width: w, height: h);

  // ---------------------------------------------------------------------------
  // Padding shorthands
  // ---------------------------------------------------------------------------

  /// 四边相等的 Padding，默认 8。
  static Widget pad({required Widget child, double all = 8}) =>
      Padding(padding: EdgeInsets.all(all), child: child);

  /// 仅水平 Padding。
  static Widget padH({required Widget child, double h = 8}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: h),
    child: child,
  );

  /// 仅垂直 Padding。
  static Widget padV({required Widget child, double v = 8}) => Padding(
    padding: EdgeInsets.symmetric(vertical: v),
    child: child,
  );

  /// 单独控制方向的 Padding。
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

  /// `Expanded` 简写。
  static Widget expanded(Widget child, {int flex = 1}) =>
      Expanded(flex: flex, child: child);

  /// `Flexible` 简写。
  static Widget flexible(
    Widget child, {
    int flex = 1,
    FlexFit fit = FlexFit.loose,
  }) => Flexible(flex: flex, fit: fit, child: child);

  /// `SafeArea` 简写。
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

  /// `Center` 简写。
  static Widget center(Widget child) => Center(child: child);

  /// `ClipRRect` 圆角简写。
  static Widget rounded(Widget child, {double radius = 8}) =>
      ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);

  // ---------------------------------------------------------------------------
  // Alignment / Stack helpers
  // ---------------------------------------------------------------------------

  /// 定位到 Stack 左上角。
  static Widget topLeft(Widget child, {double? top, double? left}) =>
      Positioned(top: top, left: left, child: child);

  /// 定位到 Stack 右上角。
  static Widget topRight(Widget child, {double? top, double? right}) =>
      Positioned(top: top, right: right, child: child);

  /// 定位到 Stack 底部。
  static Widget bottom(Widget child, {double? bottom}) =>
      Positioned(bottom: bottom, left: 0, right: 0, child: child);

  // ---------------------------------------------------------------------------
  // Visibility / conditional
  // ---------------------------------------------------------------------------

  /// 条件渲染：`condition` 为 true 时显示 [child]，否则显示 [fallback]（默认 [none]）。
  static Widget when(bool condition, Widget child, {Widget fallback = none}) =>
      condition ? child : fallback;
}
