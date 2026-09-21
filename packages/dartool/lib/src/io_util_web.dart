/// Web stub for the file I/O utilities.
///
/// `dart:io` is unavailable in browsers, so every operation fails gracefully
/// with the same fallback conventions as the native implementation instead of
/// breaking compilation of the package's public barrel.
abstract final class IoUtil {
  IoUtil._();

  static String readString(String path, {String fallback = ''}) => fallback;

  static List<String> readLines(
    String path, {
    List<String> fallback = const <String>[],
  }) => fallback;

  static bool writeString(String path, String content, {bool append = false}) =>
      false;

  static bool copy(String src, String dst) => false;

  static bool delete(String path) => false;

  static bool exists(String path) => false;

  static int size(String path) => -1;
}
