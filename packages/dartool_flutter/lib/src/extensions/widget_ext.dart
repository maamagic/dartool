import 'package:flutter/material.dart';

/// Convenience extensions on [Widget] to wrap common layout / gesture
/// patterns with a single cascade.
///
/// ```dart
/// Text('Hello')
///   .padAll(8)
///   .rounded(12)
///   .onTap(() => print('tap'));
/// ```
extension WidgetX on Widget {
  Widget padAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget padH(double value) => Padding(
    padding: EdgeInsets.symmetric(horizontal: value),
    child: this,
  );

  Widget padV(double value) => Padding(
    padding: EdgeInsets.symmetric(vertical: value),
    child: this,
  );

  Widget padOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );

  Widget centerWidget() => Center(child: this);

  Widget expand({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget flex({int flex = 1}) => Flexible(flex: flex, child: this);

  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) =>
      SafeArea(top: top, bottom: bottom, left: left, right: right, child: this);

  Widget rounded(double radius, {Color? color, BoxBorder? border}) => Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: border,
    ),
    child: ClipRRect(borderRadius: BorderRadius.circular(radius), child: this),
  );

  Widget shadow({
    double elevation = 2,
    Color color = Colors.black26,
    Offset offset = const Offset(0, 1),
    double blurRadius = 4,
  }) => Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(color: color, offset: offset, blurRadius: blurRadius),
      ],
    ),
    child: this,
  );

  Widget sized({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);

  Widget visible(bool condition, {Widget fallback = const SizedBox.shrink()}) =>
      condition ? this : fallback;

  Widget onTap(VoidCallback? onTap, {bool enabled = true}) =>
      GestureDetector(onTap: enabled ? onTap : null, child: this);

  Widget onDoubleTap(VoidCallback? onDoubleTap) =>
      GestureDetector(onDoubleTap: onDoubleTap, child: this);

  Widget onLongPress(VoidCallback? onLongPress) =>
      GestureDetector(onLongPress: onLongPress, child: this);

  Widget splashable({VoidCallback? onTap}) =>
      InkWell(onTap: onTap, child: this);

  Widget opacity(double value) => Opacity(opacity: value, child: this);

  Widget rotate(double angle) => Transform.rotate(angle: angle, child: this);

  Widget scale(double factor) => Transform.scale(scale: factor, child: this);
}

extension StringWidgetX on String {
  Widget text({
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) => Text(
    this,
    style: style,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );
}
