/// Cross-platform path manipulation helpers (pure Dart, zero dependencies).
///
/// These utilities mimic a small subset of `package:path` without pulling in
/// the extra dependency. Both `/` and `\` are accepted as separators, and
/// Windows drive prefixes (`C:`) are recognized. On Web the separator is `/`.
library;

import 'platform_util.dart';

abstract final class PathUtil {
  PathUtil._();

  static final RegExp _driveRe = RegExp(r'^[a-zA-Z]:');

  /// Platform-specific path separator (`\` on Windows, `/` elsewhere).
  static String get separator => PlatformUtil.isWindows ? r'\' : '/';

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
            !p.startsWith('/') &&
            !p.startsWith(r'\') &&
            (buffer.isEmpty ||
                (!buffer.toString().endsWith(sep) &&
                    !buffer.toString().endsWith('/') &&
                    !buffer.toString().endsWith(r'\')));
        if (needSep) buffer.write(sep);
        // Strip a leading separator of subsequent parts.
        if (p.startsWith(sep) || p.startsWith('/') || p.startsWith(r'\')) {
          buffer.write(p.substring(1));
        } else {
          buffer.write(p);
        }
      }
    }
    return _normalize(buffer.toString());
  }

  // ---------------------------------------------------------------------------
  // Split / get parts
  // ---------------------------------------------------------------------------

  /// Split [path] into its segments (ignores trailing separator).
  ///
  /// A leading `/` or Windows drive prefix (`C:`) is preserved as the first
  /// segment.
  static List<String> split(String path) {
    if (path.isEmpty) return const <String>[];
    final cleaned = path.replaceAll('\\', '/');
    final drive = _driveRe.firstMatch(cleaned);
    String root;
    String rest;
    if (drive != null) {
      root = drive.group(0)!;
      rest = cleaned.substring(drive.end).startsWith('/')
          ? cleaned.substring(drive.end + 1)
          : cleaned.substring(drive.end);
    } else if (cleaned.startsWith('/')) {
      root = '/';
      rest = cleaned.substring(1);
    } else {
      root = '';
      rest = cleaned;
    }
    final parts = rest.split('/').where((s) => s.isNotEmpty).toList();
    if (root.isNotEmpty) parts.insert(0, root);
    return parts;
  }

  /// Normalize [path] (collapse redundant separators, resolve `.` / `..`
  /// segments). Returned path always uses forward slashes.
  static String normalize(String path) => _normalize(path);

  // ---------------------------------------------------------------------------
  // Query / extension
  // ---------------------------------------------------------------------------

  /// File extension of [path] without the leading dot; returns `''` if none.
  ///
  /// Dotfiles such as `.bashrc` have no extension.
  static String extension(String path) {
    final base = baseName(path);
    final idx = base.lastIndexOf('.');
    if (idx <= 0 || idx == base.length - 1) return '';
    return base.substring(idx + 1);
  }

  /// Filename (last segment) of [path].
  ///
  /// `baseName('a/b/c.txt')` ?`c.txt`, `baseName('a/b/c.txt', '.txt')` ?`c`.
  static String baseName(String path, [String? suffix]) {
    final parts = split(path);
    if (parts.isEmpty) return '';
    final name = parts.last;
    if (suffix != null && suffix.isNotEmpty && name.endsWith(suffix)) {
      return name.substring(0, name.length - suffix.length);
    }
    return name;
  }

  /// Directory part of [path].
  ///
  /// `dirName('a/b/c.txt')` ?`a/b`.
  static String dirName(String path) {
    final cleaned = path.replaceAll('\\', '/');
    final slashIdx = cleaned.lastIndexOf('/');
    if (slashIdx < 0) return '';
    final drive = _driveRe.firstMatch(cleaned);
    if (drive != null && slashIdx == drive.end) {
      // Root directory of a drive, e.g. dirName('C:/foo').
      return cleaned.substring(0, slashIdx + 1);
    }
    if (slashIdx == 0) return '/';
    return path.substring(0, slashIdx).replaceAll('\\', '/');
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  /// Normalize to forward slashes, collapse separators, resolve `.` / `..`.
  static String _normalize(String path) {
    if (path.isEmpty) return '';
    final cleaned = path.replaceAll('\\', '/');
    final drive = _driveRe.firstMatch(cleaned);
    final afterRoot = drive != null
        ? cleaned.substring(drive.end).startsWith('/')
              ? cleaned.substring(drive.end + 1)
              : cleaned.substring(drive.end)
        : cleaned.startsWith('/')
        ? cleaned.substring(1)
        : cleaned;
    final isRoot = drive != null || cleaned.startsWith('/');
    final parts = <String>[];
    for (final seg in afterRoot.split('/')) {
      if (seg.isEmpty || seg == '.') continue;
      if (seg == '..') {
        if (parts.isNotEmpty && parts.last != '..') {
          parts.removeLast();
        } else if (!isRoot) {
          parts.add('..');
        }
      } else {
        parts.add(seg);
      }
    }
    final joined = parts.join('/');
    if (drive != null) return '${drive.group(0)}/$joined';
    return isRoot ? '/$joined' : joined;
  }
}
