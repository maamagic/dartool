import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget app(void Function(BuildContext context) onPressed) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => onPressed(context),
            child: const Text('open'),
          ),
        ),
      ),
    );
  }

  testWidgets('confirm resolves true on OK', (tester) async {
    Future<bool>? result;
    await tester.pumpWidget(
      app((context) {
        result = DialogUtil.confirm(context);
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('OK'));
    await expectLater(result, completion(isTrue));
  });

  testWidgets('confirm resolves false on Cancel', (tester) async {
    Future<bool>? result;
    await tester.pumpWidget(
      app((context) {
        result = DialogUtil.confirm(
          context,
          confirmText: 'Yes',
          cancelText: 'No',
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.tap(find.text('No'));
    await expectLater(result, completion(isFalse));
  });

  testWidgets('confirm resolves false when barrier is tapped', (tester) async {
    Future<bool>? result;
    await tester.pumpWidget(
      app((context) {
        result = DialogUtil.confirm(context);
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    // top-left corner is the modal barrier, not the dialog
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await expectLater(result, completion(isFalse));
  });

  testWidgets('non-dismissible dialog ignores barrier tap', (tester) async {
    await tester.pumpWidget(
      app((context) {
        DialogUtil.alert<void>(context, barrierDismissible: false);
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('alert returns the popped action value', (tester) async {
    Future<int?>? result;
    await tester.pumpWidget(
      app((context) {
        result = DialogUtil.alert<int>(
          context,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(42),
              child: const Text('yes'),
            ),
          ],
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.tap(find.text('yes'));
    await expectLater(result, completion(42));
  });

  testWidgets('bottom sheet shows and can be dismissed', (tester) async {
    Future<void>? result;
    await tester.pumpWidget(
      app((context) {
        result = DialogUtil.bottom<void>(
          context,
          (_) => const SizedBox(height: 200, child: Text('sheet')),
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('sheet'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('sheet'), findsNothing);
    await expectLater(result, completes);
  });

  testWidgets('pop is a safe no-op when nothing can pop', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => DialogUtil.pop<void>(context),
              child: const Text('noop'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('noop'));
    await tester.pump();
    expect(find.text('noop'), findsOneWidget);
  });
}
