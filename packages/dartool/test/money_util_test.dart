import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('Money construction & identity', () {
    test('from double rounds to nearest cent', () {
      expect(Money(0.1).cents, 10);
      expect(Money(0.155).cents, 16);
      expect(Money(0).cents, 0);
    });

    test('fromCents preserves exact value', () {
      expect(Money.fromCents(1234).amount, 12.34);
      expect(Money.fromCents(-50).amount, -0.5);
    });

    test('zero / positive / negative predicates', () {
      expect(Money(0).isZero, isTrue);
      expect(Money(0.01).isPositive, isTrue);
      expect(Money(-0.01).isNegative, isTrue);
      expect(Money(-1.5).abs, Money(1.5));
    });
  });

  group('Money arithmetic', () {
    test('addition is exact in cents', () {
      // classic double pitfall
      expect((Money(0.1) + Money(0.2)).cents, 30);
      expect(Money(1.5) + Money(2.25), Money(3.75));
      expect(Money(10) - Money(3.33), Money(6.67));
    });

    test('multiplication / division round to cents', () {
      expect(Money(1.5) * 2, Money(3));
      expect(Money(10) / 3, Money(3.33));
    });

    test('comparison operators', () {
      expect(Money(1) < Money(2), isTrue);
      expect(Money(3) >= Money(3), isTrue);
    });
  });

  group('Money format', () {
    test('default format has 2 decimals and comma separator', () {
      expect(Money(1234.5).format(), '1,234.50');
      expect(Money(0).format(), '0.00');
      expect(Money(-12.34).format(), '-12.34');
    });

    test('custom decimals / separator', () {
      expect(Money(0).format(decimals: 0), '0');
      expect(Money(1000000).format(thousandSep: '_'), '1_000_000.00');
      expect(Money(1000000).format(decimals: 0), '1,000,000');
    });

    test('formatWithCurrency prepends symbol', () {
      expect(Money(99.9).formatWithCurrency(), r'$99.90');
      expect(Money(99.9).formatWithCurrency(symbol: '¥'), '¥99.90');
    });
  });

  group('Money split', () {
    test('pennies distributed fairly', () {
      final parts = Money(100).split(3);
      expect(parts.length, 3);
      expect(parts.fold<int>(0, (s, m) => s + m.cents), 10000);
      // 100.00 / 3 → 33.33, 33.33, 33.34
      expect(parts[2].cents - parts[0].cents, 1);
    });

    test('split into more parts than cents', () {
      final parts = Money.fromCents(3).split(5);
      expect(parts.every((p) => p.cents <= 1), isTrue);
      expect(parts.fold<int>(0, (s, m) => s + m.cents), 3);
    });
  });

  group('Money equality / hashCode', () {
    test('two instances with same cents are equal', () {
      expect(Money(1.5), Money(1.50));
      expect(Money(1.5).hashCode, Money(1.50).hashCode);
    });
  });
}
