import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetUtil layout shorthands', () {
    test('gaps / box build the expected SizedBox', () {
      expect(WidgetUtil.hGap(), isA<SizedBox>());
      expect((WidgetUtil.hGap(12) as SizedBox).width, 12);
      expect((WidgetUtil.vGap(6) as SizedBox).height, 6);
      final box = WidgetUtil.box(w: 1, h: 2) as SizedBox;
      expect(box.width, 1);
      expect(box.height, 2);
      expect(WidgetUtil.none, isA<SizedBox>());
    });

    test('padding wrappers', () {
      final p = WidgetUtil.pad(child: const Text('x'), all: 4) as Padding;
      expect(p.padding, const EdgeInsets.all(4));

      final ph = WidgetUtil.padH(child: const SizedBox(), h: 3) as Padding;
      expect(ph.padding, const EdgeInsets.symmetric(horizontal: 3));

      final po =
          WidgetUtil.padOnly(child: const SizedBox(), l: 1, t: 2, r: 3, b: 4)
              as Padding;
      expect(po.padding, const EdgeInsets.fromLTRB(1, 2, 3, 4));
    });

    test('center / rounded / expanded wrappers', () {
      expect(WidgetUtil.center(const Text('x')), isA<Center>());
      expect(WidgetUtil.expanded(const Text('x'), flex: 2), isA<Expanded>());
      final clip = WidgetUtil.rounded(const Text('x'), radius: 10) as ClipRRect;
      expect(clip.borderRadius, BorderRadius.circular(10));
    });

    test('conditional rendering via when', () {
      final shown = WidgetUtil.when(true, const Text('yes'));
      final hidden = WidgetUtil.when(false, const Text('yes'));
      expect((shown as Text).data, 'yes');
      expect(hidden, same(WidgetUtil.none));
    });

    test('stack positioning helpers', () {
      final tl =
          WidgetUtil.topLeft(const Text('x'), top: 1, left: 2) as Positioned;
      expect(tl.top, 1);
      expect(tl.left, 2);
      expect(WidgetUtil.bottom(const Text('x'), bottom: 5), isA<Positioned>());
    });
  });

  group('WidgetUtil snackbars', () {
    Future<void> show(
      WidgetTester tester,
      Future<void> Function(BuildContext) showFn,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showFn(context),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pump();
    }

    testWidgets('snackbar shows message and default colors', (tester) async {
      await show(tester, (ctx) => WidgetUtil.snackbar(ctx, 'hello'));
      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, isNull);
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('hello'),
        ),
      );
      expect(text.style?.color, isNull);
    });

    testWidgets('snackSuccess applies green background and white text', (
      tester,
    ) async {
      await show(tester, (ctx) => WidgetUtil.snackSuccess(ctx, 'saved'));
      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, const Color(0xFF4CAF50));
      final text = tester.widget<Text>(find.text('saved'));
      expect(text.style?.color, Colors.white);
    });

    testWidgets('snackWarning applies amber background and white text', (
      tester,
    ) async {
      await show(tester, (ctx) => WidgetUtil.snackWarning(ctx, 'careful'));
      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, const Color(0xFFFFA726));
      expect(
        tester.widget<Text>(find.text('careful')).style?.color,
        Colors.white,
      );
    });

    testWidgets('snackError applies red background and white text', (
      tester,
    ) async {
      await show(tester, (ctx) => WidgetUtil.snackError(ctx, 'failed'));
      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, const Color(0xFFE53935));
      expect(
        tester.widget<Text>(find.text('failed')).style?.color,
        Colors.white,
      );
    });
  });
}
