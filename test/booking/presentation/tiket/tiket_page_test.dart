import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/tiket/tiket_page.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_workshop_repository.dart';

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

const _svc = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

BookingUnit _unit(String code, String id, String name) => BookingUnit(
  unitCode: code,
  motorId: id,
  motorSnapshot: Motor(
    id: id,
    ownerId: 'u1',
    nickname: name,
    plateNumber: 'AB 1234 XY',
    modelId: 'model_x',
  ),
  serviceIds: const ['svc_berkala'],
  partIds: const [],
  status: UnitStatus.terjadwal,
  statusHistory: [
    StatusEvent(status: UnitStatus.terjadwal, timestamp: DateTime(2026, 9, 28)),
  ],
  subtotal: 85000,
  durationMin: 60,
);

final _booking = Booking(
  id: 'bk_1',
  code: 'TS-260929-0417',
  userId: 'u1',
  workshopId: 'ws_001',
  units: [
    _unit('-A', 'm1', 'Vario 125'),
    _unit('-B', 'm2', 'Beat 110'),
    _unit('-C', 'm3', 'PCX 160'),
  ],
  scheduleMode: ScheduleMode.shared,
  sharedSlot: TimeSlot(
    date: DateTime(2026, 9, 29),
    hour: 9,
    capacity: 5,
    booked: 1,
  ),
  status: BookingStatus.terjadwal,
  subtotal: 428000,
  discount: 42800,
  total: 385200,
  createdAt: DateTime(2026, 9, 28),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  Future<void> pumpPage(WidgetTester tester, {double textScale = 1}) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(
            FakeBookingRepository()..getBookingResult = Result.ok(_booking),
          ),
          workshopRepositoryProvider.overrideWithValue(
            FakeWorkshopRepository()..workshopResult = const Result.ok(_jaya),
          ),
          catalogRepositoryProvider.overrideWithValue(
            FakeCatalogRepository()
              ..serviceTypesResult = const Result.ok([_svc]),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const TiketPage(bookingId: 'bk_1'),
        ),
      ),
    );
  }

  testWidgets('first frame: skeleton ticket, "Lacak status" disabled with '
      'the reason', (tester) async {
    await pumpPage(tester);

    expect(find.text('Booking berhasil!'), findsOneWidget);
    expect(find.text('Membuat tiket…'), findsOneWidget);
    expect(find.text('Aktif setelah tiket dibuat'), findsOneWidget);
    expect(find.text('Kembali ke beranda'), findsOneWidget);

    // Let the load finish so no timers leak past the test.
    await tester.pumpAndSettle();
  });

  testWidgets('populated: code once, 3 unit rows, recap, total; copy shows '
      'the snackbar', (tester) async {
    await pumpPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('TS-260929-0417'), findsOneWidget);
    expect(find.text('Vario 125'), findsOneWidget);
    expect(find.text('Unit -C · Servis Berkala'), findsOneWidget);
    expect(find.text('Terjadwal'), findsNWidgets(3));
    expect(find.text('Bengkel Jaya Motor'), findsOneWidget);
    expect(find.text('Sel, 29 Sep 2026 · 09.00'), findsOneWidget);
    expect(
      find.text('Total estimasi · Bayar di bengkel · Rp385.200'),
      findsOneWidget,
    );
    expect(find.text('Aktif setelah tiket dibuat'), findsNothing);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );
    await tester.tap(find.byIcon(Icons.content_copy_rounded));
    await tester.pump();
    await tester.pump();
    expect(find.text('Kode booking disalin'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 6));
  });

  testWidgets('stress: 360×640 at text ×1.3 renders without overflow', (
    tester,
  ) async {
    await pumpPage(tester, textScale: 1.3);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Lacak status'), findsOneWidget);
  });
}
