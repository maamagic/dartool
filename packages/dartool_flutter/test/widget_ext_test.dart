import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetX wrappers', () {
    test('padding helpers', () {
      final all = const Text('x').padAll(8) as Padding;
      expect(all.padding, const EdgeInsets.all(8));

      final only =
          const Text('x').padOnly(left: 1, top: 2, right: 3, bottom: 4)
              as Padding;
      expect(only.padding, const EdgeInsets.fromLTRB(1, 2, 3, 4));

      final h = const Text('x').padH(5) as Padding;
      expect(h.padding, const EdgeInsets.symmetric(horizontal: 5));
    });

    test('center / expand / flex / sized', () {
      expect(const Text('x').centerWidget(), isA<Center>());
      final expanded = const Text('x').expand(flex: 3) as Expanded;
      expect(expanded.flex, 3);
      expect(const Text('x').flex(), isA<Flexible>());
      final sized = const Text('x').sized(width: 10, height: 20) as SizedBox;
      expect(sized.width, 10);
      expect(sized.height, 20);
    });

    test('safeArea and visible', () {
      expect(const Text('x').safeArea(), isA<SafeArea>());
      expect(const Text('x').visible(true), isA<Text>());
      expect(const Text('x').visible(false), isA<SizedBox>());
      expect(
        const Text('x').visible(false, fallback: const Text('fb')).runtimeType,
        Text,
      );
    });

    test('shadow scales with elevation', () {
      List<BoxShadow> shadowsOf(Widget w) =>
          ((w as Container).decoration! as BoxDecoration).boxShadow!;

      final s4 = shadowsOf(const Text('x').shadow(elevation: 4)).single;
      expect(s4.offset, const Offset(0, 4));
      expect(s4.blurRadius, 8);

      // explicit offset / blurRadius override the elevation defaults
      final sOver = shadowsOf(
        const Text(
          'x',
        ).shadow(elevation: 4, offset: const Offset(1, 2), blurRadius: 3),
      ).single;
      expect(sOver.offset, const Offset(1, 2));
      expect(sOver.blurRadius, 3);
    });

    test('rounded produces decorated container with clip child', () {
      final w = const Text('x').rounded(12, color: Colors.red) as Container;
      final d = w.decoration! as BoxDecoration;
      expect(d.borderRadius, BorderRadius.circular(12));
      expect(d.color, Colors.red);
      expect(w.child, isA<ClipRRect>());
    });

    test('transform / opacity helpers', () {
      expect(const Text('x').opacity(0.5), isA<Opacity>());
      expect(const Text('x').rotate(0.5), isA<Transform>());
      expect(const Text('x').scale(2), isA<Transform>());
    });

    testWidgets('onTap fires and can be disabled', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text('tapme').onTap(() => taps++),
                  const Text('disabled').onTap(() => taps++, enabled: false),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('tapme'));
      await tester.tap(find.text('disabled'));
      expect(taps, 1);
    });
  });

  group('StringWidgetX', () {
    test('text() builds a Text with the string as data', () {
      final w =
          'hello'.text(style: const TextStyle(fontSize: 20), maxLines: 2)
              as Text;
      expect(w.data, 'hello');
      expect(w.style?.fontSize, 20);
      expect(w.maxLines, 2);
    });
  });
}
