import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/review/presentation/ulasan/ulasan_page.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_invoice_repository.dart';
import '../../../support/fake_review_repository.dart';
import '../../../support/fake_workshop_repository.dart';
import '../../../support/invoice_review_fixtures.dart';
import '../../../support/tracking_fixtures.dart';

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeInvoiceRepository invoiceRepository;
  late FakeReviewRepository reviewRepository;

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  setUp(() {
    bookingRepository = FakeBookingRepository()
      ..getBookingResult = Result.ok(canonicalFinishedBooking());
    invoiceRepository = FakeInvoiceRepository()..paid = true;
    reviewRepository = FakeReviewRepository();
  });

  Future<GoRouter> pump(
    WidgetTester tester, {
    Size size = const Size(412, 915),
    double textScale = 1,
    bool stackDetail = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final router = GoRouter(
      initialLocation: stackDetail
          ? Routes.bookingDetail('fin1')
          : Routes.review('fin1'),
      routes: [
        GoRoute(
          path: Routes.bookingDetailTemplate,
          builder: (context, _) => Scaffold(
            body: TextButton(
              onPressed: () => context.push(Routes.review('fin1')),
              child: const Text('detail page'),
            ),
          ),
        ),
        GoRoute(
          path: Routes.reviewTemplate,
          builder: (_, state) =>
              UlasanPage(bookingId: state.pathParameters['bookingId']!),
        ),
        GoRoute(
          path: Routes.invoiceTemplate,
          builder: (_, _) => const Scaffold(body: Text('invoice page')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          invoiceRepositoryProvider.overrideWithValue(invoiceRepository),
          reviewRepositoryProvider.overrideWithValue(reviewRepository),
          workshopRepositoryProvider.overrideWithValue(
            FakeWorkshopRepository()
              ..workshopResult = const Result.ok(workshopFixture)
              ..mechanicsResult = const Result.ok(mechanicFixtures),
          ),
          clockProvider.overrideWithValue(
            FakeClock(DateTime(2026, 9, 29, 11, 31)),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await _settle(tester);
    if (stackDetail) {
      await tester.tap(find.text('detail page'));
      await _settle(tester);
    }
    return router;
  }

  testWidgets('default: empty stars, comment, two mechanic rows', (
    tester,
  ) async {
    await pump(tester);

    expect(
      find.text('Bagaimana servis di Bengkel Jaya Motor?'),
      findsOneWidget,
    );
    expect(find.text('Ketuk bintang untuk menilai'), findsOneWidget);
    expect(find.text('Komentar (opsional)'), findsOneWidget);
    expect(find.text('Nilai montir'), findsOneWidget);
    expect(find.text('Pak Anto'), findsOneWidget);
    expect(find.text('Vario 125 + PCX 160'), findsOneWidget);
    expect(find.text('Mas Rudi'), findsOneWidget);
    expect(find.text('Opsional'), findsNWidgets(2));
    expect(find.text('Kirim ulasan'), findsOneWidget);
  });

  testWidgets('single mechanic hides the "Nilai montir" section', (
    tester,
  ) async {
    bookingRepository.getBookingResult = Result.ok(
      singleMechanicFinishedBooking(id: 'fin1'),
    );
    await pump(tester);

    expect(find.text('Nilai montir'), findsNothing);
    expect(find.text('Kirim ulasan'), findsOneWidget);
  });

  testWidgets('submit without stars shows the inline error (button enabled)', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Kirim ulasan'));
    await _settle(tester);

    expect(find.text('Pilih bintang untuk bengkel'), findsOneWidget);
    expect(reviewRepository.submitCalls, isEmpty);

    await tester.tap(find.byKey(const ValueKey('rating_star_5')).first);
    await _settle(tester);

    expect(find.text('Pilih bintang untuk bengkel'), findsNothing);
    expect(find.text('Sangat baik · 5 dari 5'), findsOneWidget);
  });

  testWidgets('submitting swaps to the read-only recap and a thank-you', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('rating_star_5')).first);
    await _settle(tester);
    await tester.enterText(
      find.byType(TextField),
      'Cepat dan rapi. Montirnya jelas menerangkan kondisi rem PCX.',
    );
    await tester.pump();
    await tester.tap(find.text('Kirim ulasan'));
    await _settle(tester);

    expect(reviewRepository.submitCalls, hasLength(1));
    expect(find.text('Ulasan terkirim. Terima kasih!'), findsOneWidget);
    expect(
      find.text('Cepat dan rapi. Montirnya jelas menerangkan kondisi rem PCX.'),
      findsOneWidget,
    );
    expect(find.text('Sangat baik · 5 dari 5'), findsOneWidget);
    expect(find.text('Kirim ulasan'), findsNothing);
    expect(find.text('Kembali ke detail booking'), findsOneWidget);
    expect(find.text('Dikirim Sel, 29 Sep 2026 · 11.31'), findsOneWidget);
  });

  testWidgets('"Kembali ke detail booking" returns to the S20 below it', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('rating_star_4')).first);
    await _settle(tester);
    await tester.tap(find.text('Kirim ulasan'));
    await _settle(tester);

    await tester.tap(find.text('Kembali ke detail booking'));
    await _settle(tester);

    expect(find.text('detail page'), findsOneWidget);
  });

  testWidgets('submit failure keeps the form and shows an error snackbar', (
    tester,
  ) async {
    reviewRepository.failSubmit = true;
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('rating_star_3')).first);
    await _settle(tester);

    await tester.tap(find.text('Kirim ulasan'));
    await _settle(tester);

    expect(find.text('Gagal mengirim ulasan. Coba lagi.'), findsOneWidget);
    expect(find.text('Kirim ulasan'), findsOneWidget);
    expect(find.text('Cukup · 3 dari 5'), findsOneWidget);
  });

  testWidgets('an unpaid invoice shows the blocked state → S23', (
    tester,
  ) async {
    invoiceRepository.paid = false;
    await pump(tester);

    expect(find.text('Tandai lunas di invoice dulu'), findsOneWidget);
    expect(find.text('Kirim ulasan'), findsNothing);

    await tester.tap(find.text('Buka invoice'));
    await _settle(tester);

    expect(find.text('invoice page'), findsOneWidget);
  });

  testWidgets('an existing review opens as the read-only recap', (
    tester,
  ) async {
    reviewRepository.review = Review(
      bookingId: 'fin1',
      workshopRating: 4,
      workshopComment: 'Mantap',
      mechanicRatings: const {'mech_001': 5},
      createdAt: DateTime(2026, 9, 29, 11, 31),
    );
    await pump(tester);

    expect(find.text('Mantap'), findsOneWidget);
    expect(find.text('Baik · 4 dari 5'), findsOneWidget);
    expect(find.text('Mas Rudi'), findsOneWidget);
    expect(find.text('Pak Anto'), findsNothing);
    expect(find.text('Kirim ulasan'), findsNothing);
  });

  testWidgets('opened with an empty stack, back falls back to S20', (
    tester,
  ) async {
    final router = await pump(tester, stackDetail: false);
    expect(router.canPop(), isFalse);

    await tester.tap(
      find.byType(BackButton).evaluate().isEmpty
          ? find.byIcon(Icons.arrow_back_rounded).first
          : find.byType(BackButton),
    );
    await _settle(tester);

    expect(find.text('detail page'), findsOneWidget);
  });

  for (final (size, scale) in [
    (const Size(320, 568), 1.0),
    (const Size(360, 640), 1.3),
    (const Size(412, 915), 1.3),
  ]) {
    testWidgets('no overflow at ${size.width.toInt()}×${size.height.toInt()} '
        '×$scale (form + recap)', (tester) async {
      await pump(tester, size: size, textScale: scale);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const ValueKey('rating_star_5')).first);
      await _settle(tester);
      await tester.tap(find.text('Kirim ulasan'));
      await _settle(tester);
      expect(tester.takeException(), isNull);
    });
  }
}
