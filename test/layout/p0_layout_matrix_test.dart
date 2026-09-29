import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_page.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/ringkasan_page.dart';
import 'package:tumbas_servis/booking/presentation/tiket/tiket_page.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/pilih_bengkel_page.dart';

import '../support/fake_booking_repository.dart';
import '../support/fake_catalog_repository.dart';
import '../support/fake_clock.dart';
import '../support/fake_garage_repository.dart';
import '../support/fake_session_repository.dart';
import '../support/fake_workshop_repository.dart';
import '../support/home_screen_fake_overrides.dart';

/// PRD 06 phone device matrix × text scale for the dense/changed P0 screens.
const _phoneSizes = [
  Size(360, 640),
  Size(360, 800),
  Size(393, 852),
  Size(412, 915),
];
const _textScales = [1.0, 1.3];

const _jaya = Workshop(
  id: 'ws_001',
  name: 'Bengkel Jaya Motor',
  rating: 4.8,
  reviewCount: 126,
  distanceKm: 1.2,
  address: 'Jl. Melati Raya No. 12, Sleman, DI Yogyakarta',
  openTime: 8,
  closeTime: 17,
  bayCount: 2,
  staticMapAssetPath: 'assets/images/maps/ws_001_map.png',
  serviceIds: ['svc_berkala'],
);

const _svcBerkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
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

const _oil = Part(
  id: 'part_oil',
  name: 'AHM Oli MPX2 Sintetik Premium 0.8L',
  category: 'oli',
  brand: 'AHM',
  grade: 'MPX2',
  price: 70000,
  compatibleModelIds: ['model_x'],
);

Motor _motor(String id, String nickname, String plate) => Motor(
  id: id,
  ownerId: 'u1',
  nickname: nickname,
  plateNumber: plate,
  modelId: 'model_x',
);

final _vario = _motor('m_vario', 'Vario 125 Kesayangan', 'AB 1234 XY');
final _beat = _motor('m_beat', 'Beat 110', 'AB 5678 ZZ');
final _pcx = _motor('m_pcx', 'PCX 160', 'AB 9012 QR');

final _voucher = Voucher(
  id: 'v-diskon10',
  code: 'DISKON10',
  label: 'Diskon 10% servis ≥2 motor',
  discountType: DiscountType.percent,
  discountValue: 10,
  minUnits: 2,
  validUntil: DateTime(2099),
);

final _slot = TimeSlot(
  date: DateTime(2026, 9, 29),
  hour: 9,
  capacity: 5,
  booked: 1,
);

BookingDraft _draft({
  List<String> motors = const ['m_vario', 'm_beat', 'm_pcx'],
  bool withWorkshop = true,
}) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: motors,
  unitConfigs: {
    for (final id in motors)
      id: const UnitConfig(
        serviceIds: ['svc_berkala', 'svc_rem'],
        partIds: ['part_oil'],
        complaintNote: 'Rem belakang bunyi saat dingin dan getar di kecepatan.',
      ),
  },
  workshopId: withWorkshop ? 'ws_001' : null,
  scheduleMode: ScheduleMode.shared,
  sharedSlot: withWorkshop ? _slot : null,
  unitSlots: const {},
  voucherId: 'v-diskon10',
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

Booking _booking() => Booking(
  id: 'bk_1',
  code: 'TS-260929-0417',
  userId: 'u1',
  workshopId: 'ws_001',
  units: [
    for (final (i, m) in [_vario, _beat, _pcx].indexed)
      BookingUnit(
        unitCode: '-${String.fromCharCode(65 + i)}',
        motorId: m.id,
        motorSnapshot: m,
        serviceIds: const ['svc_berkala'],
        partIds: const [],
        status: UnitStatus.terjadwal,
        statusHistory: [
          StatusEvent(
            status: UnitStatus.terjadwal,
            timestamp: DateTime(2026, 9, 28),
          ),
        ],
        subtotal: 85000,
        durationMin: 60,
      ),
  ],
  scheduleMode: ScheduleMode.shared,
  sharedSlot: _slot,
  status: BookingStatus.terjadwal,
  voucherId: 'v-diskon10',
  subtotal: 255000,
  discount: 25500,
  total: 229500,
  createdAt: DateTime(2026, 9, 28),
);

List<Override> _fakes() {
  final booking = FakeBookingRepository()
    ..createDraftResult = Result.ok(_draft())
    ..bookingsResult = const Result.ok([])
    ..getBookingResult = Result.ok(_booking());
  final workshops = FakeWorkshopRepository()
    ..workshopResult = const Result.ok(_jaya)
    ..workshopsResult = const Result.ok([_jaya])
    ..availableSlotsResult = Result.ok([
      for (var h = 8; h <= 16; h++)
        TimeSlot(
          date: DateTime(2026, 9, 29),
          hour: h,
          capacity: 5,
          booked: h == 10 ? 4 : 1,
        ),
    ]);
  final garage = FakeGarageRepository()
    ..motorsResult = Result.ok([_vario, _beat, _pcx]);
  final catalog = FakeCatalogRepository()
    ..serviceTypesResult = const Result.ok([_svcBerkala, _svcRem])
    ..partsResult = const Result.ok([_oil])
    ..vouchersResult = Result.ok([_voucher]);
  return [
    bookingRepositoryProvider.overrideWithValue(booking),
    workshopRepositoryProvider.overrideWithValue(workshops),
    garageRepositoryProvider.overrideWithValue(garage),
    catalogRepositoryProvider.overrideWithValue(catalog),
    clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 28, 10, 20))),
  ];
}

/// Captures framework errors so a failure names the overflowing widget, not
/// just "overflowed by N pixels". Restore happens in [_expectClean] (before
/// `expect`, as the test binding requires).
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
    // Latency-free fakes: a few frames settle loading → data.
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  final screens = <String, Widget Function()>{
    'S10 Pilih motor': PilihMotorPage.new,
    'S11 Detail servis': DetailServisPage.new,
    'S13 Pilih bengkel': PilihBengkelPage.new,
    'S15 Pilih jadwal': PilihJadwalPage.new,
    'S16 Ringkasan': RingkasanPage.new,
    'S18 Tiket': () => const TiketPage(bookingId: 'bk_1'),
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
      testWidgets('S05 Home ${size.width.toInt()}×${size.height.toInt()} '
          '@ text ×$scale: no overflow', (tester) async {
        final errors = _captureErrors();
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final container = ProviderContainer(
          overrides: [
            sessionRepositoryProvider.overrideWithValue(
              FakeSessionRepository()
                ..currentUserResult = Result.ok(
                  User(id: 'u1', name: 'Budi', phone: '0812'),
                ),
            ),
            ...homeScreenFakeOverrides(),
          ],
        );
        addTearDown(container.dispose);
        final router = container.read(routerProvider);
        router.go(Routes.home);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
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
      });
    }
  }

  testWidgets('S12 Katalog empty state with keyboard open (≈300dp inset): '
      'no overflow', (tester) async {
    // Covered at component level in empty_state_test.dart; this guards the
    // real page composition (title row + search + chips + toggle + empty).
    final errors = _captureErrors();
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);

    final catalog = FakeCatalogRepository()
      ..partsResult = const Result.ok([_oil]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(catalog),
          garageRepositoryProvider.overrideWithValue(
            FakeGarageRepository()..motorsResult = Result.ok([_vario]),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const _KatalogHost()),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.enterText(find.byType(TextField), 'zzz-tidak-ada');
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tidak ada suku cadang'), findsOneWidget);
    _expectClean(errors);
  });
}

class _KatalogHost extends StatelessWidget {
  const _KatalogHost();

  @override
  Widget build(BuildContext context) => const KatalogPage(
    mode: KatalogMode.select,
    selectArgs: KatalogSelectArgs(
      modelId: 'model_x',
      initialPartIds: [],
      unitNickname: 'Vario 125',
      unitPlateNumber: 'AB 1234 XY',
    ),
  );
}
