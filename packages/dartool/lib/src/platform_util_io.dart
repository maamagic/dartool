import 'dart:io' show Platform;

bool get isWeb => false;
bool get isIOS => Platform.isIOS;
bool get isAndroid => Platform.isAndroid;
bool get isFuchsia => Platform.isFuchsia;
bool get isLinux => Platform.isLinux;
bool get isMacOS => Platform.isMacOS;
bool get isWindows => Platform.isWindows;
String get operatingSystem => Platform.operatingSystem;
String get operatingSystemVersion => Platform.operatingSystemVersion;
int get numberOfProcessors => Platform.numberOfProcessors;
String get pathSeparator => Platform.pathSeparator;
String get lineSeparator => Platform.lineTerminator;
String get localHostname => Platform.localHostname;
String environment(String name, {String fallback = ''}) =>
    Platform.environment[name] ?? fallback;
