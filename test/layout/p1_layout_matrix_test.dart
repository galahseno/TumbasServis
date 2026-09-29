import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/login/login_page.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/onboarding_page.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_page.dart';
import 'package:tumbas_servis/auth/presentation/splash/splash_page.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/voucher/voucher_page.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/detail_bengkel_page.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/state/detail_bengkel_state.dart';

import '../support/fake_booking_repository.dart';
import '../support/fake_catalog_repository.dart';
import '../support/fake_clock.dart';
import '../support/fake_garage_repository.dart';
import '../support/fake_session_repository.dart';
import '../support/fake_workshop_repository.dart';

const _phoneSizes = [
  Size(360, 640),
  Size(360, 800),
  Size(393, 852),
  Size(412, 915),
];
const _textScales = [1.0, 1.3];

const _jaya = Workshop(
  id: 'ws_001',
  name: 'Bengkel Jaya Motor Sejahtera Abadi',
  rating: 4.8,
  reviewCount: 126,
  distanceKm: 1.2,
  address: 'Jl. Melati Raya No. 12, Sleman, DI Yogyakarta',
  openTime: 8,
  closeTime: 17,
  bayCount: 2,
  staticMapAssetPath: 'assets/images/maps/ws_001_map.png',
  serviceIds: ['svc_berkala', 'svc_rem'],
);

const _svcBerkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala dan Ganti Oli Mesin Lengkap',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

const _svcRem = ServiceType(
  id: 'svc_rem',
  name: 'Servis Rem & Keluhan Khusus',
  price: 120000,
  durationMin: 90,
  requiresComplaint: true,
);

final _parts = [
  for (final (i, category) in katalogCategories.skip(1).indexed)
    for (var j = 0; j < 3; j++)
      Part(
        id: 'part_${i}_$j',
        name: 'AHM $category Sintetik Premium Edisi Panjang ${j + 1}',
        category: category,
        brand: 'AHM',
        grade: 'MPX2',
        price: 70000 + j * 15000,
        compatibleModelIds: const ['model_x'],
      ),
];

const _motor = Motor(
  id: 'm_vario',
  ownerId: 'u1',
  nickname: 'Vario 125 Kesayangan Keluarga',
  plateNumber: 'AB 1234 XY',
  modelId: 'model_x',
);

final _vouchers = [
  Voucher(
    id: 'v-diskon10',
    code: 'DISKON10',
    label: 'Diskon 10% servis ≥2 motor',
    discountType: DiscountType.percent,
    discountValue: 10,
    minUnits: 2,
    validUntil: DateTime(2099),
  ),
  Voucher(
    id: 'v-hemat',
    code: 'HEMAT25',
    label: 'Potongan Rp25.000 untuk servis pertama di bengkel mitra',
    discountType: DiscountType.flat,
    discountValue: 25000,
    minSubtotal: 500000,
    validUntil: DateTime(2099),
  ),
];

BookingDraft _draft() => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: const ['m_vario'],
  unitConfigs: const {
    'm_vario': UnitConfig(
      serviceIds: ['svc_berkala', 'svc_rem'],
      partIds: ['part_0_0'],
      complaintNote: 'Rem belakang bunyi saat dingin dan getar di kecepatan.',
    ),
  },
  workshopId: 'ws_001',
  scheduleMode: ScheduleMode.shared,
  sharedSlot: TimeSlot(
    date: DateTime(2026, 9, 29),
    hour: 9,
    capacity: 5,
    booked: 1,
  ),
  unitSlots: const {},
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

List<Override> _fakes() {
  final booking = FakeBookingRepository()
    ..createDraftResult = Result.ok(_draft())
    ..bookingsResult = const Result.ok([]);
  final workshops = FakeWorkshopRepository()
    ..workshopResult = const Result.ok(_jaya)
    ..workshopsResult = const Result.ok([_jaya])
    ..availableSlotsResult = Result.ok([
      for (var h = 8; h <= 16; h++)
        TimeSlot(date: DateTime(2026, 9, 29), hour: h, capacity: 5, booked: 1),
    ]);
  final garage = FakeGarageRepository()
    ..motorsResult = const Result.ok([_motor]);
  final catalog = FakeCatalogRepository()
    ..serviceTypesResult = const Result.ok([_svcBerkala, _svcRem])
    ..partsResult = Result.ok(_parts)
    ..vouchersResult = Result.ok(_vouchers);
  return [
    bookingRepositoryProvider.overrideWithValue(booking),
    workshopRepositoryProvider.overrideWithValue(workshops),
    garageRepositoryProvider.overrideWithValue(garage),
    catalogRepositoryProvider.overrideWithValue(catalog),
    sessionRepositoryProvider.overrideWithValue(FakeSessionRepository()),
    clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 28, 10, 20))),
  ];
}

void Function(FlutterErrorDetails)? _previousOnError;

List<FlutterErrorDetails> _captureErrors() {
  final errors = <FlutterErrorDetails>[];
  _previousOnError = FlutterError.onError;
  FlutterError.onError = errors.add;
  return errors;
}

void _expectClean(List<FlutterErrorDetails> errors) {
  FlutterError.onError = _previousOnError;
  expect(
    errors,
    isEmpty,
    reason: errors
        .map(
          (e) => e
              .toString(minLevel: DiagnosticLevel.summary)
              .split('\n')
              .take(14)
              .join('\n'),
        )
        .join('\n---\n'),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  Future<void> pumpScreen(
    WidgetTester tester,
    Widget screen, {
    required Size size,
    required double scale,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: _fakes(),
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: screen,
        ),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  final screens = <String, Widget Function()>{
    'S02 Onboarding': OnboardingPage.new,
    'S03 Login': LoginPage.new,
    'S12 Katalog browse': () => const KatalogPage(mode: KatalogMode.browse),
    'S12 Katalog select': () => const KatalogPage(
      mode: KatalogMode.select,
      selectArgs: KatalogSelectArgs(
        modelId: 'model_x',
        initialPartIds: ['part_0_0'],
        unitNickname: 'Vario 125 Kesayangan Keluarga',
        unitPlateNumber: 'AB 1234 XY',
      ),
    ),
    'S14 Detail bengkel (in flow)': () => const DetailBengkelPage(
      workshopId: 'ws_001',
      variant: WorkshopDetailVariant.inFlow,
    ),
    'S14 Detail bengkel (standalone)': () => const DetailBengkelPage(
      workshopId: 'ws_001',
      variant: WorkshopDetailVariant.standalone,
    ),
    'S17 Voucher': VoucherPage.new,
  };

  for (final entry in screens.entries) {
    for (final size in _phoneSizes) {
      for (final scale in _textScales) {
        testWidgets('${entry.key} ${size.width.toInt()}×${size.height.toInt()} '
            '@ text ×$scale: no overflow', (tester) async {
          final errors = _captureErrors();
          await pumpScreen(tester, entry.value(), size: size, scale: scale);

          _expectClean(errors);
        });
      }
    }
  }

  for (final size in _phoneSizes) {
    for (final scale in _textScales) {
      testWidgets('S01 Splash ${size.width.toInt()}×${size.height.toInt()} '
          '@ text ×$scale: no overflow', (tester) async {
        final errors = _captureErrors();
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ProviderScope(
            overrides: _fakes(),
            child: MaterialApp(
              theme: AppTheme.light,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: const SplashPage(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 450));

        _expectClean(errors);
        await tester.pumpWidget(const SizedBox.shrink());
      });

      testWidgets('S04 OTP ${size.width.toInt()}×${size.height.toInt()} '
          '@ text ×$scale: no overflow', (tester) async {
        final errors = _captureErrors();
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final router = GoRouter(
          initialLocation: '/otp',
          initialExtra: '81234567890',
          routes: [GoRoute(path: '/otp', builder: (_, _) => const OtpPage())],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: _fakes(),
            child: MaterialApp.router(
              theme: AppTheme.light,
              routerConfig: router,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
            ),
          ),
        );
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }

        _expectClean(errors);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
