import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/invoice_page.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
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

String _rp(int amount) => CurrencyFormatter.format(amount);

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
    invoiceRepository = FakeInvoiceRepository()
      ..lines = canonicalInvoiceLines
      ..discount = 42800
      ..issuedAt = DateTime(2026, 9, 29, 11, 8);
    reviewRepository = FakeReviewRepository();
  });

  Future<GoRouter> pump(
    WidgetTester tester, {
    Size size = const Size(412, 915),
    double textScale = 1,
    bool settle = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final router = GoRouter(
      initialLocation: Routes.invoice('fin1'),
      routes: [
        GoRoute(
          path: Routes.invoiceTemplate,
          builder: (_, state) =>
              InvoicePage(bookingId: state.pathParameters['bookingId']!),
        ),
        GoRoute(
          path: Routes.reviewTemplate,
          builder: (_, _) => const Scaffold(body: Text('review page')),
        ),
        GoRoute(
          path: Routes.bookingDetailTemplate,
          builder: (_, _) => const Scaffold(body: Text('detail page')),
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
              ..workshopResult = const Result.ok(workshopFixture),
          ),
          catalogRepositoryProvider.overrideWithValue(
            FakeCatalogRepository()
              ..vouchersResult = Result.ok([voucherDiskon10]),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    if (settle) await _settle(tester);
    return router;
  }

  testWidgets('unpaid: per-unit lines and totals match the canonical booking', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('TS-fin1'), findsOneWidget);
    expect(find.text('Belum dibayar'), findsWidgets);
    expect(find.textContaining('Vario 125'), findsOneWidget);
    expect(find.textContaining('Beat 110'), findsOneWidget);
    expect(find.textContaining('PCX 160'), findsOneWidget);
    expect(find.text('Subtotal unit'), findsNWidgets(3));
    expect(find.text(_rp(143000)), findsOneWidget);
    expect(find.text(_rp(200000)), findsOneWidget);
    expect(find.text(_rp(428000)), findsOneWidget);
    expect(find.text('Voucher DISKON10'), findsOneWidget);
    expect(find.text('−${_rp(42800)}'), findsOneWidget);
    expect(find.text('Total tagihan'), findsWidgets);
    expect(find.text(_rp(385200)), findsWidgets);
    expect(find.text('Tandai lunas'), findsOneWidget);
    expect(find.text('Bayar di bengkel'), findsOneWidget);
    expect(find.text('Lunas'), findsNothing);
  });

  testWidgets('loading shows a skeleton with a disabled, reasoned bar', (
    tester,
  ) async {
    invoiceRepository.delay = const Duration(milliseconds: 100);
    await pump(tester, settle: false);
    await tester.pump();

    expect(find.text('Memuat invoice…'), findsOneWidget);
    expect(find.text('Tandai lunas'), findsOneWidget);

    await _settle(tester);
    expect(find.text('Memuat invoice…'), findsNothing);
  });

  testWidgets('confirm dialog copy; "Batal" leaves the invoice unpaid', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Tandai lunas'));
    await tester.pumpAndSettle();

    expect(find.text('Tandai sudah dibayar?'), findsOneWidget);
    expect(
      find.text('Simulasi, tidak ada pembayaran sungguhan.'),
      findsOneWidget,
    );
    expect(find.text('Ya, tandai lunas'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    expect(invoiceRepository.markPaidCalls, isEmpty);
    expect(find.text('Belum dibayar'), findsWidgets);
    expect(find.text('Lunas'), findsNothing);
  });

  testWidgets('confirming marks paid: banner, tag and "Beri ulasan" footer', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Tandai lunas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, tandai lunas'));
    await _settle(tester);

    expect(invoiceRepository.markPaidCalls, ['fin1']);
    expect(find.text('Lunas'), findsWidgets);
    expect(find.text('Dibayar Sel, 29 Sep 2026 · 11.24'), findsOneWidget);
    expect(find.text('Total dibayar'), findsWidgets);
    expect(find.text('Dibayar di bengkel'), findsOneWidget);
    expect(find.text('Beri ulasan'), findsOneWidget);
    expect(find.text('Tandai lunas'), findsNothing);
  });

  testWidgets('paid footer opens S24 in place of S23', (tester) async {
    invoiceRepository.paid = true;
    final router = await pump(tester);

    await tester.tap(find.text('Beri ulasan'));
    await _settle(tester);

    expect(find.text('review page'), findsOneWidget);
    expect(router.canPop(), isFalse);
  });

  testWidgets('a reviewed booking shows "Lihat ulasan"', (tester) async {
    invoiceRepository.paid = true;
    reviewRepository.review = Review(
      bookingId: 'fin1',
      workshopRating: 5,
      mechanicRatings: const {},
      createdAt: DateTime(2026, 9, 29, 11, 31),
    );
    await pump(tester);

    expect(find.text('Lihat ulasan'), findsOneWidget);
    expect(find.text('Beri ulasan'), findsNothing);
  });

  testWidgets('mark-paid failure shows an inline error; retry succeeds', (
    tester,
  ) async {
    invoiceRepository.failMarkPaid = true;
    await pump(tester);

    await tester.tap(find.text('Tandai lunas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, tandai lunas'));
    await _settle(tester);

    expect(find.text('Gagal menandai lunas. Coba lagi.'), findsOneWidget);
    expect(find.text('Belum dibayar'), findsWidgets);

    invoiceRepository.failMarkPaid = false;
    await tester.tap(find.text('Coba lagi'));
    await _settle(tester);

    expect(find.text('Gagal menandai lunas. Coba lagi.'), findsNothing);
    expect(find.text('Beri ulasan'), findsOneWidget);
  });

  testWidgets('load failure → full-page error with retry', (tester) async {
    invoiceRepository.fail = true;
    await pump(tester);

    expect(find.text('Gagal memuat invoice. Coba lagi.'), findsOneWidget);

    invoiceRepository.fail = false;
    await tester.tap(find.text('Coba lagi'));
    await _settle(tester);

    expect(find.text('TS-fin1'), findsOneWidget);
  });

  for (final (size, scale) in [
    (const Size(320, 568), 1.0),
    (const Size(360, 640), 1.3),
    (const Size(412, 915), 1.3),
  ]) {
    testWidgets('no overflow at ${size.width.toInt()}×${size.height.toInt()} '
        '×$scale', (tester) async {
      invoiceRepository.paid = true;
      await pump(tester, size: size, textScale: scale);

      expect(tester.takeException(), isNull);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -600),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
}
