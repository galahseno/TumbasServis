import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
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
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import 'fake_booking_repository.dart';
import 'fake_catalog_repository.dart';
import 'fake_clock.dart';
import 'fake_garage_repository.dart';
import 'fake_workshop_repository.dart';

const layoutWorkshop = Workshop(
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

const layoutSvcBerkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

const layoutSvcRem = ServiceType(
  id: 'svc_rem',
  name: 'Servis Rem & Keluhan Khusus',
  price: 120000,
  durationMin: 90,
  requiresComplaint: true,
);

const layoutOil = Part(
  id: 'part_oil',
  name: 'AHM Oli MPX2 Sintetik Premium 0.8L',
  category: 'oli',
  brand: 'AHM',
  grade: 'MPX2',
  price: 70000,
  compatibleModelIds: ['model_x'],
);

Motor layoutMotor(String id, String nickname, String plate) => Motor(
  id: id,
  ownerId: 'u1',
  nickname: nickname,
  plateNumber: plate,
  modelId: 'model_x',
);

final layoutVario = layoutMotor(
  'm_vario',
  'Vario 125 Kesayangan',
  'AB 1234 XY',
);
final layoutBeat = layoutMotor('m_beat', 'Beat 110', 'AB 5678 ZZ');
final layoutPcx = layoutMotor('m_pcx', 'PCX 160', 'AB 9012 QR');

final layoutVoucher = Voucher(
  id: 'v-diskon10',
  code: 'DISKON10',
  label: 'Diskon 10% servis ≥2 motor',
  discountType: DiscountType.percent,
  discountValue: 10,
  minUnits: 2,
  validUntil: DateTime(2099),
);

final layoutSlot = TimeSlot(
  date: DateTime(2026, 9, 29),
  hour: 9,
  capacity: 5,
  booked: 1,
);

BookingDraft layoutDraft({
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
  sharedSlot: withWorkshop ? layoutSlot : null,
  unitSlots: const {},
  voucherId: 'v-diskon10',
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

Booking layoutBooking() => Booking(
  id: 'bk_1',
  code: 'TS-260929-0417',
  userId: 'u1',
  workshopId: 'ws_001',
  units: [
    for (final (i, m) in [layoutVario, layoutBeat, layoutPcx].indexed)
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
  sharedSlot: layoutSlot,
  status: BookingStatus.terjadwal,
  voucherId: 'v-diskon10',
  subtotal: 255000,
  discount: 25500,
  total: 229500,
  createdAt: DateTime(2026, 9, 28),
);

final layoutWorkshops = [
  layoutWorkshop,
  for (var i = 2; i <= 5; i++)
    Workshop(
      id: 'ws_00$i',
      name: 'Bengkel Sinar Motor Cabang Sleman Utara $i',
      rating: 4.5,
      reviewCount: 40 + i,
      distanceKm: 1.2 + i,
      address: 'Jl. Kaliurang Km $i No. 12, Sleman, DI Yogyakarta',
      openTime: 8,
      closeTime: 17,
      bayCount: 2,
      staticMapAssetPath: 'assets/images/maps/ws_001_map.png',
      serviceIds: const ['svc_berkala'],
    ),
];

List<Override> layoutFakes({List<Workshop>? workshops, BookingDraft? draft}) {
  final booking = FakeBookingRepository()
    ..createDraftResult = Result.ok(draft ?? layoutDraft())
    ..bookingsResult = const Result.ok([])
    ..getBookingResult = Result.ok(layoutBooking());
  final workshopRepo = FakeWorkshopRepository()
    ..workshopResult = const Result.ok(layoutWorkshop)
    ..workshopsResult = Result.ok(workshops ?? const [layoutWorkshop])
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
    ..motorsResult = Result.ok([layoutVario, layoutBeat, layoutPcx]);
  final catalog = FakeCatalogRepository()
    ..serviceTypesResult = const Result.ok([layoutSvcBerkala, layoutSvcRem])
    ..partsResult = const Result.ok([layoutOil])
    ..vouchersResult = Result.ok([layoutVoucher]);
  return [
    bookingRepositoryProvider.overrideWithValue(booking),
    workshopRepositoryProvider.overrideWithValue(workshopRepo),
    garageRepositoryProvider.overrideWithValue(garage),
    catalogRepositoryProvider.overrideWithValue(catalog),
    clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 28, 10, 20))),
  ];
}

void Function(FlutterErrorDetails)? _previousOnError;

List<FlutterErrorDetails> captureLayoutErrors() {
  final errors = <FlutterErrorDetails>[];
  _previousOnError = FlutterError.onError;
  FlutterError.onError = errors.add;
  addTearDown(() => FlutterError.onError = _previousOnError);
  return errors;
}

void expectNoLayoutErrors(List<FlutterErrorDetails> errors) {
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

Future<void> pumpLayoutScreen(
  WidgetTester tester,
  Widget screen, {
  required Size size,
  required double scale,
  List<Override>? overrides,
  int settleFrames = 20,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: overrides ?? layoutFakes(),
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
  for (var i = 0; i < settleFrames; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

class LayoutSummaryReady extends ConsumerStatefulWidget {
  const LayoutSummaryReady({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<LayoutSummaryReady> createState() => _LayoutSummaryReadyState();
}

class _LayoutSummaryReadyState extends ConsumerState<LayoutSummaryReady> {
  @override
  void initState() {
    super.initState();
    Future(() => ref.read(ringkasanViewModelProvider.notifier).reload());
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftProvider);
    final summary = ref.watch(ringkasanViewModelProvider);
    if (draft == null || summary.isLoading) return const SizedBox.shrink();
    return widget.child;
  }
}
