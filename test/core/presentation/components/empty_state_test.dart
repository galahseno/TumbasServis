import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';

Widget _host({required double keyboardInset}) => MaterialApp(
  theme: AppTheme.light,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(viewInsets: EdgeInsets.only(bottom: keyboardInset)),
    child: child!,
  ),
  home: Scaffold(
    body: Column(
      children: [
        const TextField(),
        Expanded(
          child: EmptyState(
            title: 'Tidak ada suku cadang',
            body: 'Coba kata kunci lain.',
            ctaLabel: 'Hapus pencarian',
            onCta: () {},
          ),
        ),
      ],
    ),
  ),
);

void main() {
  testWidgets('fits a short viewport (keyboard open) without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 380);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(keyboardInset: 0));

    expect(tester.takeException(), isNull);
    expect(find.text('Tidak ada suku cadang'), findsOneWidget);
    expect(find.text('Hapus pencarian'), findsOneWidget);
  });

  testWidgets('stays centered and non-scrolling when there is room', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(keyboardInset: 0));

    expect(tester.takeException(), isNull);
    final center = tester.getCenter(find.text('Tidak ada suku cadang'));
    expect(center.dy, greaterThan(200));
  });
}
