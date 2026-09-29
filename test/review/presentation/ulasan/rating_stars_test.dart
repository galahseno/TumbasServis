import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/review/presentation/ulasan/components/rating_stars.dart';

void main() {
  Widget host(Widget child) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('tapping a star reports its whole value', (tester) async {
    int? picked;
    await tester.pumpWidget(
      host(
        RatingStars.input(
          value: 0,
          onChanged: (v) => picked = v,
          semanticLabel: 'Nilai bengkel',
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('rating_star_4')));
    await tester.pump();

    expect(picked, 4);
  });

  testWidgets('star targets are 48 dp wide (large) and filled by shape', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        RatingStars.input(
          value: 3,
          onChanged: (_) {},
          semanticLabel: 'Nilai bengkel',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('rating_star_1'))).width,
      48,
    );
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
    expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(2));
  });

  testWidgets('arrow keys step the value within 1–5', (tester) async {
    var value = 0;
    late StateSetter update;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return RatingStars.input(
              value: value,
              onChanged: (v) => update(() => value = v),
              semanticLabel: 'Nilai bengkel',
            );
          },
        ),
      ),
    );

    Focus.of(
      tester.element(find.byKey(const ValueKey('rating_star_1'))),
    ).requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(value, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(value, 3);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(value, 2);

    for (var i = 0; i < 6; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
    }
    expect(value, 1);

    for (var i = 0; i < 8; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
    }
    expect(value, 5);
  });

  testWidgets('exposes an adjustable semantics value "n dari 5"', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var value = 4;
    await tester.pumpWidget(
      host(
        RatingStars.input(
          value: value,
          onChanged: (v) => value = v,
          semanticLabel: 'Nilai bengkel',
        ),
      ),
    );

    final node = tester.getSemantics(find.bySemanticsLabel('Nilai bengkel'));
    expect(node.value, '4 dari 5');
    expect(node.getSemanticsData().hasAction(SemanticsAction.increase), isTrue);
    expect(node.getSemanticsData().hasAction(SemanticsAction.decrease), isTrue);

    tester.semantics.performAction(
      find.semantics.byLabel('Nilai bengkel'),
      SemanticsAction.increase,
    );
    expect(value, 5);
    handle.dispose();
  });

  testWidgets('display shows half stars for 4.5', (tester) async {
    await tester.pumpWidget(host(RatingStars.display(value: 4.5)));

    expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));
    expect(find.byIcon(Icons.star_half_rounded), findsOneWidget);
    expect(find.byIcon(Icons.star_outline_rounded), findsNothing);
  });

  test('ratingWord maps whole stars to their word', () {
    expect(ratingWord(1), 'Buruk');
    expect(ratingWord(2), 'Kurang');
    expect(ratingWord(3), 'Cukup');
    expect(ratingWord(4), 'Baik');
    expect(ratingWord(5), 'Sangat baik');
    expect(ratingWord(0), '');
  });

  testWidgets('RatingLabel shows word + "n dari 5", or a prompt when empty', (
    tester,
  ) async {
    await tester.pumpWidget(host(const RatingLabel(value: 0)));
    expect(find.text('Ketuk bintang untuk menilai'), findsOneWidget);

    await tester.pumpWidget(host(const RatingLabel(value: 4)));
    expect(find.text('Baik · 4 dari 5'), findsOneWidget);
  });
}
