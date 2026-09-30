import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/demo_reset_service.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/core/presentation/di/core_presentation_module.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import 'fake_booking_repository.dart';
import 'fake_catalog_repository.dart';
import 'fake_clock.dart';
import 'fake_garage_repository.dart';
import 'fake_invoice_repository.dart';
import 'fake_notification_repository.dart';
import 'fake_review_repository.dart';
import 'fake_logout_handler.dart';
import 'fake_session_repository.dart';
import 'fake_settings_repository.dart';
import 'fake_tracking_repository.dart';
import 'fake_workshop_repository.dart';
import 'garage_fixtures.dart';
import 'layout_test_harness.dart';
import 'noop_demo_content_seeder.dart';
import 'tracking_fixtures.dart';

const tabletTestSizes = [
  Size(800, 1280),
  Size(1280, 800),
  Size(1024, 768),
  Size(673, 841),
];
const tabletTestScales = [1.0, 1.3];

final _now = DateTime(2026, 9, 29, 9, 30);

List<Part> richParts() => [
  for (final (i, category) in katalogCategories.skip(1).indexed)
    for (var j = 0; j < 3; j++)
      Part(
        id: 'part_${i}_$j',
        name: 'AHM $category Sintetik Premium ${j + 1}',
        category: category,
        brand: 'AHM',
        grade: 'MPX2',
        price: 70000 + j * 15000,
        compatibleModelIds: j == 2
            ? const ['model_other']
            : const ['model_beat'],
      ),
];

const _motorModels = [
  MotorModel(
    id: 'model_beat',
    brand: MotorBrand.honda,
    name: 'Beat 110',
    category: MotorCategory.matic,
    cc: 110,
  ),
  MotorModel(
    id: 'model_vario',
    brand: MotorBrand.honda,
    name: 'Vario 125',
    category: MotorCategory.matic,
    cc: 125,
  ),
  MotorModel(
    id: 'model_mio',
    brand: MotorBrand.yamaha,
    name: 'Mio M3 125',
    category: MotorCategory.matic,
    cc: 125,
  ),
];

bool _fontsLoaded = false;

Future<void> loadAppFonts() async {
  if (_fontsLoaded) return;
  final loader = FontLoader('Exo 2')
    ..addFont(rootBundle.load('assets/fonts/Exo2-Variable.ttf'));
  await loader.load();
  _fontsLoaded = true;
}

List<Override> richAppOverrides({
  FakeBookingRepository? bookingRepository,
  FakeGarageRepository? garageRepository,
  FakeNotificationRepository? notificationRepository,
  FakeInvoiceRepository? invoiceRepository,
  FakeReviewRepository? reviewRepository,
  FakeCatalogRepository? catalogRepository,
  FakeSettingsRepository? settingsRepository,
  DemoContentSeeder? seeder,
}) {
  final motors = [
    motorFixture('m1', nickname: 'Vario 125', plate: 'AB 1234 XY'),
    motorFixture('m2', nickname: 'Beat 110', plate: 'AB 5678 ZZ'),
    motorFixture('m3', nickname: 'PCX 160', plate: 'AB 9012 QR'),
    motorFixture('m4', nickname: 'Supra X 125', plate: 'AB 3344 KL'),
  ];
  final running = trackedBooking('bk1', [
    trackedUnit(
      '-A',
      UnitStatus.dikerjakan,
      motorId: 'm1',
      nickname: 'Vario 125',
    ),
    trackedUnit(
      '-B',
      UnitStatus.dikerjakan,
      motorId: 'm2',
      nickname: 'Beat 110',
    ),
    trackedUnit('-C', UnitStatus.diperiksa, motorId: 'm3', nickname: 'PCX 160'),
  ]);
  final history = [
    for (var i = 1; i <= 4; i++)
      trackedBooking('hist$i', [
        trackedUnit(
          '-A',
          i.isEven ? UnitStatus.dibatalkan : UnitStatus.selesai,
          motorId: 'm2',
          nickname: 'Beat 110',
        ),
      ], createdAt: DateTime(2026, 7, i)),
  ];
  final bookings =
      bookingRepository ??
      (_StatusFilteringBookingRepository()
        ..bookingsResult = Result.ok([running, ...history])
        ..getBookingResult = Result.ok(running)
        ..currentDraftResult = Result.ok(
          BookingDraft(
            id: 'draft_1',
            selectedMotorIds: const ['m4'],
            unitConfigs: const {
              'm4': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
            },
            scheduleMode: ScheduleMode.shared,
            unitSlots: const {},
            createdAt: _now.subtract(const Duration(hours: 2)),
            expiresAt: _now.add(const Duration(hours: 22)),
          ),
        ));
  final garage =
      garageRepository ??
      (FakeGarageRepository()
        ..motorsResult = Result.ok(motors)
        ..motorModelsResult = const Result.ok(_motorModels));
  final catalog =
      catalogRepository ??
      (FakeCatalogRepository()
        ..serviceTypesResult = const Result.ok(serviceFixtures)
        ..partsResult = Result.ok(richParts())
        ..promosResult = const Result.ok([
          Promo(
            id: 'promo_diskon10',
            title: 'Diskon 10% untuk servis 2 motor atau lebih',
            imageAssetPath: '',
          ),
          Promo(
            id: 'promo_multi_motor',
            title: 'Servis 5 motor sekaligus',
            imageAssetPath: '',
          ),
          Promo(
            id: 'promo_servis_reminder',
            title: 'Waktunya servis berkala',
            imageAssetPath: '',
          ),
        ]));
  return [
    sessionRepositoryProvider.overrideWithValue(
      FakeSessionRepository()
        ..currentUserResult = Result.ok(
          User(id: 'user_001', name: 'Galah', phone: '81234567890'),
        ),
    ),
    bookingRepositoryProvider.overrideWithValue(bookings),
    garageRepositoryProvider.overrideWithValue(garage),
    catalogRepositoryProvider.overrideWithValue(catalog),
    workshopRepositoryProvider.overrideWithValue(
      FakeWorkshopRepository()
        ..workshopsResult = const Result.ok([workshopFixture])
        ..workshopResult = const Result.ok(workshopFixture)
        ..mechanicsResult = const Result.ok(mechanicFixtures)
        ..availableSlotsResult = Result.ok([
          for (var h = 8; h <= 16; h++)
            TimeSlot(
              date: DateTime(2026, 9, 29),
              hour: h,
              capacity: 5,
              booked: 1,
            ),
        ]),
    ),
    notificationRepositoryProvider.overrideWithValue(
      notificationRepository ?? (FakeNotificationRepository()..unreadCount = 2),
    ),
    trackingRepositoryProvider.overrideWithValue(FakeTrackingRepository()),
    invoiceRepositoryProvider.overrideWithValue(
      invoiceRepository ?? FakeInvoiceRepository(),
    ),
    reviewRepositoryProvider.overrideWithValue(
      reviewRepository ?? FakeReviewRepository(),
    ),
    clockProvider.overrideWithValue(FakeClock(_now)),
    demoContentSeederProvider.overrideWithValue(
      seeder ?? NoopDemoContentSeeder(),
    ),
    settingsRepositoryProvider.overrideWithValue(
      settingsRepository ?? FakeSettingsRepository(),
    ),
    logoutHandlerProvider.overrideWithValue(FakeLogoutHandler()),
    demoModeControllerProvider.overrideWithValue(DemoModeController()),
    demoResetServiceProvider.overrideWithValue(_NoopResetService()),
  ];
}

Widget _scaled(double scale, Widget? child) => Builder(
  builder: (context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
);

class _StatusFilteringBookingRepository extends FakeBookingRepository {
  @override
  Future<Result<List<Booking>>> getBookings({BookingStatus? status}) async {
    final all = await super.getBookings();
    if (status == null || all is! Ok<List<Booking>>) return all;
    return Result.ok([
      for (final booking in all.value)
        if (booking.status == status) booking,
    ]);
  }
}

final _liveContainers = <ProviderContainer>[];

ProviderContainer _newContainer(List<Override> overrides) {
  final container = ProviderContainer(overrides: overrides);
  _liveContainers.add(container);
  addTearDown(() {
    if (_liveContainers.remove(container)) container.dispose();
  });
  return container;
}

Future<ProviderContainer> pumpShellRoute(
  WidgetTester tester,
  String location, {
  required Size size,
  required double scale,
  List<Override>? overrides,
  int settleFrames = 20,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final container = _newContainer(overrides ?? richAppOverrides());
  final router = container.read(routerProvider);
  router.go(location);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
        builder: (context, child) => _scaled(scale, child),
      ),
    ),
  );
  for (var i = 0; i < settleFrames; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return container;
}

Future<ProviderContainer> pumpRoutedScreen(
  WidgetTester tester,
  Widget screen, {
  required Size size,
  required double scale,
  Object? extra,
  List<Override>? overrides,
  int settleFrames = 20,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/screen',
    initialExtra: extra,
    routes: [
      GoRoute(path: '/screen', builder: (_, _) => screen),
      GoRoute(path: '/:rest(.*)', builder: (_, _) => const SizedBox()),
    ],
  );
  addTearDown(router.dispose);
  final container = _newContainer(overrides ?? richAppOverrides());

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
        builder: (context, child) => _scaled(scale, child),
      ),
    ),
  );
  for (var i = 0; i < settleFrames; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return container;
}

Future<void> expectNoLayoutErrorsDuring(Future<void> Function() body) async {
  final errors = captureLayoutErrors();
  try {
    await body();
  } catch (_) {
    try {
      expectNoLayoutErrors(errors);
    } on Object {
      // The original failure is the one worth reporting.
    }
    rethrow;
  }
  expectNoLayoutErrors(errors);
}

Future<void> unmountScreen(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  for (final container in List.of(_liveContainers)) {
    _liveContainers.remove(container);
    container.dispose();
  }
  await tester.pump(const Duration(seconds: 1));
}

class _NoopResetService implements DemoResetService {
  @override
  Future<void> reset() async {}
}
