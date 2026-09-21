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

  /// Split [cents] into [n] parts without losing pennies.
  ///
  /// The first `cents % n` parts get one extra cent.
  List<Money> split(int n) {
    if (n <= 0) throw ArgumentError('n must be positive');
    final base = cents ~/ n;
    final extra = cents % n;
    final result = List<Money>.generate(n, (_) => Money._(base));
    for (var i = n - extra; i < n; i++) {
      result[i] = Money._(base + 1);
    }
    return result;
  }

  /// Format with [decimals] places and optional thousand separator.
  ///
  /// ```dart
  /// Money(1234.5).format();              // '1,234.50'
  /// Money(0).format(decimals: 0);        // '0'
  /// Money(-12.34).format();             // '-12.34'
  /// ```
  String format({int decimals = 2, String thousandSep = ','}) {
    final sign = cents.isNegative ? '-' : '';
    final absCents = cents.abs();
    final dollar = absCents ~/ 100;
    final cent = absCents % 100;

    final dollarStr = dollar.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}$thousandSep',
    );

    if (decimals == 0) return '$sign$dollarStr';
    final centStr = cent
        .toString()
        .padLeft(decimals, '0')
        .substring(0, decimals);
    return '$sign$dollarStr.$centStr';
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
