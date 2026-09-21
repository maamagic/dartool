import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// 平台判断工具类。
///
/// 在 `dart:io` 的 [Platform] 基础上统一封装，并正确处理 Web 环境
/// （Web 下 `dart:io` 不可用，统一走 `kIsWeb` 判断）。
abstract final class PlatformUtil {
  PlatformUtil._();

  /// 是否运行在 Web。
  static bool get isWeb => kIsWeb;

  /// 是否 Android。
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// 是否 iOS。
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// 是否 macOS。
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// 是否 Windows。
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// 是否 Linux。
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// 是否移动端（Android / iOS）。
  static bool get isMobile => isAndroid || isIOS;

  /// 是否桌面端（Windows / macOS / Linux）。
  static bool get isDesktop => isWindows || isMacOS || isLinux;

  /// 当前目标平台（对 Web / 桌面同样安全）。
  static TargetPlatform get targetPlatform => defaultTargetPlatform;
}
