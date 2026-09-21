import 'dart:io';

/// Cross-platform path manipulation helpers (pure Dart, zero dependencies).
///
/// These utilities mimic a small subset of `package:path` without pulling in
/// the extra dependency. On Web, [separator] returns `/`.
abstract final class PathUtil {
  PathUtil._();

  /// Platform-specific path separator (`\` on Windows, `/` elsewhere).
  static String get separator => Platform.isWindows ? r'\' : '/';

  // ---------------------------------------------------------------------------
  // Join
  // ---------------------------------------------------------------------------

  /// Join [parts] into a single path, collapsing redundant separators.
  ///
  /// The first part keeps its leading separator (absolute paths stay absolute).
  ///
  /// Examples:
  /// ```dart
  /// join('foo', 'bar', 'baz');     // 'foo/bar/baz'
  /// join('/etc', 'a', 'b.txt');    // '/etc/a/b.txt'
  /// ```
  static String join(List<String> parts) {
    if (parts.isEmpty) return '';
    final sep = separator;
    final buffer = StringBuffer();
    for (var i = 0; i < parts.length; i++) {
      final p = parts[i];
      if (p.isEmpty) continue;
      if (i == 0) {
        buffer.write(p);
      } else {
        final needSep =
            !p.startsWith(sep) &&
            (buffer.isEmpty || !buffer.toString().endsWith(sep));
        if (needSep) buffer.write(sep);
        // Strip leading separator of subsequent parts
        buffer.write(p.startsWith(sep) ? p.substring(1) : p);
      }
    }
    return _normalize(buffer.toString());
  }

  // ---------------------------------------------------------------------------
  // Split / get parts
  // ---------------------------------------------------------------------------

  /// Split [path] into its segments (ignores trailing separator).
  static List<String> split(String path) {
    if (path.isEmpty) return const <String>[];
    final cleaned = path.replaceAll('\\', '/');
    final hasRoot = cleaned.startsWith('/');
    final parts = cleaned.split('/').where((s) => s.isNotEmpty).toList();
    if (hasRoot && parts.isNotEmpty) {
      parts.insert(0, '/');
    } else if (hasRoot) {
      return ['/'];
    }
    return parts;
  }

  /// Normalize [path] (collapse redundant separators, resolve `.` / `..`
  /// segments). Returned path always uses forward slashes.
  static String normalize(String path) => _normalize(path);

  // ---------------------------------------------------------------------------
  // Query / extension
  // ---------------------------------------------------------------------------

  /// File extension of [path] without the leading dot; returns `''` if none.
  static String extension(String path) {
    final idx = path.lastIndexOf('.');
    if (idx < 0 || idx == path.length - 1) return '';
    // Make sure the dot is in the last segment, not a path separator before it
    final sepIdx = path.lastIndexOf(separator);
    final slashIdx = path.lastIndexOf('/');
    final lastSep = sepIdx > slashIdx ? sepIdx : slashIdx;
    if (lastSep > idx) return '';
    return path.substring(idx + 1);
  }

  /// Filename (last segment) of [path].
  ///
  /// `baseName('a/b/c.txt')` ?`c.txt`, `baseName('a/b/c.txt', '.txt')` ?`c`.
  static String baseName(String path, [String? suffix]) {
    final parts = split(path);
    if (parts.isEmpty) return '';
    final name = parts.last;
    if (suffix != null && name.endsWith(suffix)) {
      return name.substring(0, name.length - suffix.length);
    }
    return name;
  }

  /// Directory part of [path].
  ///
  /// `dirName('a/b/c.txt')` ?`a/b`.
  static String dirName(String path) {
    final sepIdx = path.lastIndexOf(separator);
    final slashIdx = path.lastIndexOf('/');
    final lastSep = sepIdx > slashIdx ? sepIdx : slashIdx;
    if (lastSep < 0) return '';
    if (lastSep == 0) return separator;
    return path.substring(0, lastSep);
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  /// Normalize to forward slashes, collapse separators, resolve `.` / `..`.
  static String _normalize(String path) {
    if (path.isEmpty) return '';
    final cleaned = path.replaceAll('\\', '/');
    final hasRoot = cleaned.startsWith('/');
    final parts = <String>[];
    for (final seg in cleaned.split('/')) {
      if (seg.isEmpty || seg == '.') continue;
      if (seg == '..') {
        if (parts.isNotEmpty && parts.last != '..') {
          parts.removeLast();
        } else if (!hasRoot) {
          parts.add('..');
        }
      } else {
        parts.add(seg);
      }
    }
    final joined = parts.join('/');
    return hasRoot ? '/$joined' : joined;
  }
}
