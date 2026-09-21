/// dartool_flutter 鈥?Flutter-specific extensions built on top of dartool.
///
/// Provides platform detection, logging and widget shorthands. Combine with
/// the pure-Dart `dartool` package:
/// ```dart
/// import 'package:dartool/dartool.dart';
/// import 'package:dartool_flutter/dartool_flutter.dart';
///
/// if (PlatformUtil.isAndroid) {
///   LogUtil.info('running on Android');
/// }
/// ```
library;

export 'src/media_query_util.dart';
export 'src/theme_util.dart';

export 'src/dialog_util.dart';
export 'src/log_util.dart';
export 'src/platform_util.dart';
export 'src/widget_util.dart';
export 'src/extensions/widget_ext.dart';
export 'src/extensions/context_ext.dart';
