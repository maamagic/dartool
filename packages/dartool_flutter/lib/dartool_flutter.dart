/// dartool_flutter —— dartool 的 Flutter 专属扩展。
///
/// 提供平台判断、日志等依赖 Flutter 的能力，配合纯 Dart 的 `dartool`
/// 一起使用：
/// ```dart
/// import 'package:dartool/dartool.dart';
/// import 'package:dartool_flutter/dartool_flutter.dart';
///
/// if (PlatformUtil.isAndroid) {
///   LogUtil.info('running on Android');
/// }
/// ```
library;

export 'src/log_util.dart';
export 'src/platform_util.dart';
export 'src/widget_util.dart';
