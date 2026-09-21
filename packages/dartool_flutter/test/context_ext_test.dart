import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('media query getters on context', (tester) async {
    late double width;
    late double statusBar;
    late bool landscape;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(900, 500),
            padding: EdgeInsets.only(top: 24),
          ),
          child: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                width = context.width;
                statusBar = context.statusBarHeight;
                landscape = context.isLandscape;
              });
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(width, 900);
    expect(statusBar, 24);
    expect(landscape, isTrue);
  });

  testWidgets('theme getters on context', (tester) async {
    const primary = Color(0xFF123456);
    late Color actual;
    late bool darkTheme;
    late TextTheme textTheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(primary: primary),
        ),
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              actual = context.primary;
              darkTheme = context.isDarkTheme;
              textTheme = context.textTheme;
            });
            return const SizedBox();
          },
        ),
      ),
    );
    expect(actual, primary);
    expect(darkTheme, isFalse);
    expect(textTheme, isNotNull);
  });

  testWidgets('showSnackBar displays the message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => context.showSnackBar('hi from context'),
              child: const Text('snack'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('snack'));
    await tester.pump();
    expect(find.text('hi from context'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('push / pop through context extensions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => context.push(const _SecondPage()),
              child: const Text('push'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(_SecondPage), findsNothing);
    await tester.tap(find.text('push'));
    await tester.pumpAndSettle();
    expect(find.byType(_SecondPage), findsOneWidget);

    // pop on the root route is a safe no-op
    await tester.tap(find.text('back'));
    await tester.pumpAndSettle();
    expect(find.byType(_SecondPage), findsNothing);
  });
}

class _SecondPage extends StatelessWidget {
  const _SecondPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () => context.pop(),
        child: const Text('back'),
      ),
    );
  }
}
