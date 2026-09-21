import 'package:flutter/material.dart';

import '../media_query_util.dart';
import '../theme_util.dart';

/// Extension APIs on [BuildContext] mirroring [MediaQueryUtil] and
/// [ThemeUtil] so you can write `context.width` instead of
/// `MediaQueryUtil.width(context)`.
extension DartoolBuildContext on BuildContext {
  Size get size => MediaQueryUtil.size(this);
  double get width => MediaQueryUtil.width(this);
  double get height => MediaQueryUtil.height(this);
  EdgeInsets get padding => MediaQueryUtil.padding(this);
  EdgeInsets get viewPadding => MediaQueryUtil.viewPadding(this);
  EdgeInsets get viewInsets => MediaQueryUtil.viewInsets(this);
  double get devicePixelRatio => MediaQueryUtil.devicePixelRatio(this);
  bool get isLandscape => MediaQueryUtil.isLandscape(this);
  bool get isPortrait => MediaQueryUtil.isPortrait(this);
  Brightness get platformBrightness => MediaQueryUtil.platformBrightness(this);
  bool get isDarkMode => MediaQueryUtil.isDark(this);
  double get statusBarHeight => MediaQueryUtil.statusBarHeight(this);
  double get bottomBarHeight => MediaQueryUtil.bottomBarHeight(this);
  double get keyboardHeight => MediaQueryUtil.keyboardHeight(this);
  double get shortestSide => MediaQueryUtil.shortestSide(this);

  ThemeData get theme => ThemeUtil.of(this);
  ThemeData get t => ThemeUtil.of(this);
  ColorScheme get colorScheme => ThemeUtil.colorSchemeOf(this);
  Color get primary => ThemeUtil.primary(this);
  Color get secondary => ThemeUtil.secondary(this);
  Color get surface => ThemeUtil.surface(this);
  Color get scaffoldBackground => ThemeUtil.scaffoldBackground(this);
  bool get isDarkTheme => ThemeUtil.isDark(this);
  TextTheme get textTheme => ThemeUtil.textThemeOf(this);
  IconThemeData get iconTheme => ThemeUtil.iconThemeOf(this);

  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);
  ScaffoldState get scaffold => Scaffold.of(this);
  NavigatorState get navigator => Navigator.of(this);

  void pop<T extends Object?>([T? result]) {
    if (Navigator.canPop(this)) Navigator.pop(this, result);
  }

  Future<T?> push<T extends Object?>(Widget page) =>
      Navigator.push<T>(this, MaterialPageRoute(builder: (_) => page));

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
  }) => Navigator.pushReplacement<T, TO>(
    this,
    MaterialPageRoute(builder: (_) => page),
    result: result,
  );

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) => Navigator.pushNamed<T>(this, routeName, arguments: arguments);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    return messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
