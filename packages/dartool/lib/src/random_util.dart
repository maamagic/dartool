import 'dart:math' as math;

/// Random value generators — strings, ints, doubles, UUID-style IDs,
/// weighted pickers, shuffles, etc.
abstract final class RandomUtil {
  RandomUtil._();

  static final math.Random _r = math.Random();

  // ---------------------------------------------------------------------------
  // Numeric
  // ---------------------------------------------------------------------------

  /// Random integer in `[min, max)` (max exclusive).
  static int nextInt(int max, {int min = 0}) {
    if (min >= max) {
      throw ArgumentError.value('min must be less than max');
    }
    return min + _r.nextInt(max - min);
  }

  /// Random double in `[min, max)`.
  static double nextDouble({double min = 0.0, double max = 1.0}) {
    if (min >= max) {
      throw ArgumentError.value('min must be less than max');
    }
    return min + _r.nextDouble() * (max - min);
  }

  /// Random boolean with an optional [probability] of being `true`
  /// (defaults to `0.5`).
  static bool nextBool({double probability = 0.5}) {
    if (probability < 0.0 || probability > 1.0) {
      throw ArgumentError.value('probability must be in [0, 1]');
    }
    return _r.nextDouble() < probability;
  }

  // ---------------------------------------------------------------------------
  // String
  // ---------------------------------------------------------------------------

  static const String _lower = 'abcdefghijklmnopqrstuvwxyz';
  static const String _upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _digits = '0123456789';
  static const String _hex = '0123456789abcdef';

  /// Build a random string of [length] using characters from [chars].
  static String randomString(int length, {String? chars}) {
    if (length < 0) throw ArgumentError.value(length, 'length');
    final pool = chars ?? (_lower + _upper + _digits);
    if (pool.isEmpty) return '';
    final sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(pool[_r.nextInt(pool.length)]);
    }
    return sb.toString();
  }

  /// Random hex string of [length] characters (lowercase).
  static String randomHex(int length) => randomString(length, chars: _hex);

  /// Random alphabetic (mixed case) string of [length] characters.
  static String randomAlpha(int length) =>
      randomString(length, chars: _lower + _upper);

  /// Random numeric string of [length] digits.
  static String randomNumeric(int length) =>
      randomString(length, chars: _digits);

  // ---------------------------------------------------------------------------
  // Collection helpers
  // ---------------------------------------------------------------------------

  /// Shuffle [list] in place and return it.
  static List<T> shuffle<T>(List<T> list) {
    list.shuffle(_r);
    return list;
  }

  /// Return a new list containing a random sample of [n] items from [list].
  ///
  /// When [n] >= the list length, returns a shuffled copy of the whole list.
  static List<T> sample<T>(List<T> list, int n) {
    if (n <= 0 || list.isEmpty) return <T>[];
    final copy = List<T>.from(list);
    copy.shuffle(_r);
    if (n >= copy.length) return copy;
    return copy.sublist(0, n);
  }

  /// Pick a single random element from [list]; returns `null` if empty.
  static T? pick<T>(List<T> list) {
    if (list.isEmpty) return null;
    return list[_r.nextInt(list.length)];
  }

  /// Pick one element from [items], each with a corresponding [weight].
  ///
  /// Throws if [items] and [weight] have different lengths or all weights
  /// are non-positive.
  static T pickWeighted<T>(List<T> items, List<double> weight) {
    if (items.length != weight.length) {
      throw ArgumentError('items and weight must have the same length');
    }
    final total = weight.fold<double>(0, (a, b) => a + b);
    if (total <= 0) {
      throw ArgumentError('total weight must be positive');
    }
    var r = _r.nextDouble() * total;
    for (var i = 0; i < items.length; i++) {
      r -= weight[i];
      if (r <= 0) return items[i];
    }
    return items.last;
  }
}
