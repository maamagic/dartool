import 'dart:io';

/// File I/O utilities (read / write text files, copy, etc.).
///
/// Relies on `dart:io` from the standard library. Not usable on Web.
abstract final class IoUtil {
  IoUtil._();

  /// Read the content of [path] as a UTF-8 string; returns [fallback] on
  /// any error (missing file, permission, etc.).
  static String readString(String path, {String fallback = ''}) {
    try {
      return File(path).readAsStringSync();
    } catch (_) {
      return fallback;
    }
  }

  /// Read all lines of [path]; returns [fallback] on error.
  static List<String> readLines(
    String path, {
    List<String> fallback = const <String>[],
  }) {
    try {
      return File(path).readAsLinesSync();
    } catch (_) {
      return fallback;
    }
  }

  /// Write [content] to [path] (UTF-8); create the file and any parent
  /// directories if they do not exist. Returns `true` on success.
  static bool writeString(String path, String content, {bool append = false}) {
    try {
      final file = File(path);
      if (append) {
        file.writeAsStringSync(content, mode: FileMode.append);
      } else {
        file.parent.createSync(recursive: true);
        file.writeAsStringSync(content);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Copy file from [src] to [dst]; create parent dirs of [dst] if needed.
  /// Returns `true` on success.
  static bool copy(String src, String dst) {
    try {
      final target = File(dst);
      target.parent.createSync(recursive: true);
      File(src).copySync(dst);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Delete the file at [path] if it exists. Returns `true` on success.
  static bool delete(String path) {
    try {
      final f = File(path);
      if (!f.existsSync()) return true;
      f.deleteSync();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Whether [path] points to an existing file.
  static bool exists(String path) => File(path).existsSync();

  /// Size of the file at [path] in bytes, or `-1` on error.
  static int size(String path) {
    try {
      return File(path).lengthSync();
    } catch (_) {
      return -1;
    }
  }
}
