import 'package:dartool_flutter/dartool_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(MediaQueryData data, void Function(BuildContext context) probe) {
    late BuildContext captured;
    return MaterialApp(
      home: MediaQuery(
        data: data,
        child: Builder(
          builder: (context) {
            captured = context;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => probe(captured),
            );
            return const SizedBox();
          },
        ),
      ),
    );
  }

  testWidgets('reads size / orientation / insets from MediaQuery', (
    tester,
  ) async {
    final data = MediaQueryData(
      size: const Size(800, 600),
      devicePixelRatio: 2.5,
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      viewPadding: const EdgeInsets.only(top: 30, bottom: 40),
      viewInsets: const EdgeInsets.only(bottom: 250),
      platformBrightness: Brightness.dark,
    );

    late MediaQueryResult r;
    await tester.pumpWidget(
      host(data, (context) {
        r = MediaQueryResult(
          width: MediaQueryUtil.width(context),
          height: MediaQueryUtil.height(context),
          size: MediaQueryUtil.size(context),
          padding: MediaQueryUtil.padding(context),
          viewPadding: MediaQueryUtil.viewPadding(context),
          viewInsets: MediaQueryUtil.viewInsets(context),
          dpr: MediaQueryUtil.devicePixelRatio(context),
          landscape: MediaQueryUtil.isLandscape(context),
          portrait: MediaQueryUtil.isPortrait(context),
          dark: MediaQueryUtil.isDark(context),
          statusBar: MediaQueryUtil.statusBarHeight(context),
          bottomBar: MediaQueryUtil.bottomBarHeight(context),
          keyboard: MediaQueryUtil.keyboardHeight(context),
          shortest: MediaQueryUtil.shortestSide(context),
          scaler: MediaQueryUtil.textScaler(context),
        );
      }),
    );

    expect(r.width, 800);
    expect(r.height, 600);
    expect(r.size, const Size(800, 600));
    expect(r.padding.top, 30);
    expect(r.viewPadding.bottom, 40);
    expect(r.viewInsets.bottom, 250);
    expect(r.dpr, 2.5);
    expect(r.landscape, isTrue);
    expect(r.portrait, isFalse);
    expect(r.dark, isTrue);
    expect(r.statusBar, 30);
    expect(r.bottomBar, 10);
    expect(r.keyboard, 250);
    expect(r.shortest, 600);
    expect(r.scaler, TextScaler.noScaling);
  });

  testWidgets('portrait orientation is detected', (tester) async {
    final data = MediaQueryData(size: const Size(400, 800));
    late bool portrait;
    await tester.pumpWidget(
      host(data, (context) {
        portrait = MediaQueryUtil.isPortrait(context);
      }),
    );
    expect(portrait, isTrue);
  });
}

class MediaQueryResult {
  MediaQueryResult({
    required this.width,
    required this.height,
    required this.size,
    required this.padding,
    required this.viewPadding,
    required this.viewInsets,
    required this.dpr,
    required this.landscape,
    required this.portrait,
    required this.dark,
    required this.statusBar,
    required this.bottomBar,
    required this.keyboard,
    required this.shortest,
    required this.scaler,
  });

  final double width;
  final double height;
  final Size size;
  final EdgeInsets padding;
  final EdgeInsets viewPadding;
  final EdgeInsets viewInsets;
  final double dpr;
  final bool landscape;
  final bool portrait;
  final bool dark;
  final double statusBar;
  final double bottomBar;
  final double keyboard;
  final double shortest;
  final TextScaler scaler;
}
