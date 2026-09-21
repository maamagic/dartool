import 'dart:math' as math;

/// Number utilities  clamp, rounding, formatting, safe parsing.
abstract final class NumUtil {
  NumUtil._();

  // ---------------------------------------------------------------------------
  // Clamping
  // ---------------------------------------------------------------------------

  /// Clamp [value] into `[min, max]`.
  static T clamp<T extends num>(T value, T min, T max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  /// Linearly map [value] from `[inMin, inMax]` onto `[outMin, outMax]`.
  static double mapRange(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) {
    if (inMax == inMin) return outMin;
    final t = (value - inMin) / (inMax - inMin);
    return outMin + t * (outMax - outMin);
  }

  // ---------------------------------------------------------------------------
  // Rounding
  // ---------------------------------------------------------------------------

  /// Round [value] to [decimal] places (positive = keep decimals, negative =
  /// round to tens/hundreds).
  ///
  /// Examples: `round(3.1415, 2)  3.14`, `round(1234.0, -2)  1200`.
  static double round(num value, {int decimal = 0}) {
    final pow = math.pow(10, decimal);
    return (value * pow).roundToDouble() / pow;
  }

  /// Floor [value] to [decimal] places.
  static double floor(num value, {int decimal = 0}) {
    final pow = math.pow(10, decimal);
    return (value * pow).floorToDouble() / pow;
  }

  /// Ceil [value] to [decimal] places.
  static double ceil(num value, {int decimal = 0}) {
    final pow = math.pow(10, decimal);
    return (value * pow).ceilToDouble() / pow;
  }

  // ---------------------------------------------------------------------------
  // Min / max of arbitrary num lists
  // ---------------------------------------------------------------------------

  /// Minimum of [values]; returns `null` when iterable is empty.
  static T? min<T extends num>(Iterable<T> values) {
    T? best;
    for (final v in values) {
      if (best == null || v < best) best = v;
    }
    return best;
  }

  /// Maximum of [values]; returns `null` when iterable is empty.
  static T? max<T extends num>(Iterable<T> values) {
    T? best;
    for (final v in values) {
      if (best == null || v > best) best = v;
    }
    return best;
  }

  /// Sum of [values]; returns `0` for an empty `int` iterable and `0.0` for
  /// an empty `double` iterable.
  ///
  /// Works with both `Iterable<int>` and `Iterable<double>` (an empty
  /// `Iterable<double>` must yield `0.0`, never a cast failure).
  static T sum<T extends num>(Iterable<T> values) {
    num total = 0;
    for (final v in values) {
      total += v;
    }
    if (total == 0 && values is Iterable<double>) {
      return 0.0 as T;
    }
    return total as T;
  }

  /// Average of [values]; returns `0.0` when empty.
  static double average(Iterable<num> values) {
    var count = 0;
    double total = 0;
    for (final v in values) {
      total += v;
      count++;
    }
    return count == 0 ? 0.0 : total / count;
  }

  // ---------------------------------------------------------------------------
  // Safe parsing
  // ---------------------------------------------------------------------------

  /// Parse [source] as an `int`; returns [fallback] on failure.
  static int? parseInt(String? source, {int? fallback}) {
    if (source == null) return fallback;
    final t = source.trim();
    if (t.isEmpty) return fallback;
    return int.tryParse(t) ?? fallback;
  }

  /// Parse [source] as a `double`; returns [fallback] on failure.
  static double? parseDouble(String? source, {double? fallback}) {
    if (source == null) return fallback;
    final t = source.trim();
    if (t.isEmpty) return fallback;
    return double.tryParse(t) ?? fallback;
  }

  // ---------------------------------------------------------------------------
  // Formatting
  // ---------------------------------------------------------------------------

  /// Format a number with thousand separators (default `,`).
  ///
  /// Examples: `formatThousand(1234567)  '1,234,567'`,
  /// `formatThousand(1234.5, fractionalDigits: 2)  '1,234.50'`.
  static String formatThousand(
    num value, {
    int fractionalDigits = 0,
    String separator = ',',
    String decimalPoint = '.',
  }) {
    final String intPart;
    final String fracPart;
    if (fractionalDigits > 0) {
      final fixed = value.toStringAsFixed(fractionalDigits);
      final dot = fixed.indexOf('.');
      intPart = dot < 0 ? fixed : fixed.substring(0, dot);
      fracPart = dot < 0 ? '' : fixed.substring(dot + 1);
    } else {
      intPart = value.truncate().toString();
      fracPart = '';
    }

    final isNeg = intPart.startsWith('-');
    final abs = isNeg ? intPart.substring(1) : intPart;

    final sb = StringBuffer();
    final len = abs.length;
    for (var i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) sb.write(separator);
      sb.write(abs[i]);
    }
    final head = '${isNeg ? '-' : ''}$sb';
    return fracPart.isEmpty ? head : '$head$decimalPoint$fracPart';
  }

  /// Byte-size  human-readable string.
  ///
  /// Example: `formatBytes(1536)  '1.5 KB'`.
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes < 1024) return '$bytes B';
    const units = ['KB', 'MB', 'GB', 'TB', 'PB'];
    double v = bytes.toDouble();
    for (final u in units) {
      v /= 1024;
      if (v < 1024) {
        return '${v.toStringAsFixed(decimals)} $u';
      }
    }
    return '${v.toStringAsFixed(decimals)} EB';
  }
}
