import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/presentation/components/auth_hero.dart';
import 'package:tumbas_servis/auth/presentation/login/login_page.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/onboarding_page.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_page.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/presentation/components/confirm_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_text_field.dart';
import 'package:tumbas_servis/core/presentation/components/vehicle_select_card.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/components/motor_preview_pane.dart';
import 'package:tumbas_servis/home/presentation/home/components/promo_carousel.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/invoice_summary_card.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/components/demo_preview_pane.dart';
import 'package:tumbas_servis/profile/presentation/profil/components/theme_preview.dart';
import 'package:tumbas_servis/review/presentation/ulasan/components/review_recap.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/detail_booking_page.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/components/mechanic_card.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/components/status_timeline.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/components/booking_history_card.dart';

import '../support/fake_booking_repository.dart';
import '../support/fake_invoice_repository.dart';
import '../support/invoice_review_fixtures.dart';
import '../support/tablet_layout_support.dart';
import '../support/tracking_fixtures.dart';

const _medium = Size(800, 1280);
const _expanded = Size(1024, 768);
const _large = Size(1280, 800);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
    await loadAppFonts();
  });

  Future<void> shell(WidgetTester tester, String location, Size size) async {
    await pumpShellRoute(tester, location, size: size, scale: 1);
  }

  Future<void> page(
    WidgetTester tester,
    Widget screen,
    Size size, {
    Object? extra,
  }) async {
    await pumpRoutedScreen(tester, screen, size: size, scale: 1, extra: extra);
  }

  group('S02 Onboarding', () {
    testWidgets('medium: 560 card with the copy under the art', (tester) async {
      await page(tester, const OnboardingPage(), _medium);
      expect(tester.getSize(find.byType(TsButton).first).width, lessThan(520));
      await unmountScreen(tester);
    });

    testWidgets('large: copy left, art panel right', (tester) async {
      await page(tester, const OnboardingPage(), _large);
      final button = tester.getCenter(find.byType(TsButton).first);
      final art = tester.getCenter(find.byType(PageView));
      expect(button.dx, lessThan(_large.width / 2));
      expect(art.dx, greaterThan(_large.width / 2));
      await unmountScreen(tester);
    });
  });

  group('S03 / S04 Auth', () {
    testWidgets('medium: centered card, no brand panel', (tester) async {
      await page(tester, const LoginPage(), _medium);
      expect(find.byType(AuthHero), findsNothing);
      expect(tester.getSize(find.byType(TsButton).first).width, lessThan(420));
      await unmountScreen(tester);
    });

    testWidgets('expanded + large: form left, AuthHero right', (tester) async {
      for (final size in [_expanded, _large]) {
        await page(tester, const LoginPage(), size);
        expect(find.byType(AuthHero), findsOneWidget);
        final form = tester.getCenter(find.byType(TsButton).first);
        expect(form.dx, lessThan(size.width / 2));
        await unmountScreen(tester);
      }
    });

    testWidgets('OTP follows the same medium / large split', (tester) async {
      await page(tester, const OtpPage(), _medium, extra: '81234567890');
      expect(find.byType(AuthHero), findsNothing);
      await unmountScreen(tester);
      await page(tester, const OtpPage(), _large, extra: '81234567890');
      expect(find.byType(AuthHero), findsOneWidget);
      await unmountScreen(tester);
    });
  });

  group('S05 Beranda', () {
    testWidgets('tablet: greeting sits in the app bar, Riwayat + Katalog '
        'tiles side by side, rail beside the content', (tester) async {
      await shell(tester, Routes.home, _medium);
      expect(find.text('Halo, Galah 👋'), findsOneWidget);
      final riwayat = tester.getTopLeft(find.text('Riwayat').last);
      final katalog = tester.getTopLeft(find.text('Katalog suku cadang'));
      expect(riwayat.dy, katalog.dy);
      expect(riwayat.dx, lessThan(katalog.dx));
      await unmountScreen(tester);
    });

    testWidgets('promo carousel is one-up on Tab-P and two-up on Tab-L', (
      tester,
    ) async {
      await shell(tester, Routes.home, _medium);
      expect(
        tester.widget<PromoCarousel>(find.byType(PromoCarousel)).perView,
        1,
      );
      await unmountScreen(tester);
      await shell(tester, Routes.home, _large);
      expect(
        tester.widget<PromoCarousel>(find.byType(PromoCarousel)).perView,
        2,
      );
      await unmountScreen(tester);
    });

    testWidgets('active booking and draft share a row', (tester) async {
      await shell(tester, Routes.home, _large);
      final active = tester.getTopLeft(find.text('Booking aktif').first);
      final draft = tester.getTopLeft(find.text('Lanjutkan booking'));
      expect(active.dy, closeTo(draft.dy, 40));
      expect(active.dx, lessThan(draft.dx));
      await unmountScreen(tester);
    });
  });

  group('S07 Garasi', () {
    Iterable<double> rowTops(WidgetTester tester) => tester
        .widgetList(find.byType(VehicleSelectCard))
        .map((w) => tester.getTopLeft(find.byWidget(w)).dy);

    testWidgets('medium: 2 columns', (tester) async {
      await shell(tester, Routes.garage, _medium);
      final tops = rowTops(tester).toList();
      expect(tops.where((y) => y == tops.first), hasLength(2));
      await unmountScreen(tester);
    });

    testWidgets('expanded + large: 3 columns', (tester) async {
      for (final size in [_expanded, _large]) {
        await shell(tester, Routes.garage, size);
        final tops = rowTops(tester).toList();
        expect(tops.where((y) => y == tops.first), hasLength(3));
        await unmountScreen(tester);
      }
    });
  });

  group('S08 Tambah / ubah motor', () {
    testWidgets('medium: form only', (tester) async {
      await shell(tester, Routes.garageAdd, _medium);
      expect(find.byType(MotorPreviewPane), findsNothing);
      await unmountScreen(tester);
    });

    testWidgets('large: live preview follows the typed nickname', (
      tester,
    ) async {
      await shell(tester, Routes.garageAdd, _large);
      expect(find.byType(MotorPreviewPane), findsOneWidget);
      expect(find.text('Nama motor'), findsOneWidget);

      await tester.enterText(
        find.descendant(
          of: find.widgetWithText(TsTextField, 'Nama panggilan'),
          matching: find.byType(TextField),
        ),
        'Vario 125',
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.descendant(
          of: find.byType(MotorPreviewPane),
          matching: find.text('Vario 125'),
        ),
        findsOneWidget,
      );
      await unmountScreen(tester);
    });
  });

  group('S09 Detail motor', () {
    testWidgets('large: hero + CTA left, details + history right', (
      tester,
    ) async {
      await shell(tester, Routes.garageDetail('m2'), _large);
      final cta = tester.getTopLeft(find.text('Booking motor ini'));
      final details = tester.getTopLeft(find.text('Riwayat servis'));
      expect(cta.dx, lessThan(details.dx));
      await unmountScreen(tester);
    });

    testWidgets('medium: stacked', (tester) async {
      await shell(tester, Routes.garageDetail('m2'), _medium);
      final cta = tester.getTopLeft(find.byType(TsButton).first);
      final details = tester.getTopLeft(find.text('Riwayat servis'));
      expect(cta.dx, closeTo(details.dx, 4));
      expect(cta.dy, lessThan(details.dy));
      await unmountScreen(tester);
    });
  });

  group('S19 Riwayat / S20 Detail', () {
    List<dynamic> twoRunning() => richAppOverrides(
      bookingRepository: FakeBookingRepository()
        ..bookingsResult = Result.ok([
          trackedBooking('bkA', [
            trackedUnit('-A', UnitStatus.dikerjakan, motorId: 'm1'),
          ]),
          trackedBooking('bkB', [
            trackedUnit('-A', UnitStatus.dikerjakan, motorId: 'm2'),
          ]),
        ])
        ..getBookingResult = Result.ok(
          trackedBooking('bkA', [
            trackedUnit('-A', UnitStatus.dikerjakan, motorId: 'm1'),
          ]),
        ),
    );

    testWidgets('medium: single list, no preview pane', (tester) async {
      await pumpShellRoute(
        tester,
        Routes.bookings,
        size: _medium,
        scale: 1,
        overrides: List.of(twoRunning().cast()),
      );
      expect(find.byType(DetailBookingBody), findsNothing);
      await unmountScreen(tester);
    });

    testWidgets('large: first booking auto-selected, tap selects another', (
      tester,
    ) async {
      await pumpShellRoute(
        tester,
        Routes.bookings,
        size: _large,
        scale: 1,
        overrides: List.of(twoRunning().cast()),
      );
      expect(
        tester
            .widget<DetailBookingBody>(find.byType(DetailBookingBody))
            .bookingId,
        'bkA',
      );
      final cards = find.byType(BookingHistoryCard);
      expect(tester.widget<BookingHistoryCard>(cards.at(0)).selected, isTrue);

      await tester.tap(cards.at(1));
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        tester
            .widget<DetailBookingBody>(find.byType(DetailBookingBody))
            .bookingId,
        'bkB',
      );
      expect(tester.widget<BookingHistoryCard>(cards.at(1)).selected, isTrue);
      expect(find.text('Buka detail'), findsOneWidget);
      await unmountScreen(tester);
    });

    testWidgets('S20 large: overview left, unit list right', (tester) async {
      await shell(tester, Routes.bookingDetail('bk1'), _large);
      final header = tester.getTopLeft(find.text('TS-bk1'));
      final units = tester.getTopLeft(find.text('Status motor'));
      expect(header.dx, lessThan(units.dx));
      await unmountScreen(tester);
    });

    testWidgets('S20 medium: stacked', (tester) async {
      await shell(tester, Routes.bookingDetail('bk1'), _medium);
      final header = tester.getTopLeft(find.text('TS-bk1'));
      final units = tester.getTopLeft(find.text('Status motor'));
      expect(units.dy, greaterThan(header.dy));
      await unmountScreen(tester);
    });
  });

  group('S21 Lacak unit', () {
    testWidgets('large: timeline left, mechanic right', (tester) async {
      await shell(tester, Routes.bookingUnitDetail('bk1', '-A'), _large);
      final timeline = tester.getTopLeft(find.byType(StatusTimeline));
      final mechanic = tester.getTopLeft(find.byType(MechanicCard));
      expect(timeline.dx, lessThan(mechanic.dx));
      await unmountScreen(tester);
    });

    testWidgets('medium: single column', (tester) async {
      await shell(tester, Routes.bookingUnitDetail('bk1', '-A'), _medium);
      final timeline = tester.getTopLeft(find.byType(StatusTimeline));
      final mechanic = tester.getTopLeft(find.byType(MechanicCard));
      expect(mechanic.dy, greaterThan(timeline.dy));
      await unmountScreen(tester);
    });
  });

  group('S23 Invoice', () {
    List<dynamic> finished() => richAppOverrides(
      bookingRepository: FakeBookingRepository()
        ..getBookingResult = Result.ok(canonicalFinishedBooking()),
      invoiceRepository: FakeInvoiceRepository()
        ..lines = canonicalInvoiceLines
        ..discount = 42800,
    );

    testWidgets('medium: stacked with the bottom bar', (tester) async {
      await pumpShellRoute(
        tester,
        Routes.invoice('fin1'),
        size: _medium,
        scale: 1,
        overrides: List.of(finished().cast()),
      );
      expect(find.byType(InvoiceSummaryCard), findsNothing);
      expect(find.byType(ConfirmBar), findsOneWidget);
      await unmountScreen(tester);
    });

    testWidgets('large: summary card replaces the bar', (tester) async {
      await pumpShellRoute(
        tester,
        Routes.invoice('fin1'),
        size: _large,
        scale: 1,
        overrides: List.of(finished().cast()),
      );
      expect(find.byType(InvoiceSummaryCard), findsOneWidget);
      expect(find.byType(ConfirmBar), findsNothing);
      expect(tester.getSize(find.byType(InvoiceSummaryCard)).width, 360);
      await unmountScreen(tester);
    });
  });

  group('S24 Ulasan', () {
    List<dynamic> paid() => richAppOverrides(
      bookingRepository: FakeBookingRepository()
        ..getBookingResult = Result.ok(canonicalFinishedBooking()),
      invoiceRepository: FakeInvoiceRepository()
        ..lines = canonicalInvoiceLines
        ..paid = true,
    );

    testWidgets('medium: form only', (tester) async {
      await pumpShellRoute(
        tester,
        Routes.review('fin1'),
        size: _medium,
        scale: 1,
        overrides: List.of(paid().cast()),
      );
      expect(find.byType(ReviewRecap), findsNothing);
      await unmountScreen(tester);
    });

    testWidgets('large: live preview starts empty, then follows the stars', (
      tester,
    ) async {
      await pumpShellRoute(
        tester,
        Routes.review('fin1'),
        size: _large,
        scale: 1,
        overrides: List.of(paid().cast()),
      );
      expect(find.byType(ReviewRecap), findsOneWidget);
      expect(find.text('Ulasanmu akan tampil di sini'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel(RegExp('Nilai bengkel')).first);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Ulasanmu akan tampil di sini'), findsNothing);
      await unmountScreen(tester);
    });
  });

  group('S25 Profil', () {
    testWidgets('medium: menu only', (tester) async {
      await shell(tester, Routes.profile, _medium);
      expect(find.byType(ThemePreview), findsNothing);
      await unmountScreen(tester);
    });

    testWidgets('large: theme preview follows the segmented choice', (
      tester,
    ) async {
      await shell(tester, Routes.profile, _large);
      expect(find.byType(ThemePreview), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ThemePreview),
          matching: find.text('Sistem'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Gelap').first);
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.descendant(
          of: find.byType(ThemePreview),
          matching: find.text('Gelap'),
        ),
        findsOneWidget,
      );
      await unmountScreen(tester);
    });
  });

  group('S26 Mode demo', () {
    testWidgets('medium: controls only', (tester) async {
      await shell(tester, Routes.profileDemoMode, _medium);
      expect(find.byType(DemoPreviewPane), findsNothing);
      await unmountScreen(tester);
    });

    testWidgets('large: tapping a unit row previews its timeline', (
      tester,
    ) async {
      await shell(tester, Routes.profileDemoMode, _large);
      expect(find.byType(DemoPreviewPane), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(DemoPreviewPane),
          matching: find.textContaining('Unit -A'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.textContaining('-B Beat 110').first);
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        find.descendant(
          of: find.byType(DemoPreviewPane),
          matching: find.textContaining('Unit -B'),
        ),
        findsOneWidget,
      );
      expect(find.text('Dipratinjau'), findsOneWidget);
      await unmountScreen(tester);
    });
  });
}
