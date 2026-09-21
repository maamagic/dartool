import 'package:flutter/foundation.dart';

import 'package:dartool_flutter/dartool_flutter.dart';

void main() {
  PlatformUtil.isWeb;
  PlatformUtil.isAndroid;
  PlatformUtil.isIOS;
  PlatformUtil.isMacOS;
  PlatformUtil.isWindows;
  PlatformUtil.isLinux;
  PlatformUtil.isMobile;
  PlatformUtil.isDesktop;
  PlatformUtil.targetPlatform;

  LogUtil.debug('debug message', tag: 'Example');
  LogUtil.info('info message');
  LogUtil.warn('warn message', tag: 'Example');
  LogUtil.error('error message');

  LogUtil.minLevel = LogLevel.info;
  LogUtil.output = (line) {
    if (kDebugMode) debugPrint('[custom] $line');
  };
}
