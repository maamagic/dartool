import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Platform detection helpers.
///
/// Wraps `dart:io`'s [Platform] with correct handling for Web (where
/// `dart:io` is unavailable) via [kIsWeb].
abstract final class PlatformUtil {
  PlatformUtil._();

  /// Whether running on the Web.
  static bool get isWeb => kIsWeb;

  /// Whether running on Android.
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Whether running on iOS.
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Whether running on macOS.
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Whether running on Windows.
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Whether running on Linux.
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Whether running on a mobile platform (Android / iOS).
  static bool get isMobile => isAndroid || isIOS;

  /// Whether running on a desktop platform (Windows / macOS / Linux).
  static bool get isDesktop => isWindows || isMacOS || isLinux;

  /// Current target platform (safe for Web and desktop alike).
  static TargetPlatform get targetPlatform => defaultTargetPlatform;
}
