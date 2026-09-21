/// URL encoding / decoding and query-string helpers.
///
/// Uses only `dart:convert` from the standard library.
abstract final class UrlUtil {
  UrlUtil._();

  // ---------------------------------------------------------------------------
  // Encoding / decoding
  // ---------------------------------------------------------------------------

  /// Percent-encode a string for use in a URL (space → `%20`, etc.).
  ///
  /// This is a thin wrapper around [Uri.encodeComponent].
  static String encode(String input) => Uri.encodeComponent(input);

  /// Decode a percent-encoded string. Returns [fallback] on any parsing error.
  static String decode(String input, {String fallback = ''}) {
    try {
      return Uri.decodeComponent(input);
    } catch (_) {
      return fallback;
    }
  }

  /// Percent-encode a whole URI string (path + query).
  static String encodeFull(String input) => Uri.encodeFull(input);

  /// Decode a full URI string. Returns [fallback] on error.
  static String decodeFull(String input, {String fallback = ''}) {
    try {
      return Uri.decodeFull(input);
    } catch (_) {
      return fallback;
    }
  }

  // ---------------------------------------------------------------------------
  // URI / query helpers
  // ---------------------------------------------------------------------------

  /// Safely parse [source] as a [Uri]; returns `null` on failure.
  ///
  /// Also accepts a raw query string (e.g. `a=1&b=2`) — it is parsed as if it
  /// came from `/?a=1&b=2`.
  static Uri? tryParse(String source) {
    if (source.isEmpty) return null;
    final isRawQuery =
        !source.contains('/') &&
        !source.contains(':') &&
        (source.contains('=') || source.contains('&') || source.contains('?'));
    final candidate = isRawQuery ? '/?$source' : source;
    try {
      final uri = Uri.parse(candidate);
      // Reject garbage that Uri.parse silently encodes (e.g. "not a uri"
      // becomes a Uri with only path="not%20a%20uri" and no scheme/host).
      final looksValid =
          uri.scheme.isNotEmpty ||
          uri.host.isNotEmpty ||
          uri.path.contains('/') ||
          uri.hasQuery;
      return looksValid ? uri : null;
    } on FormatException {
      return null;
    }
  }

  /// Extract the query string of [source] without the leading `?`.
  ///
  /// Example: `https://a.com/x?y=1&z=2` → `y=1&z=2`. Returns `''` if none.
  static String queryOf(String source) {
    final uri = tryParse(source);
    if (uri == null) return '';
    return uri.query;
  }

  /// Parse the query string of [source] into a `Map<String, String>`.
  ///
  /// Example: `a=1&b=2&b=3` → `{'a': '1', 'b': '3'}` (last value wins).
  static Map<String, String> parseQuery(String source) {
    final uri = tryParse(source);
    if (uri == null || uri.query.isEmpty) return <String, String>{};
    final map = <String, String>{};
    for (final pair in uri.query.split('&')) {
      if (pair.isEmpty) continue;
      final eq = pair.indexOf('=');
      if (eq < 0) {
        map[decode(pair)] = '';
      } else {
        map[decode(pair.substring(0, eq))] = decode(pair.substring(eq + 1));
      }
    }
    return map;
  }

  /// Build a query string from [params] (without leading `?`).
  ///
  /// Example: `{'a': 1, 'b': 'x y'}` → `a=1&b=x%20y`.
  static String buildQuery(Map<String, Object?> params) {
    final buffer = StringBuffer();
    var first = true;
    params.forEach((key, value) {
      if (value == null) return;
      final v = value.toString();
      if (!first) buffer.write('&');
      buffer
        ..write(encode(key))
        ..write('=')
        ..write(encode(v));
      first = false;
    });
    return buffer.toString();
  }

  /// Append [params] as query parameters to [url].
  ///
  /// Example: `appendQuery('https://a.com/p', {'x': 1})` → `https://a.com/p?x=1`.
  static String appendQuery(String url, Map<String, Object?> params) {
    if (params.isEmpty) return url;
    final q = buildQuery(params);
    final sep = url.contains('?') ? '&' : '?';
    return '$url$sep$q';
  }

  /// Extract the file extension (without leading dot) from a URL path.
  ///
  /// Example: `https://a.com/foo/bar.png?v=1` → `png`. Returns `''` if none.
  static String extensionOf(String source) {
    final uri = tryParse(source);
    if (uri == null) return '';
    final path = uri.path;
    final idx = path.lastIndexOf('.');
    if (idx < 0 || idx == path.length - 1) return '';
    return path.substring(idx + 1);
  }
}
