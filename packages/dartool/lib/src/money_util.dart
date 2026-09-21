/// Money helpers  fixed-precision arithmetic that avoids double rounding.
///
/// Internally amounts are stored as **cents** (an `int`), so `0.1 + 0.2`
/// really does equal `0.3`. Use [format] / [formatWithCurrency] for display.
class Money {
  const Money._(this.cents);

  /// Construct from a dollar/float amount. Fractions are rounded to the
  /// nearest cent.
  factory Money(num amount) => Money._((amount * 100).round());

  /// Construct directly from cents (smallest unit).
  factory Money.fromCents(int cents) => Money._(cents);

  final int cents;

  double get amount => cents / 100;

  int get dollars => cents ~/ 100;
  int get remainingCents => cents.abs() % 100;

  Money operator +(Money other) => Money._(cents + other.cents);
  Money operator -(Money other) => Money._(cents - other.cents);
  Money operator *(num factor) => Money._((cents * factor).round());
  Money operator /(num divisor) => Money._((cents / divisor).round());
  Money operator -() => Money._(-cents);

  bool operator <(Money other) => cents < other.cents;
  bool operator <=(Money other) => cents <= other.cents;
  bool operator >(Money other) => cents > other.cents;
  bool operator >=(Money other) => cents >= other.cents;

  bool get isZero => cents == 0;
  bool get isPositive => cents > 0;
  bool get isNegative => cents < 0;
  Money get abs => Money._(cents.abs());

  /// Split into [n] parts without losing pennies.
  ///
  /// The last `remainder` parts receive one extra cent (or one cent less for
  /// negative amounts); the sum of the parts always equals the original value.
  List<Money> split(int n) {
    if (n <= 0) throw ArgumentError('n must be positive');
    // `~/` truncates toward zero, so the remainder carries the sign and is
    // always smaller in magnitude than n.
    final base = cents ~/ n;
    final remainder = cents - base * n;
    final extra = remainder.abs();
    final step = remainder.isNegative ? -1 : 1;
    return List<Money>.generate(n, (i) {
      if (i >= n - extra) return Money._(base + step);
      return Money._(base);
    });
  }

  /// Format with [decimals] places and optional thousand separator.
  ///
  /// The value is rounded half-up to the requested precision (never silently
  /// truncated), and rounding carry into the integer part is handled:
  ///
  /// ```dart
  /// Money(1234.5).format();              // '1,234.50'
  /// Money(0).format(decimals: 0);        // '0'
  /// Money(-12.34).format();             // '-12.34'
  /// Money(0.59).format(decimals: 1);     // '0.6'
  /// Money.fromCents(99).format(decimals: 1); // '1.0'
  /// ```
  String format({int decimals = 2, String thousandSep = ','}) {
    if (decimals < 0) {
      throw ArgumentError.value(decimals, 'decimals', 'must be >= 0');
    }
    final sign = cents.isNegative ? '-' : '';
    final absCents = cents.abs();

    if (decimals == 0) {
      final rounded = (absCents + 50) ~/ 100;
      return '$sign${_groupDigits(rounded, thousandSep)}';
    }

    final factor = _pow10(decimals);
    // Round half-up to `decimals` places using integer math on cents.
    final scaled = (absCents * factor + 50) ~/ 100;
    final whole = scaled ~/ factor;
    final fraction = scaled % factor;
    final fractionStr = fraction.toString().padLeft(decimals, '0');
    return '$sign${_groupDigits(whole, thousandSep)}.$fractionStr';
  }

  static int _pow10(int n) {
    var v = 1;
    for (var i = 0; i < n; i++) {
      v *= 10;
    }
    return v;
  }

  static String _groupDigits(int value, String separator) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}$separator',
    );
  }

  String formatWithCurrency({String symbol = '\$', int decimals = 2}) {
    return '$symbol${format(decimals: decimals)}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Money && other.cents == cents);

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => 'Money(${format()})';
}
