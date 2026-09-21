/// Platform detection — zero Flutter / package dependency.
///
/// Uses Dart 3's `dart.library.js_interop` conditional imports so the same
/// API compiles on every runtime (native VM, Flutter desktop, web, WASM).
import 'platform_util_io.dart'
    if (dart.library.js_interop) 'platform_util_web.dart'
    as impl;

abstract final class PlatformUtil {
  PlatformUtil._();

  static bool get isWeb => impl.isWeb;
  static bool get isIOS => impl.isIOS;
  static bool get isAndroid => impl.isAndroid;
  static bool get isFuchsia => impl.isFuchsia;
  static bool get isLinux => impl.isLinux;
  static bool get isMacOS => impl.isMacOS;
  static bool get isWindows => impl.isWindows;
  static bool get isMobile => isIOS || isAndroid;
  static bool get isDesktop => isWindows || isMacOS || isLinux;
  static bool get isNative => !isWeb;
  static String get operatingSystem => impl.operatingSystem;
  static String get operatingSystemVersion => impl.operatingSystemVersion;
  static int get numberOfProcessors => impl.numberOfProcessors;
  static String get pathSeparator => impl.pathSeparator;
  static String get lineSeparator => impl.lineSeparator;
  static String get localHostname => impl.localHostname;
  static String environment(String name, {String fallback = ''}) =>
      impl.environment(name, fallback: fallback);
}
