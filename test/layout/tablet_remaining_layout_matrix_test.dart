import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/auth/presentation/login/login_page.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/onboarding_page.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_page.dart';
import 'package:tumbas_servis/auth/presentation/splash/splash_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/motor_form_page.dart';

import '../support/fake_booking_repository.dart';
import '../support/fake_catalog_repository.dart';
import '../support/fake_invoice_repository.dart';
import '../support/fake_notification_repository.dart';
import '../support/invoice_review_fixtures.dart';
import '../support/layout_test_harness.dart';
import '../support/notification_fixtures.dart';
import '../support/garage_fixtures.dart';
import '../support/tablet_layout_support.dart';

class _Case {
  const _Case.page(this.screen, {this.extra})
    : location = null,
      overrides = null;
  const _Case.shell(this.location, {this.overrides})
    : screen = null,
      extra = null;

  final Widget Function()? screen;
  final String? location;
  final Object? extra;
  final List<Override> Function()? overrides;
}

List<Override> _finishedOverrides({required bool paid}) => richAppOverrides(
  bookingRepository: FakeBookingRepository()
    ..bookingsResult = Result.ok([canonicalFinishedBooking()])
    ..getBookingResult = Result.ok(canonicalFinishedBooking()),
  invoiceRepository: FakeInvoiceRepository()
    ..lines = canonicalInvoiceLines
    ..discount = 42800
    ..paid = paid
    ..issuedAt = DateTime(2026, 9, 29, 11, 8),
  catalogRepository: FakeCatalogRepository()
    ..vouchersResult = Result.ok([voucherDiskon10]),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
    await loadAppFonts();
  });

  final cases = <String, _Case>{
    'S01 Splash': _Case.page(SplashPage.new),
    'S02 Onboarding': _Case.page(OnboardingPage.new),
    'S03 Login': _Case.page(LoginPage.new),
    'S04 OTP': _Case.page(OtpPage.new, extra: '81234567890'),
    'S05 Beranda': const _Case.shell(Routes.home),
    'S06 Notifikasi': _Case.shell(
      Routes.notifications,
      overrides: () => richAppOverrides(
        notificationRepository: FakeNotificationRepository(
          notifications: designNotifications(),
        ),
      ),
    ),
    'S07 Garasi': const _Case.shell(Routes.garage),
    'S08 Tambah motor': const _Case.shell(Routes.garageAdd),
    'S08 Edit motor': _Case.page(
      () => MotorFormPage(existingMotor: motorFixture('m2')),
    ),
    'S09 Detail motor (dalam servis)': _Case.shell(Routes.garageDetail('m2')),
    'S09 Detail motor (bebas)': _Case.shell(Routes.garageDetail('m4')),
    'S12 Katalog (jelajah)': _Case.page(
      () => const KatalogPage(mode: KatalogMode.browse),
    ),
    'S12 Katalog (pilih)': _Case.page(
      () => const KatalogPage(
        mode: KatalogMode.select,
        selectArgs: KatalogSelectArgs(
          modelId: 'model_beat',
          initialPartIds: ['part_0_0'],
          unitNickname: 'Beat 110',
          unitPlateNumber: 'AB 5678 ZZ',
        ),
      ),
    ),
    'S19 Riwayat': const _Case.shell(Routes.bookings),
    'S20 Detail booking': _Case.shell(Routes.bookingDetail('bk1')),
    'S21 Lacak unit': _Case.shell(Routes.bookingUnitDetail('bk1', '-A')),
    'S25 Profil': const _Case.shell(Routes.profile),
    'S26 Mode demo': const _Case.shell(Routes.profileDemoMode),
    'S23 Invoice (belum dibayar)': _Case.shell(
      Routes.invoice('fin1'),
      overrides: () => _finishedOverrides(paid: false),
    ),
    'S23 Invoice (lunas)': _Case.shell(
      Routes.invoice('fin1'),
      overrides: () => _finishedOverrides(paid: true),
    ),
    'S24 Beri ulasan': _Case.shell(
      Routes.review('fin1'),
      overrides: () => _finishedOverrides(paid: true),
    ),
  };

  Future<void> pump(
    WidgetTester tester,
    _Case c, {
    required Size size,
    required double scale,
    int settleFrames = 20,
  }) async {
    final overrides = c.overrides?.call();
    if (c.location != null) {
      await pumpShellRoute(
        tester,
        c.location!,
        size: size,
        scale: scale,
        overrides: overrides,
        settleFrames: settleFrames,
      );
    } else {
      await pumpRoutedScreen(
        tester,
        c.screen!(),
        size: size,
        scale: scale,
        extra: c.extra,
        overrides: overrides,
        settleFrames: settleFrames,
      );
    }
  }

  for (final entry in cases.entries) {
    for (final size in tabletTestSizes) {
      for (final scale in tabletTestScales) {
        testWidgets('${entry.key} ${size.width.toInt()}×${size.height.toInt()} '
            '@ text ×$scale: no overflow', (tester) async {
          final errors = captureLayoutErrors();
          await pump(tester, entry.value, size: size, scale: scale);
          expectNoLayoutErrors(errors);
          await unmountScreen(tester);
        });
      }
    }
  }

  for (final entry in cases.entries) {
    for (final size in tabletTestSizes) {
      testWidgets('${entry.key} ${size.width.toInt()}×${size.height.toInt()} '
          'loading: no overflow', (tester) async {
        final errors = captureLayoutErrors();
        await pump(
          tester,
          entry.value,
          size: size,
          scale: 1.3,
          settleFrames: 0,
        );
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 20));
        }
        expectNoLayoutErrors(errors);
        await unmountScreen(tester);
      });
    }
  }
}
