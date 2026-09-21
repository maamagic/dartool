import 'package:dartool/dartool.dart';
import 'package:test/test.dart';

void main() {
  group('Optional', () {
    test('of / ofNullable / empty', () {
      expect(Optional.of(1).isPresent, isTrue);
      expect(Optional.ofNullable(null).isEmpty, isTrue);
      expect(Optional.ofNullable(2).isPresent, isTrue);
      expect(Optional<int>.empty().isEmpty, isTrue);
    });

    test('getOrElse / getOrThrow', () {
      expect(Optional.of(1).getOrElse(9), 1);
      expect(Optional<int>.empty().getOrElse(9), 9);
      expect(Optional.of(1).getOrThrow(), 1);
      expect(() => Optional<int>.empty().getOrThrow(), throwsStateError);
    });

    test('map / flatMap / filter', () {
      expect(Optional.of(4).map((x) => x * 2).getOrElse(0), 8);
      expect(Optional<int>.empty().map((x) => x * 2).isEmpty, isTrue);
      expect(Optional.of(4).flatMap((x) => Optional.of(x + 1)).value, 5);
      expect(Optional.of(4).filter((x) => x.isEven).isPresent, isTrue);
      expect(Optional.of(3).filter((x) => x.isEven).isEmpty, isTrue);
    });

    test('ifPresent / ifPresentOrElse', () {
      var seen = 0;
      Optional.of(5).ifPresent((x) => seen = x);
      expect(seen, 5);

      var ran = false;
      Optional<int>.empty().ifPresentOrElse((_) {}, () => ran = true);
      expect(ran, isTrue);
    });

    test('toString', () {
      expect(Optional.of(1).toString(), 'Optional(1)');
      expect(Optional<int>.empty().toString(), 'Optional.empty');
    });
  });
}
